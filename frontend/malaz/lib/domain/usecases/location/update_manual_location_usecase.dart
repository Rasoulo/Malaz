import '../../entities/location_entity.dart';
import '../../repositories/location/location_repository.dart' show LocationRepository;

class UpdateManualLocationUseCase {
  final LocationRepository repository;
  UpdateManualLocationUseCase(this.repository);

  Future<LocationEntity> call(double lat, double lng, String lang) async =>
      await repository.updateManualLocation(lat, lng, lang);
}