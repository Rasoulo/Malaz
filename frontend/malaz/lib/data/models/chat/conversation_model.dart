import 'package:malaz/data/models/user/user_model.dart';

class ConversationModel {
  final int id;
  final int userOneId;
  final int userTwoId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int unreadCount;
  final UserModel? userOne;
  final UserModel? userTwo;

  ConversationModel({
    required this.id,
    required this.userOneId,
    required this.userTwoId,
    required this.createdAt,
    required this.updatedAt,
    required this.unreadCount,
    this.userOne,
    this.userTwo,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as int,
      userOneId: json['user_one_id'] as int,
      userTwoId: json['user_two_id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      unreadCount: json['unread_count'] ?? 0,
      userOne: json['user_one'] != null
          ? UserModel.fromJson(json['user_one'] as Map<String, dynamic>)
          : null,
      userTwo: json['user_two'] != null
          ? UserModel.fromJson(json['user_two'] as Map<String, dynamic>)
          : null,
    );
  }
}