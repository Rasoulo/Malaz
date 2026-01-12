import 'dart:convert';
import 'dart:developer';
import 'package:malaz/core/constants/app_constants.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:http/http.dart' as http;

class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  bool _isInitialized = false;

  Future<void> init({required String token}) async {
    if (_isInitialized) return;

    try {
      await pusher.init(
        apiKey: AppConstants.apiKeyForPusher,
        cluster: AppConstants.clusterForPusher,
        onAuthorizer: (channelName, socketId, options) async {
          log(">>>> [Pusher] Manual Authorizing for: $channelName");

          try {
            final response = await http.post(
              Uri.parse(AppConstants.baseurlForPusher),
              headers: {
                "Authorization": "Bearer $token",
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
              },
              body: {
                "socket_id": socketId,
                "channel_name": channelName,
              },
            );

            if (response.statusCode == 200) {
              final jsonResponse = jsonDecode(response.body);
              log(">>>> [Pusher] Auth Success for $channelName");
              return jsonResponse;
            } else {
              log(">>>> [Pusher] Server Refused Auth: ${response.statusCode}");
              return null;
            }
          } catch (e) {
            log(">>>> [Pusher] HTTP Auth Exception: $e");
            return null;
          }
        },
        onConnectionStateChange: (current, previous) => log(">>>> Pusher: $previous -> $current"),
        onSubscriptionSucceeded: (name, data) => log(">>>> Successfully Subscribed to $name"),
        onSubscriptionError: (msg, err) => log(">>>> Subscription Error: $msg"),
        onError: (msg, code, err) => log(">>>> Pusher Error: [$code] $msg"),
      );

      await pusher.connect();
      _isInitialized = true;
    } catch (e) {
      log(">>>> Pusher Critical Init Error: $e");
    }
  }

  Future<void> subscribe({
    required String channelName,
    required Function(PusherEvent event) onEvent,
  }) async {
    try {
      log(">>>> Preparing channel: $channelName");
      await pusher.unsubscribe(channelName: channelName);

      await pusher.subscribe(
        channelName: channelName,
          onEvent: (dynamic event) {
            if (event is PusherEvent) {
              log(">>>> New Event: [${event.eventName}]");

              if (event.eventName.startsWith('pusher:')) {
                log(">>>> Internal Pusher Event ignored.");
                return;
              }

              try {
                final dynamic rawData = event.data;
                Map<String, dynamic> decodedData;

                if (rawData is String) {
                  decodedData = jsonDecode(rawData);
                } else if (rawData is Map) {
                  decodedData = Map<String, dynamic>.from(rawData);
                } else {
                  decodedData = {};
                }

                onEvent(PusherEvent(
                  channelName: event.channelName,
                  eventName: event.eventName,
                  data: jsonEncode(decodedData),
                ));
              } catch (e) {
                log(">>>> JSON Parsing Error: $e");
              }
            }
          }
      );

      log(">>>> Subscription request sent for $channelName");

    } catch (e) {
      log(">>>> Subscription Error in PusherService: $e");
    }
  }

  Future<void> unsubscribe(String channelName) async {
    try {
      await pusher.unsubscribe(channelName: channelName);
      log(">>>> Unsubscribed from $channelName");
    } catch (e) {
      log(">>>> Unsubscribe Error: $e");
    }
  }
}