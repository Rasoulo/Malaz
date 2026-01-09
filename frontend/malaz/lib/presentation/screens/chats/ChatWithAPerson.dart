import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/config/color/app_color.dart';
import '../../../data/datasources/local/auth/auth_local_data_source.dart';
import '../../../data/models/chat/chat_message_model.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/chat/chat_cubit.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/chat/pusher_service/pusher_service.dart';
import '../../global_widgets/user_profile_image/user_profile_image.dart';

class ChatWithAPerson extends StatefulWidget {
  final int conversationId;
  final String firstName;
  final String lastName;
  final int otherUserId;

  const ChatWithAPerson({
    super.key,
    required this.conversationId,
    required this.firstName,
    required this.lastName,
    required this.otherUserId,
  });

  @override
  State<ChatWithAPerson> createState() => _ChatWithAPersonState();
}

class _ChatWithAPersonState extends State<ChatWithAPerson> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatMessageModel? _editingMessage;
  int? myId;
  String? _currentSubscribedChannel;

  int? _getMyId(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated) return state.user.id;
    if (state is AuthPending) return state.user.id;
    return null;
  }

  void _onSendMessage(BuildContext context, int myId, {int? overrideId}) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatCubit = context.read<ChatCubit>();

    int finalId = overrideId ?? -1;
    if (finalId == -1 && chatCubit.state is ChatMessagesLoaded) {
      finalId = (chatCubit.state as ChatMessagesLoaded).conversationId;
    }
    if (finalId == -1) finalId = widget.conversationId;

    if (finalId != -1) {
      chatCubit.sendMessage(finalId, text, myId);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) myId = authState.user.id;

    context.read<ChatCubit>().getMessages(widget.conversationId);
    _connectToPusher();
  }

  void _connectToPusher() async {
    String? token = await sl<AuthLocalDatasource>().getCachedToken();
    if (token == null) return;

    await PusherService().init(token: token);

    _subscribeToCurrentConversation();
  }

  void _subscribeToCurrentConversation([int? overrideId]) async {
    final int idToSubscribe = overrideId ?? widget.conversationId;

    if (idToSubscribe == -1) return;

    final channelName = "private-conversations.$idToSubscribe";

    if (_currentSubscribedChannel == channelName) return;

    if (_currentSubscribedChannel != null) {
      log(">>>> Unsubscribing from old channel: $_currentSubscribedChannel");
      await PusherService().unsubscribe(_currentSubscribedChannel!);
    }

    log(">>>> Attempting to subscribe to: $channelName");

    await PusherService().subscribe(
      channelName: channelName,
      onEvent: (event) {
        log(">>>> Event Received in UI: ${event.eventName}");

        if (event.eventName == "pusher:subscription_succeeded") return;

        try {
          final Map<String, dynamic> data = jsonDecode(event.data);
          if (mounted) {
            context.read<ChatCubit>().handlePusherEvent(event.eventName, data);
          }
        } catch (e) {
          log(">>>> UI Parsing Error: $e");
        }
      },
    );

    _currentSubscribedChannel = channelName;
  }

  @override
  void dispose() {
    if (_currentSubscribedChannel != null) {
      PusherService().unsubscribe(_currentSubscribedChannel!);
    }
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121318) : const Color(0xFFFAF8F5);
    final myId = _getMyId(context);

    final screenSize = MediaQuery.of(context).size;

    return Builder(
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
                          if (state is ChatMessagesLoaded) {

                            final channelName = "private-conversations.${state.conversationId}";
                            if (_currentSubscribedChannel != channelName) {
                              log(">>>> New Conversation detected (${state.conversationId}), re-subscribing...");
                              _subscribeToCurrentConversation(state.conversationId);
                            }

                            if (state.messages.isNotEmpty) {
                              if (myId == null) return;

                              final unreadMessages = state.messages.where((msg) =>
                              msg.senderId != myId && msg.readAt == null).toList();

                              if (unreadMessages.isNotEmpty) {
                                if (!mounted) return;
                                for (var msg in unreadMessages) {
                                  context.read<ChatCubit>().markMessageAsRead(msg.id);
                                }
                              }
                            }
                          }
                        },
                        builder: (context, state) {
                          List<ChatMessageModel> messages = [];

                          if (state is ChatMessagesLoaded) {
                            messages = state.messages;
                          } else {
                            messages = context.read<ChatCubit>().allMessages;
                          }

                          if (state is ChatMessagesInitialLoading && messages.isEmpty) {
                            return _buildShimmerMessages(isDark);
                          }

                          if (messages.isNotEmpty) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              controller: _scrollController,
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final msg = messages[index];
                                return ChatBubble(
                                  message: msg,
                                  isMe: msg.senderId == myId,
                                  onLongPress: () => _showMessageActions(childContext, msg, msg.senderId == myId, tr),
                                  isSameUser: index > 0 && messages[index].senderId == messages[index - 1].senderId,
                                );
                              },
                            );
                          }

                          return const SizedBox();
                        }
                    ),
                  ),
                  _buildMessageInput(childContext, isDark, myId ?? 0, tr),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      elevation: 0,
      toolbarHeight: 120,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.premiumGoldGradient2,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            PositionedDirectional(
              top: -10,
              start: -20,
              child: _buildGlowingKey(100, 0.12, -0.2),
            ),
            PositionedDirectional(
              bottom: -10,
              end: 20,
              child: _buildGlowingKey(80, 0.1, 0.5),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    ),
                    UserProfileImage(
                      userId: widget.otherUserId,
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      radius: 22,
                      isPremiumStyle: true,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.firstName} ${widget.lastName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.greenAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.greenAccent, blurRadius: 4)],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tr.online_now,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowingKey(double size, double opacity, double rotation) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: rotation,
        child: Image.asset(
          'assets/icons/key_logo.png',
          width: size,
          height: size,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, bool isDark, int myId, AppLocalizations tr) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 25),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                onTap: () async {
                  final text = _messageController.text.trim();
                  if (text.isEmpty) return;

                  if (_editingMessage != null) {
                    context.read<ChatCubit>().editMessage(_editingMessage!.id, text);
                    setState(() => _editingMessage = null);
                    _messageController.clear();
                  } else {
                    final myIdValue = myId ?? 0;
                    final chatCubit = context.read<ChatCubit>();
                    final text = _messageController.text.trim();

                    if (text.isEmpty) return;

                    int currentId = -1;
                    if (chatCubit.state is ChatMessagesLoaded) {
                      currentId = (chatCubit.state as ChatMessagesLoaded).conversationId;
                    }

                    if (currentId == -1) {
                      final newId = await chatCubit.saveNewConversation(widget.otherUserId);

                      if (newId != null && newId != -1) {
                        _onSendMessage(context, myIdValue, overrideId: newId);
                      } else {
                        if (chatCubit.state is ChatMessagesLoaded) {
                          final fallbackId = (chatCubit.state as ChatMessagesLoaded).conversationId;
                          if (fallbackId != -1) {
                            _onSendMessage(context, myIdValue, overrideId: fallbackId);
                            return;
                          }
                        }
                      }
                    } else {
                      _onSendMessage(context, myIdValue);
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGoldGradient2,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFAF895F).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _editingMessage != null ? Icons.check_rounded : Icons.send_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
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
        itemCount: 8,
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

    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: isSameUser ? 3 : 15),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          decoration: BoxDecoration(
            gradient: isMe ? AppColors.premiumGoldGradient2 : null,
            color: isMe ? null : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isMe ? 22 : (isSameUser ? 22 : 6)),
              bottomRight: Radius.circular(isMe ? (isSameUser ? 22 : 6) : 22),
            ),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.15 : 0.05), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.body,
                style: TextStyle(color: isMe ? (isDark ? Colors.black : Colors.white) : Colors.black87, fontSize: 15, height: 1.3),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.isEdited)
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(' ${tr.edited}   ', style: TextStyle(fontSize: 9, fontStyle: FontStyle.italic, color: Colors.white70)),
                    ),
                  Text(
                    DateFormat('hh:mm a').format(message.createdAt),
                    style: TextStyle(fontSize: 10, color: isMe ? Colors.white : Colors.grey),
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