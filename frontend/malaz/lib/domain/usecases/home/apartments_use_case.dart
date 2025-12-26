
import 'package:malaz/domain/entities/apartment.dart';
import 'package:malaz/domain/repositories/apartment_repository.dart';

import '../../entities/apartments_list.dart';

class GetApartmentsUseCase {
  final ApartmentRepository repository;

  GetApartmentsUseCase(this.repository);

  Future<ApartmentsList> call({required String? cursor}) async {
    return await repository.getApartments(cursor: cursor);
  }
}
