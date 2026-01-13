import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/review/review.dart';
import '../../repositories/review/review_repository.dart';

class GetReviewsUseCase {
  final ReviewsRepository repository;

  GetReviewsUseCase(this.repository);

    Future<Either<Failure, ReviewsList>> call({
    required int propertyId,
    String? cursor
  }) async {
    return await repository.getReviews(propertyId: propertyId, cursor: cursor);
  }
}