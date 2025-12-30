import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/chat_message_model.dart';
import '../../../data/models/conversation_model.dart';
import '../../../domain/repositories/chat/chat_repository.dart';

/////////////////////////  Chat States ///////////////////////////

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatConversationsLoading extends ChatState {}

class ChatConversationsLoaded extends ChatState {
  final List<ConversationModel> conversations;
  ChatConversationsLoaded(this.conversations);
}

class ChatMessagesInitialLoading extends ChatState {}

class ChatMessagesLoaded extends ChatState {
  final List<ChatMessageModel> messages;
  ChatMessagesLoaded(this.messages);
}

class ChatMessageSent extends ChatState {}

class ChatConversationsError extends ChatState {
  final String message;
  ChatConversationsError(this.message);
}



/////////////////////////  Chat Cubit ////////////////////////////

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit({required this.repository}) : super(ChatInitial());

  Future<void> getConversations() async {
    emit(ChatConversationsLoading());
    final result = await repository.getConversations();
    if (isClosed) return;
    result.fold(
          (failure) => emit(ChatConversationsError(failure.message.toString())),
          (conversations) => emit(ChatConversationsLoaded(conversations)),
    );
  }

  Future<void> getMessages(int conversationId) async {
    if (state is! ChatMessagesLoaded) {
      emit(ChatMessagesInitialLoading());
    }

    final result = await repository.getMessages(conversationId);
    result.fold(
          (failure) => emit(ChatConversationsError(failure.message.toString())),
          (messages) => emit(ChatMessagesLoaded(messages)),
    );
  }

  Future<void> sendMessage(int conversationId, String body, int myId) async {
    if (state is! ChatMessagesLoaded) return;

    final currentState = state as ChatMessagesLoaded;
    final oldMessages = List<ChatMessageModel>.from(currentState.messages);

    final tempMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      senderId: myId,
      body: body,
      createdAt: DateTime.now(),
      conversationId: conversationId,
      readAt: null,
      updatedAt: DateTime.now(),
    );

    emit(ChatMessagesLoaded([tempMessage, ...oldMessages]));

    final result = await repository.sendMessage(conversationId, body);

    result.fold(
          (failure) {
        emit(ChatMessagesLoaded(oldMessages));
      },
          (successData) {
        getMessages(conversationId);
      },
    );
  }

  Future<void> deleteMessage(int messageId) async {
    if (state is! ChatMessagesLoaded) return;
    final currentState = state as ChatMessagesLoaded;

    final updatedList = currentState.messages.where((m) => m.id != messageId).toList();
    emit(ChatMessagesLoaded(updatedList));

    final result = await repository.deleteMessage(messageId);
    if (isClosed) return;
    result.fold(
          (failure) => emit(currentState),
          (_) => null,
    );
  }

  Future<void> editMessage(int messageId, String newBody) async {
    if (state is! ChatMessagesLoaded) return;
    final currentState = state as ChatMessagesLoaded;

    final updatedList = currentState.messages.map((m) {
      return m.id == messageId ? m.copyWith(body: newBody) : m;
    }).toList();

    emit(ChatMessagesLoaded(updatedList));

    final result = await repository.editMessage(messageId, newBody);

    result.fold(
          (failure) {
        emit(currentState);
      },
          (_) => null,
    );
  }

  Future<void> deleteConversation(int conversationId) async {
    emit(ChatConversationsLoading());
    final result = await repository.deleteConversation(conversationId);

    result.fold(
          (failure) => emit(ChatConversationsError(failure.message.toString())),
          (_) {
        getConversations();
      },
    );
  }

  Future<void> markMessageAsRead(int messageId) async {
    final result = await repository.markAsRead(messageId);
    result.fold((f) => null, (s) => null);
  }

  void onMessageReadReceived(Map<String, dynamic> data) {
    if (state is ChatMessagesLoaded) {
      final msgData = data['message'] ?? data;
      final updatedMsg = ChatMessageModel.fromJson(msgData);

      final currentMessages = (state as ChatMessagesLoaded).messages;

      final newList = currentMessages.map((msg) {
        return msg.id == updatedMsg.id ? updatedMsg : msg;
      }).toList();

      emit(ChatMessagesLoaded(newList));
    }
  }
}