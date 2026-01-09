import '../../entities/location/location_entity.dart';
import '../../repositories/location/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;
  GetCurrentLocationUseCase(this.repository);

  Future<LocationEntity> call(String lang) async => await repository.getCurrentLocation(lang);
}