import 'package:dartz/dartz.dart';
import 'package:malaz/core/errors/failures.dart';

import '../../repositories/review/review_repository.dart';

class AddReviewsUseCase {
  final ReviewsRepository repository;

  AddReviewsUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String rating,
    required String body,
    required int idProperty
  }) async {
    return await repository.addReview(rating: rating, body: body,idProperty: idProperty);
  }
}