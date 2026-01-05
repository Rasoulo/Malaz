
import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/domain/repositories/favorites/favorites_repository.dart';

import '../../entities/apartment.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<Apartment>>> call() async {
    return await repository.getFavorites();
  }
}