import '../../../domain/entities/review/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    required super.id,
    required super.body,
    required super.rating,
    required super.createdAt,
    required super.userId,
    required super.userName,
    required super.userImage,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {};

    return ReviewModel(
      id: json['id'],
      body: json['body'] ?? "",
      rating: json['rating'] ?? 0,
      createdAt: json['created_at'] ?? "",
      userId: userJson['id'] ?? 0,
      userName: "${userJson['first_name'] ?? ''} ${userJson['last_name'] ?? ''}".trim(),
      userImage: userJson['profile_image_url'] ?? "",
    );
  }
}