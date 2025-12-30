import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../data/models/chat_message_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/chat/chat_cubit.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../global_widgets/user_profile_image/user_profile_image.dart';

class ChatWithAPerson extends StatefulWidget {
  final int conversationId;
  final String userName;
  final int otherUserId;

  const ChatWithAPerson({
    super.key,
    required this.conversationId,
    required this.userName,
    required this.otherUserId,
  });

  @override
  State<ChatWithAPerson> createState() => _ChatWithAPersonState();
}

class _ChatWithAPersonState extends State<ChatWithAPerson> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatMessageModel? _editingMessage;

  int? _getMyId(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated) return state.user.id;
    if (state is AuthPending) return state.user.id;
    return null;
  }

  void _onSendMessage(BuildContext context, int myId) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_editingMessage != null) {
      context.read<ChatCubit>().editMessage(_editingMessage!.id, text);
      setState(() {
        _editingMessage = null;
        _messageController.clear();
      });
    } else {
      context.read<ChatCubit>().sendMessage(widget.conversationId, text, myId);
      _messageController.clear();
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121318) : const Color(0xFFFAF8F5);
    final myId = _getMyId(context);

    final screenSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => sl<ChatCubit>()..getMessages(widget.conversationId),
      child: Builder(
        builder: (childContext) {
          final tr = AppLocalizations.of(childContext)!;
          return Scaffold(
            backgroundColor: bgColor,
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: SizedBox(
                      width: screenSize.width,
                      height: screenSize.height,
                      child: Opacity(
                        opacity: isDark ? 0.1 : 0.2,
                        child: Transform.rotate(
                          angle: 0.36,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 60,
                              crossAxisSpacing: 60,
                            ),
                            itemBuilder: (context, index) {
                              return Transform.rotate(
                                angle: (index % 2 == 0) ? 0.3 : -0.3,
                                child: Image.asset(
                                  'assets/icons/key_logo.png',
                                  color: isDark ? colorScheme.primary : const Color(0xFFAF895F),
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                            itemCount: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    _buildAppBar(childContext, isDark),
                    Expanded(
                      child: BlocConsumer<ChatCubit, ChatState>(
                        listener: (context, state) {
                          if (state is ChatMessagesLoaded && state.messages.isNotEmpty) {
                            final myId = _getMyId(context);

                            final unreadMessages = state.messages.where((msg) =>
                            msg.senderId != myId && msg.readAt == null).toList();

                            if (unreadMessages.isNotEmpty) {
                              for (var msg in unreadMessages) {
                                context.read<ChatCubit>().markMessageAsRead(msg.id);
                              }

                              // مثل: context.read<ChatCubit>().markAllAsRead(unreadMessages.map((e) => e.id).toList());
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is ChatMessagesInitialLoading) return _buildShimmerMessages(isDark);
                          if (state is ChatMessagesLoaded) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              controller: _scrollController,
                              reverse: true,
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final msg = state.messages[index];
                                return ChatBubble(
                                  message: msg,
                                  isMe: msg.senderId == myId,
                                  onLongPress: () => _showMessageActions(childContext, msg, msg.senderId == myId, tr),
                                  isSameUser: index > 0 && state.messages[index].senderId == state.messages[index - 1].senderId,
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    _buildMessageInput(childContext, isDark, myId ?? 0, tr),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    final tr = AppLocalizations.of(context)!;
    final primaryGold = const Color(0xFFAF895F);
    return AppBar(
      elevation: 0,
      toolbarHeight: 85,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1B21).withOpacity(0.9) : Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
      ),
      title: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryGold, size: 20),
          ),
          UserProfileImage(userId: widget.otherUserId, radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    Text(tr.online_now, style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, bool isDark, int myId, AppLocalizations tr) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 25),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16171B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_editingMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 14, color: Color(0xFFAF895F)),
                  const SizedBox(width: 5),
                  Text(tr.editing_message_hint, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close, size: 16), onPressed: () => setState(() => _editingMessage = null)),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    decoration: InputDecoration(hintText: tr.type_message_hint, border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _onSendMessage(context, myId),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Color(0xFFAF895F), shape: BoxShape.circle),
                  child: Icon(_editingMessage != null ? Icons.check : Icons.send_rounded, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMessageActions(BuildContext cubitContext, ChatMessageModel message, bool isMe, AppLocalizations tr) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            if (isMe) ListTile(leading: const Icon(Icons.edit_rounded, color: Color(0xFFAF895F)), title: Text(tr.edit_message), onTap: () {
              context.pop();
              _messageController.text = message.body;
              setState(() => _editingMessage = message);
            }),
            ListTile(leading: const Icon(Icons.copy_rounded, color: Color(0xFFAF895F)), title: Text(tr.copy_text), onTap: () {
              Clipboard.setData(ClipboardData(text: message.body));
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr.text_copied)));
            }),
            if (isMe) ListTile(leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent), title: Text(tr.delete_message, style: TextStyle(color: Colors.redAccent)), onTap: () {
              cubitContext.read<ChatCubit>().deleteMessage(message.id);
              context.pop();
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerMessages(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[900]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        itemBuilder: (_, i) => Align(
          alignment: i % 2 == 0 ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(margin: const EdgeInsets.only(bottom: 20), height: 50, width: 220, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15))),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;
  final VoidCallback onLongPress;
  final bool isSameUser;

  const ChatBubble({super.key, required this.message, required this.isMe, required this.onLongPress, required this.isSameUser});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGold = const Color(0xFFAF895F);

    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: isSameUser ? 3 : 15),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          decoration: BoxDecoration(
            color: isMe ? primaryGold : (isDark ? const Color(0xFF1E1F23) : Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isMe ? 20 : (isSameUser ? 20 : 5)),
              bottomRight: Radius.circular(isMe ? (isSameUser ? 20 : 5) : 20),
            ),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.body,
                style: TextStyle(color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87), fontSize: 15, height: 1.3),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.isEdited)
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(tr.edited, style: TextStyle(fontSize: 9, fontStyle: FontStyle.italic, color: Colors.white70)),
                    ),
                  Text(
                    DateFormat('hh:mm a').format(message.createdAt),
                    style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.grey),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all_rounded,
                      size: 15,
                      color: message.readAt != null ? Colors.blueAccent : Colors.white60,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}