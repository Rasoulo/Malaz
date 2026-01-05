import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/entities/apartment.dart';
import '../../../domain/repositories/favorites/favorites_repository.dart';
import '../../datasources/remote/favorites/favorites_remote_datasource.dart';
import '../../utils/failure_mapper.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Apartment>>> getFavorites() async {
    try {
      final result = await remoteDataSource.getFavorites();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(int apartmentId) async {
    try {
      await remoteDataSource.addFavorite(apartmentId);
      return const Right(null);
    } catch(e) {
      final failure = FailureMapper.map(e);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> delFavorite(int apartmentId) async {
    try {
      await remoteDataSource.delFavorite(apartmentId);
      return Right(null);
    } catch(e) {
      final failure = FailureMapper.map(e);
      return Left(failure);
    }
  }
}