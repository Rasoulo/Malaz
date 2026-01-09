
import 'package:malaz/domain/repositories/apartment/apartment_repository.dart';

import '../../entities/apartment/apartments_list.dart';
import '../../entities/filters/filters.dart';

class GetApartmentsUseCase {
  final ApartmentRepository repository;

  GetApartmentsUseCase(this.repository);

  Future<ApartmentsList> call({required String? cursor, Filter? filter}) async {
    return await repository.getApartments(cursor: cursor, filter: filter);
  }
}
