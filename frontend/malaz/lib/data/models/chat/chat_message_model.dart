import 'package:malaz/core/constants/app_constants.dart';

import '../user/user_model.dart';

class ChatMessageModel {
  final int id;
  final int conversationId;
  final int senderId;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserModel? sender;

  String get senderImageUrl => AppConstants.userProfileImage(senderId);

  ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.body,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      senderId: int.tryParse(json['sender_id'].toString()) ?? 0,
      conversationId: int.tryParse(json['conversation_id'].toString()) ?? 0,
      body: json['body'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  ChatMessageModel copyWith({
    int? id,
    int? senderId,
    String? body,
    DateTime? createdAt,
    int? conversationId,
    DateTime? readAt,
    DateTime? updatedAt,
    UserModel? sender,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
      readAt: readAt ?? this.readAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sender: sender ?? this.sender,
    );
  }

  bool get isEdited {
    if (updatedAt == null) return false;
    return updatedAt!.isAfter(createdAt.add(const Duration(seconds: 1)));
  }
}