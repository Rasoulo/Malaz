import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../entities/apartment/apartment.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Apartment>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(int apartmentId);
  Future<Either<Failure, void>> delFavorite(int apartmentId);
}

