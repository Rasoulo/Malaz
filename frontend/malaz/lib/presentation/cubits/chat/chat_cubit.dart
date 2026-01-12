import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/chat/chat_message_model.dart';
import '../../../data/models/chat/conversation_model.dart';
import '../../../domain/repositories/chat/chat_repository.dart';

/////////////////////////  Chat States ///////////////////////////

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatConversationsLoaded extends ChatState {
  final List<ConversationModel> conversations;
  ChatConversationsLoaded(this.conversations);
}

class ChatMessagesInitialLoading extends ChatState {}

class ChatMessagesLoaded extends ChatState {
  final List<ChatMessageModel> messages;
  final int conversationId;

  ChatMessagesLoaded({
    required this.messages,
    required this.conversationId,
  });

  ChatMessagesLoaded copyWith({
    List<ChatMessageModel>? messages,
    int? conversationId,
  }) {
    return ChatMessagesLoaded(
      messages: messages ?? this.messages,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}

class ChatConversationsError extends ChatState {
  final String message;
  ChatConversationsError(this.message);
}


/////////////////////////  Chat Cubit ////////////////////////////

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  List<ChatMessageModel> allMessages = [];

  ChatCubit({required this.repository}) : super(ChatInitial());

  void handlePusherEvent(String eventName, Map<String, dynamic> data) {
    if (state is! ChatMessagesLoaded) return;
    final currentState = state as ChatMessagesLoaded;

    final msgData = data['message'] ?? data;
    final incomingMsg = ChatMessageModel.fromJson(msgData);

    switch (eventName) {
      case 'MessageSent':
        _handleIncomingNewMessage(currentState, incomingMsg);
        break;
      case 'MessageUpdated':
        _handleIncomingUpdate(currentState, incomingMsg);
        break;
      case 'MessageDeleted':
        _handleIncomingDelete(currentState, incomingMsg.id);
        break;
      case 'MessageRead':
        _handleIncomingUpdate(currentState, incomingMsg);
        break;
    }
  }

  void _handleIncomingNewMessage(ChatMessagesLoaded currentState, ChatMessageModel msg) {
    final bool alreadyExists = currentState.messages.any((m) => m.id == msg.id);

    if (!alreadyExists) {
      final updatedMessages = [msg, ...currentState.messages];
      emit(currentState.copyWith(messages: updatedMessages));
    }
  }

  void _handleIncomingUpdate(ChatMessagesLoaded currentState, ChatMessageModel msg) {
    final newList = currentState.messages.map((m) => m.id == msg.id ? msg : m).toList();
    emit(currentState.copyWith(messages: newList));
  }

  void _handleIncomingDelete(ChatMessagesLoaded currentState, int msgId) {
    final newList = currentState.messages.where((m) => m.id != msgId).toList();
    emit(currentState.copyWith(messages: newList));
  }

  Future<void> getConversations() async {
    emit(ChatLoading());
    final result = await repository.getConversations();
    if (isClosed) return;
    result.fold(
          (failure) => emit(ChatConversationsError(failure.message.toString())),
          (conversations) => emit(ChatConversationsLoaded(conversations)),
    );
  }

  Future<void> deleteConversation(int conversationId) async {
    emit(ChatLoading());
    final result = await repository.deleteConversation(conversationId);
    result.fold(
          (failure) => emit(ChatConversationsError(failure.message.toString())),
          (_) => getConversations(),
    );
  }

  Future<int?> saveNewConversation(int otherUserId) async {
    clearMessages();
    final result = await repository.saveNewConversation(otherUserId);
    return result.fold(
          (failure) => null,
          (conversation) {
        emit(ChatMessagesLoaded(messages: [], conversationId: conversation.id));
        return conversation.id;
      },
    );
  }

  void getMessages(int conversationId, {bool isSilent = false}) async {
    if (!isSilent) emit(ChatMessagesInitialLoading());
    final result = await repository.getMessages(conversationId);
    result.fold(
          (error) => emit(ChatConversationsError(error.toString())),
          (messages) {
        allMessages = messages;
        emit(ChatMessagesLoaded(messages: messages, conversationId: conversationId));
      },
    );
  }

  Future<void> sendMessage(int conversationId, String body, int myId) async {
    if (state is! ChatMessagesLoaded) return;
    final currentState = state as ChatMessagesLoaded;

    final result = await repository.sendMessage(conversationId, body);

    result.fold(
          (failure) {
        log(">>>> Send Message Failed: ${failure.message}");
      },
          (actualMsg) {
        log(">>>> Message Received and Adding to UI: ${actualMsg.id}");

        final updatedList = [actualMsg, ...currentState.messages];

        emit(currentState.copyWith(messages: updatedList));
      },
    );
  }

  Future<void> editMessage(int messageId, String newBody) async {
    if (state is! ChatMessagesLoaded) return;
    final currentState = state as ChatMessagesLoaded;

    final updatedList = currentState.messages.map((m) {
      return m.id == messageId ? m.copyWith(body: newBody, updatedAt: DateTime.now()) : m;
    }).toList();
    emit(currentState.copyWith(messages: updatedList));

    final result = await repository.editMessage(messageId, newBody);
    result.fold(
          (failure) => emit(currentState),
          (_) => null,
    );
  }

  Future<void> deleteMessage(int messageId) async {
    if (state is! ChatMessagesLoaded) return;
    final currentState = state as ChatMessagesLoaded;

    final updatedList = currentState.messages.where((m) => m.id != messageId).toList();
    emit(currentState.copyWith(messages: updatedList));

    final result = await repository.deleteMessage(messageId);
    result.fold(
          (failure) => emit(currentState),
          (_) => null,
    );
  }

  Future<void> markMessageAsRead(int conversationId) async {
    if (state is ChatConversationsLoaded) {
      final currentState = state as ChatConversationsLoaded;
      final updatedConvs = currentState.conversations.map((c) {
        if (c.id == conversationId) {
          return c.copyWith(unreadCount: 0);
        }
        return c;
      }).toList();
      emit(ChatConversationsLoaded(updatedConvs));
    }

    await repository.markAsRead(conversationId);
  }

  void clearMessages() {
    allMessages = [];
    emit(ChatInitial());
  }
}