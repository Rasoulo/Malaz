import 'dart:convert';
import 'dart:developer';

import '../../../../../core/network/network_service.dart';

abstract class ChatRemoteDataSource {
  Future<Map<String, dynamic>> getConversations();
  Future<Map<String, dynamic>> getMessages(int conversationId);
  Future<Map<String, dynamic>> sendMessage(int conversationId, String body);
  Future<Map<String, dynamic>> deleteMessage(int messageId);
  Future<Map<String, dynamic>> editMessage(int messageId, String newBody);
  Future<Map<String, dynamic>> saveNewConversation(int ownerId);
  Future<Map<String, dynamic>> deleteConversation(int conversationId);
  Future<Map<String, dynamic>> markAsRead(int messageId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final NetworkService networkService;

  ChatRemoteDataSourceImpl({required this.networkService});

  @override
  Future<Map<String, dynamic>> getConversations() async {
    final response = await networkService.get('/conversations');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> getMessages(int conversationId) async {
    final response = await networkService.get('/conversations/$conversationId/messages');
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> sendMessage(int conversationId, String body) async {
    try {
      final response = await networkService.post(
        '/conversations/$conversationId/messages',
        data: {'body': body},
      );

      log(">>>> Server Raw Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else if (response.data is String) {
          return jsonDecode(response.data);
        }
        return response.data;
      } else {
        throw Exception("Failed to send message: ${response.statusCode}");
      }
    } catch (e) {
      log(">>>> Error in RemoteDataSource: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> deleteMessage(int messageId) async {
    final response = await networkService.delete(
      '/messages/$messageId',
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> editMessage(int messageId, String newBody) async {
    final response = await networkService.put(
      '/messages/$messageId',
      queryParameters: {
        'body': newBody,
      },
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> saveNewConversation(int ownerId) async {
    final response = await networkService.post(
      '/conversations/$ownerId',
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> deleteConversation(int conversationId) async {
    final response = await networkService.delete(
      '/conversations/$conversationId',
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> markAsRead(int messageId) async {
    final response = await networkService.post(
      '/messages/$messageId/read',
    );
    return response.data;
  }
}