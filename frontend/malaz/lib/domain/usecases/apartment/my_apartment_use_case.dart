import '../../entities/apartments_list.dart';
import '../../repositories/apartment/apartment_repository.dart';

class GetMyApartmentsUseCase {
  final ApartmentRepository repository;

  GetMyApartmentsUseCase(this.repository);

  Future<ApartmentsList> call({required String? cursor}) async {
    return await repository.getMyApartments(cursor: cursor);
  }
}