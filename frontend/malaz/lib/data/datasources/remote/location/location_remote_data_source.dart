import 'dart:convert';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

abstract class LocationRemoteDataSource {
  Future<LocationData?> getRawLocation();
  Future<String> getAddressFromCoords(double lat, double lng, String lang);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Location location;
  final http.Client client;
  LocationRemoteDataSourceImpl({required this.location, required this.client});

  @override
  Future<LocationData?> getRawLocation() async {
    bool s = await location.serviceEnabled();
    if (!s) s = await location.requestService();
    if (!s) return null;
    PermissionStatus p = await location.hasPermission();
    if (p == PermissionStatus.denied) p = await location.requestPermission();
    if (p != PermissionStatus.granted) return null;
    return await location.getLocation();
  }

  @override
  Future<String> getAddressFromCoords(double lat, double lng, String lang) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng');

    try {
      final response = await client.get(
        url,
        headers: {
          'Accept-Language': lang,
          'User-Agent': 'Malaz_App',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final addr = data['address'];

        if (addr == null) return "Unknown Address";

        final city = addr['city'] ?? addr['town'] ?? addr['village'] ?? addr['suburb'] ?? '';
        final country = addr['country'] ?? '';

        if (city.isEmpty && country.isEmpty) return "Location found, Address not resolved";

        return city.isNotEmpty ? "$city, $country" : country;
      }
      return "API Error (${response.statusCode})";
    } catch (e) {
      return "Connection Error";
    }
  }
}