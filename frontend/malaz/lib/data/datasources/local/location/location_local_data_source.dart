import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/location/location_entity.dart';
import '../../../models/location/location_model.dart';

abstract class LocationLocalDataSource {
  Future<void> cacheLocation(LocationModel location);

  Future<LocationEntity?> getCachedLocation();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final SharedPreferences sharedPreferences;

  LocationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheLocation(LocationModel location) async {
    final jsonString = json.encode(location.toJson());
    await sharedPreferences.setString(AppConstants.locationKey, jsonString);
  }

  @override
  Future<LocationEntity?> getCachedLocation() async {
    final jsonString = sharedPreferences.getString(AppConstants.locationKey);

    print('>>>>>>>>>>${jsonString}');
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);

        return LocationModel.fromJson(jsonMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}