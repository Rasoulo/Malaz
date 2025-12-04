
import 'package:malaz/data/datasources/apartment_remote_data_source.dart';
import 'package:malaz/domain/entities/apartment.dart';
import 'package:malaz/domain/repositories/apartment_repository.dart';

class ApartmentRepositoryImpl implements ApartmentRepository {
  final ApartmentRemoteDataSource remoteDataSource;
  // In a real app, you would also have a localDataSource here to handle caching.
  // final ApartmentLocalDataSource localDataSource;

  ApartmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Apartment>> getApartments() async {
    // In a real app with caching and error handling, the logic would be more complex:
    // 1. Check network connection.
    // 2. If connected, fetch from remoteDataSource, cache the data, and return it.
    // 3. If not connected, try to fetch from localDataSource.
    // 4. Handle exceptions and return Failures (using Either).

    // For now, we just pass the call to the remote data source.
    try {
      final remoteApartments = await remoteDataSource.getApartments();
      return remoteApartments;
    } catch (e) {
      // In a real app, you would catch specific exceptions (e.g., ServerException)
      // and return a specific Failure (e.g., ServerFailure).
      // For now, we rethrow the exception.
      rethrow;
    }
  }
}
