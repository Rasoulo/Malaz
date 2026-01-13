import 'package:malaz/domain/entities/review/review.dart';

class ReviewsList {
  final List<Review> reviews;
  final String? nextCursor;

  ReviewsList({required this.reviews, this.nextCursor});
}