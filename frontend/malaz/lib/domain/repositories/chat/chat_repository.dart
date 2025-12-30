import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/chat_message_model.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ConversationModel>>> getConversations();
  Future<Either<Failure, List<ChatMessageModel>>> getMessages(int conversationId);
  Future<Either<Failure, void>> sendMessage(int conversationId, String body);
  Future<Either<Failure, Unit>> deleteMessage(int messageId);
  Future<Either<Failure, Unit>> editMessage(int messageId, String newBody);
  Future<Either<Failure, Unit>> deleteConversation(int conversationId);
  Future<Either<Failure, void>> markAsRead(int messageId);
}