
import 'package:malaz/data/datasources/remote/apartment/apartment_remote_data_source.dart';
import 'package:malaz/domain/repositories/apartment/apartment_repository.dart';

import '../../../domain/entities/apartments_list.dart';

class ApartmentRepositoryImpl implements ApartmentRepository {
  final ApartmentRemoteDataSource remoteDataSource;

  ApartmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApartmentsList> getApartments({required String? cursor}) async {
    try {
      final remoteApartments = await remoteDataSource.getApartments(cursor: cursor);
      return remoteApartments;
    } catch (e) {
      rethrow;
    }
  }
}
