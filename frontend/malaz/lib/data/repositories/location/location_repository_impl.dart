import '../../../domain/entities/location_entity.dart';
import '../../../domain/repositories/location/location_repository.dart';
import '../../datasources/local/location_local_data_source.dart';
import '../../datasources/remote/location/location_remote_data_source.dart';
import '../../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource
  });

  @override
  Future<LocationEntity> getCurrentLocation(String lang) async {
    final raw = await remoteDataSource.getRawLocation();
    if (raw == null) throw Exception("Location access denied");

    final address = await remoteDataSource.getAddressFromCoords(
        raw.latitude!,
        raw.longitude!,
        lang
    );

    final model = LocationModel(
        lat: raw.latitude!,
        lng: raw.longitude!,
        address: address
    );

    await localDataSource.cacheLocation(model);
    return model;
  }

  @override
  Future<LocationEntity?> getSavedLocation() async {
    return await localDataSource.getCachedLocation();
  }

  @override
  Future<LocationEntity> updateManualLocation(double lat, double lng, String lang) async {
    final address = await remoteDataSource.getAddressFromCoords(lat, lng, lang);

    final model = LocationModel(
        lat: lat,
        lng: lng,
        address: address
    );

    await localDataSource.cacheLocation(model);
    return model;
  }
}