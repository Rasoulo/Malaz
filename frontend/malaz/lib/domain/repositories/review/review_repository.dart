import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../entities/review/review.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, ReviewsList>> getReviews({
    required int propertyId,
    String? cursor,
  });
}