class ChatMessageEntity {
  final int id;
  final int conversationId;
  final int senderId;
  final String body;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.body,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isRead => readAt != null;

  bool get isEdited => updatedAt.isAfter(createdAt.add(const Duration(seconds: 1)));
}