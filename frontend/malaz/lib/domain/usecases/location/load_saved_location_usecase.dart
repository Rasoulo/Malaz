import '../../entities/location_entity.dart';
import '../../repositories/location/location_repository.dart';

class LoadSavedLocationUseCase {
  final LocationRepository repository;
  LoadSavedLocationUseCase(this.repository);

  Future<LocationEntity?> call() async => await repository.getSavedLocation();
}