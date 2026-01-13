class Review {
  final int id;
  final String body;
  final int rating;
  final String createdAt;
  final int userId;
  final String userName;
  final String userImage;

  Review({
    required this.id,
    required this.body,
    required this.rating,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.userImage,
  });
}

class ReviewsList {
  final List<Review> reviews;
  final String? nextCursor;

  ReviewsList({required this.reviews, this.nextCursor});
}