import '../../entities/location_entity.dart';

abstract class LocationRepository {
  Future<LocationEntity> getCurrentLocation(String lang);
  Future<LocationEntity?> getSavedLocation();
  Future<LocationEntity> updateManualLocation(double lat, double lng, String lang);
}