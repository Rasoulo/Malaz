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
  final int conversationId; // تأكدي أن هذا الحقل موجود

  ChatMessagesLoaded({
    required this.messages,
    required this.conversationId,
  });

  // اختيارياً: إضافة copyWith لتسهيل التحديث المستقبلي
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

class ChatCreating extends ChatState {
  final ConversationModel conversationModel;
  ChatCreating(this.conversationModel);
}

class ChatAlreadyCreated extends ChatState {
  final ConversationModel conversationModel;
  ChatAlreadyCreated(this.conversationModel);
}

class ChatMessageSent extends ChatState {}

class ChatConversationsError extends ChatState {
  final String message;
  ChatConversationsError(this.message);
}



/////////////////////////  Chat Cubit ////////////////////////////

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;
  List<ChatMessageModel> allMessages = [];

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

  Future<void> sendMessage(int conversationId, String body, int myId) async {
    if (state is! ChatMessagesLoaded) return;

    final currentState = state as ChatMessagesLoaded;
    final oldMessages = currentState.messages;

    final tempMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      senderId: myId,
      body: body,
      createdAt: DateTime.now(),
      readAt: null,
      updatedAt: DateTime.now(),
      conversationId: conversationId,
    );

    emit(ChatMessagesLoaded(
      messages: [tempMessage, ...oldMessages],
      conversationId: conversationId,
    ));

    final result = await repository.sendMessage(conversationId, body);

    result.fold(
          (failure) => emit(currentState),
          (success) {
        getMessages(conversationId, isSilent: true);
      },
    );
  }

  Future<void> editMessage(int messageId, String newBody) async {
    if (state is! ChatMessagesLoaded) return;
    final currentState = state as ChatMessagesLoaded;

    final updatedList = currentState.messages.map((m) {
      if (m.id == messageId) {
        return m.copyWith(
            body: newBody,
            updatedAt: DateTime.now().add(const Duration(seconds: 1))
        );
      }
      return m;
    }).toList();

    emit(ChatMessagesLoaded(
        messages: updatedList,
        conversationId: currentState.conversationId
    ));

    final result = await repository.editMessage(messageId, newBody);

    result.fold(
          (failure) => emit(currentState),
          (updatedMessageFromServer) {
        getMessages(currentState.conversationId, isSilent: true);
      },
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

  Future<void> deleteMessage(int messageId) async {
    if (state is! ChatMessagesLoaded) return;
    final currentState = state as ChatMessagesLoaded;
    final currentChatId = currentState.conversationId;

    final updatedList = currentState.messages.where((m) => m.id != messageId).toList();

    emit(ChatMessagesLoaded(
        messages: updatedList,
        conversationId: currentChatId
    ));

    final result = await repository.deleteMessage(messageId);
    if (isClosed) return;

    result.fold(
          (failure) => emit(currentState),
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

  void clearMessages() {
    allMessages = [];
    emit(ChatInitial());
  }

  void onMessageReadReceived(Map<String, dynamic> data) {
    if (state is ChatMessagesLoaded) {
      final currentState = state as ChatMessagesLoaded;

      final currentChatId = currentState.conversationId;

      final msgData = data['message'] ?? data;
      final updatedMsg = ChatMessageModel.fromJson(msgData);

      final currentMessages = currentState.messages;

      final newList = currentMessages.map((msg) {
        return msg.id == updatedMsg.id ? updatedMsg : msg;
      }).toList();

      emit(ChatMessagesLoaded(
        messages: newList,
        conversationId: currentChatId,
      ));
    }
  }
}