import 'dart:convert';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationService {
  Location location = Location();

  Future<LocationData?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    try {
      return await location.getLocation();
    } catch (e) {
      print("خطأ في جلب الموقع: $e");
      return null;
    }
  }

  Future<String> getAddressFromCoords(double lat, double lng, String languageCode) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=10');

      final response = await http.get(url, headers: {
        'User-Agent': 'MalazApp_Development',
        'Accept-Language': languageCode,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];

        String city = address['city'] ?? address['town'] ?? address['village'] ?? address['state'] ?? "";
        String country = address['country'] ?? "";

        return "$city, $country";
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
    return "Unknown";
  }
}