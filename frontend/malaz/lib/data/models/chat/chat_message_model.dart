import 'package:malaz/core/constants/app_constants.dart';
import 'package:malaz/data/models/user/user_model.dart';

class ChatMessageModel {
  final int id;
  final int conversationId;
  final int senderId;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;
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
    final msg = json['message'] ?? json;
    return ChatMessageModel(
      id: msg['id'],
      conversationId: msg['conversation_id'],
      senderId: msg['sender_id'],
      body: msg['body'],
      readAt: msg['read_at'] != null ? DateTime.parse(msg['read_at']) : null,
      createdAt: DateTime.parse(msg['created_at']),
      updatedAt: DateTime.parse(msg['updated_at']),
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
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      conversationId: this.conversationId,
      readAt: this.readAt,
      updatedAt: this.updatedAt,
    );
  }

  bool get isEdited {
    return updatedAt.isAfter(createdAt.add(const Duration(seconds: 1)));
  }
}