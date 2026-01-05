
import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';
import 'package:malaz/domain/repositories/favorites/favorites_repository.dart';

class DeleteFavoriteUseCase {
  final FavoritesRepository repository;

  DeleteFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(int apartmentId) async {
    return await repository.delFavorite(apartmentId);
  }
}
