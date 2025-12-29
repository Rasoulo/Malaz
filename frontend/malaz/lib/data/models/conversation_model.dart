import 'package:malaz/data/models/user_model.dart';

class ConversationModel {
  final int id;
  final int unreadCount;
  final UserModel userOne;
  final UserModel userTwo;

  ConversationModel({required this.id, required this.unreadCount, required this.userOne, required this.userTwo});

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      unreadCount: json['unread_count'] ?? 0,
      userOne: UserModel.fromJson(json['user_one']),
      userTwo: UserModel.fromJson(json['user_two']),
    );
  }
}