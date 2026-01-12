
import '../user/user_model.dart';

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
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userOneId: json['user_one_id'] as int,
      userTwoId: json['user_two_id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      unreadCount: json['unread_count'] is int
          ? json['unread_count']
          : int.parse(json['unread_count'].toString()),
      userOne: json['user_one'] != null
          ? UserModel.fromJson(json['user_one'] as Map<String, dynamic>)
          : null,
      userTwo: json['user_two'] != null
          ? UserModel.fromJson(json['user_two'] as Map<String, dynamic>)
          : null,
    );
  }

  ConversationModel copyWith({
    int? id,
    int? userOneId,
    int? userTwoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? unreadCount,
    UserModel? userOne,
    UserModel? userTwo,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      userOneId: userOneId ?? this.userOneId,
      userTwoId: userTwoId ?? this.userTwoId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      userOne: userOne ?? this.userOne,
      userTwo: userTwo ?? this.userTwo,
    );
  }
}