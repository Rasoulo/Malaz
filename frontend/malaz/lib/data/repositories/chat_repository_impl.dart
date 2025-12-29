import 'package:dartz/dartz.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/remote/chat_remote_datasource.dart';
import '../models/conversation_model.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ConversationModel>>> getConversations() async {
    try {
      final result = await remoteDataSource.getConversations();
      final List data = result['conversations'];
      return Right(data.map((e) => ConversationModel.fromJson(e)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getMessages(int conversationId) async {
    try {
      final result = await remoteDataSource.getMessages(conversationId);
      final List data = result['messages'];
      return Right(data.map((e) => ChatMessageModel.fromJson(e)).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(int conversationId, String body) async {
    try {
      await remoteDataSource.sendMessage(conversationId, body);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMessage(int messageId) async {
    try {
      await remoteDataSource.deleteMessage(messageId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> editMessage(int messageId, String newBody) async {
    try {
      await remoteDataSource.editMessage(messageId, newBody);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteConversation(int conversationId) async {
    try {
      await remoteDataSource.deleteConversation(conversationId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(int messageId) async {
    try {
      await remoteDataSource.markAsRead(messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}