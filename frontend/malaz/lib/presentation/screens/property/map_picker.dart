import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng _selectedLocation = const LatLng(33.5138, 36.2765);
  bool _isFetching = false;
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    try {
      final response = await http.get(url, headers: {'User-Agent': 'MalazApp'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          final newPos = LatLng(lat, lon);

          setState(() {
            _selectedLocation = newPos;
          });

          _mapController.move(newPos, 13.0);
        }
      }
    } catch (e) {
      debugPrint("Search Error: $e");
    }
  }

  Future<Map<String, String>> _getAddressDetails(double lat, double lng) async {
    final String appLocale = Localizations.localeOf(context).languageCode;
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng'
            '&accept-language=$appLocale'
            '&addressdetails=1'
    );
    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'MalazApp',
        'Accept-Language': appLocale,
      });

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final addr = data['address'] ?? {};

        List<String> addressParts = [];
        if (addr['amenity'] != null) addressParts.add(addr['amenity']);
        if (addr['building'] != null) addressParts.add(addr['building']);
        if (addr['road'] != null) addressParts.add(addr['road']);
        if (addr['neighbourhood'] != null) addressParts.add(addr['neighbourhood']);
        if (addr['suburb'] != null) addressParts.add(addr['suburb']);

        String fullAddress = addressParts.join(', ');

        if (fullAddress.isEmpty) {
          fullAddress = addr['tourism'] ?? addr['leisure'] ?? addr['shop'] ?? addr['place'] ?? '';
        }
        if (fullAddress.isEmpty) {
          fullAddress = addr['city'] ?? addr['town'] ?? addr['village'] ?? '';
        }
        if (fullAddress.isEmpty) {
          fullAddress = "${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}";
        }

        if (appLocale != 'ar') {
          fullAddress = fullAddress.replaceAll(RegExp(r'[\u0600-\u06FF]+'), '');
        }

        fullAddress = fullAddress.replaceAll(', ,', ',').replaceAll(RegExp(r',\s*,'), ',').trim();
        if (fullAddress.startsWith(',')) fullAddress = fullAddress.substring(1).trim();
        if (fullAddress.endsWith(',')) fullAddress = fullAddress.substring(0, fullAddress.length - 1);

        return {
          'city': (addr['city'] ?? addr['town'] ?? addr['village'] ?? '').toString(),
          'governorate': (addr['state'] ?? '').toString(),
          'address': fullAddress.isEmpty ? "Location Selected" : fullAddress,
        };
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return {'city': '', 'governorate': '', 'address': ''};
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 13.0,
              onTap: (tapPosition, point) => setState(() => _selectedLocation = point),
            ),
            children: [
              TileLayer(
                urlTemplate:'https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.malaz.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 4,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "search....",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon:  Icon(Icons.search, color: Theme.of(context).primaryColor),
                    onPressed: () => _searchLocation(_searchController.text),
                  ),
                ),
                onSubmitted: (value) => _searchLocation(value),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
              onPressed: _isFetching ? null : () async {
                setState(() => _isFetching = true);

                var details = await _getAddressDetails(
                    _selectedLocation.latitude,
                    _selectedLocation.longitude
                );

                if (!mounted) return;

                Navigator.pop(context, {
                  'lat': _selectedLocation.latitude,
                  'lng': _selectedLocation.longitude,
                  'details': details,
                });
              },
              child: _isFetching
                  ? const CircularProgressIndicator()
                  : const Text("Confirm location"),
            ),
          ),
        ],
      ),
    ));
  }
}