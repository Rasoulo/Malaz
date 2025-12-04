
import 'package:malaz/domain/entities/apartment.dart';
import 'package:malaz/domain/repositories/apartment_repository.dart';

class GetApartmentsUseCase {
  final ApartmentRepository repository;

  GetApartmentsUseCase(this.repository);

  Future<List<Apartment>> call() async {
    return await repository.getApartments();
  }
}
