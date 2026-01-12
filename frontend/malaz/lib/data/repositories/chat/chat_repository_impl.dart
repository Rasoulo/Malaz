import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../domain/repositories/chat/chat_repository.dart';
import '../../../core/errors/failures.dart';
import '../../datasources/remote/chat/chat_remote_datasource.dart';
import '../../models/chat/conversation_model.dart';
import '../../models/chat/chat_message_model.dart';

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
  Future<Either<Failure, ChatMessageModel>> sendMessage(int conversationId, String body) async {
    try {
      final result = await remoteDataSource.sendMessage(conversationId, body);

      if (result != null && result['data'] != null) {
        final Map<String, dynamic> msgData = Map<String, dynamic>.from(result['data']);

        final chatMessage = ChatMessageModel.fromJson(msgData);
        return Right(chatMessage);
      }

      return Left(ServerFailure("بيانات الرسالة غير موجودة في رد السيرفر"));
    } catch (e) {
      log("Mapping Error in Repo: $e");
      return Left(ServerFailure("حدث خطأ أثناء معالجة الرسالة: $e"));
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
  Future<Either<Failure, ConversationModel>> saveNewConversation(int partnerId) async {
    try {
      final result = await remoteDataSource.saveNewConversation(partnerId);

      if (result != null && result['conversation'] != null) {
        final Map<String, dynamic> conversationData = Map<String, dynamic>.from(result['conversation']);

        final conversationModel = ConversationModel.fromJson(conversationData);

        return Right(conversationModel);
      }
      /// TODO : translate it
      return Left(ServerFailure("بيانات المحادثة غير موجودة في رد السيرفر"));
    } catch (e) {
      print("Mapping Error: $e");
      return Left(ServerFailure("خطأ في معالجة البيانات: $e"));
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