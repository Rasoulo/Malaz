import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/data/models/user_model.dart';
import 'package:malaz/domain/entities/user_entity.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../data/models/conversation_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/chat/chat_cubit.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../global_widgets/user_profile_image/user_profile_image.dart';

class ChatsColors {
  static const Color creamBg = Color(0xFFFDFBF7);
  static const Color darkCoffee = Color(0xFF3E2723);
  static const Color caramel = Color(0xFFAF895F);
  static const Color softAmber = Color(0xFFE4C59E);
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  UserEntity? _getCurrentUser(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) return authState.user;
    if (authState is AuthPending) return authState.user;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : ChatsColors.darkCoffee;
    final myUser = _getCurrentUser(context);

    return BlocProvider(
      create: (context) => sl<ChatCubit>()..getConversations(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: ChatsColors.caramel,
              onRefresh: () async => await context.read<ChatCubit>().getConversations(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  _buildAppBar(isDark, tr),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BuildHeader(title: tr.active_partners, textColor: textColor),
                        _buildActivitySection(state, isDark, myUser?.id),
                        _BuildHeader(title: tr.recent_messages, textColor: textColor),
                      ],
                    ),
                  ),
                  _buildMessagesContent(state, isDark, textColor, myUser?.id, tr),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark, AppLocalizations tr) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: isDark ? const Color(0xFF0C0D10).withOpacity(0.9) : ChatsColors.creamBg.withOpacity(0.9),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20,right: 20, bottom: 16),
        title: Text(
          tr.malaz_chat,
          style: TextStyle(
            color: ChatsColors.caramel,
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
      ),
      actions: [
        _buildActionIcon(Icons.search_rounded),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: ChatsColors.caramel.withOpacity(0.1), shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: ChatsColors.caramel, size: 22),
        onPressed: () {},
      ),
    );
  }

  Widget _buildActivitySection(ChatState state, bool isDark, int? myId) {
    if (state is ChatConversationsLoading) return _buildHorizontalShimmer(isDark);
    if (state is ChatConversationsLoaded) {
      return _BuildActivitiesSection(conversations: state.conversations, isDark: isDark, myId: myId);
    }
    return const SizedBox(height: 110);
  }

  Widget _buildMessagesContent(ChatState state, bool isDark, Color textColor, int? myId, AppLocalizations tr) {
    if (state is ChatConversationsLoading) return _BuildShimmerList(isDark: isDark);
    if (state is ChatConversationsLoaded) {
      if (state.conversations.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(child: Padding(padding: EdgeInsets.only(top: 80), child: Center(child: Text(tr.no_conversations)))),
        );
      }
      return _BuildMessagesList(conversations: state.conversations, isDark: isDark, textColor: textColor, myId: myId);
    }
    if (state is ChatConversationsError) {
      return SliverToBoxAdapter(child: Center(child: Text(state.message, style: const TextStyle(color: Colors.red))));
    }
    return const SliverToBoxAdapter(child: SizedBox());
  }

  Widget _buildHorizontalShimmer(bool isDark) {
    return SizedBox(
      height: 110,
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[900]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(right: 18),
            child: CircleAvatar(radius: 32, backgroundColor: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _BuildActivitiesSection extends StatelessWidget {
  final List<ConversationModel> conversations;
  final bool isDark;
  final int? myId;
  const _BuildActivitiesSection({required this.conversations, required this.isDark, this.myId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final otherUser = conversations[index].userOneId == myId ? conversations[index].userTwo : conversations[index].userOne;
          return Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ChatsColors.caramel, width: 2)),
                  child: UserProfileImage(userId: otherUser!.id,firstName: otherUser.first_name,lastName: otherUser.last_name, radius: 28),
                ),
                const SizedBox(height: 8),
                Text(otherUser!.first_name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : ChatsColors.darkCoffee)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BuildMessagesList extends StatelessWidget {
  final List<ConversationModel> conversations;
  final bool isDark;
  final Color textColor;
  final int? myId;

  const _BuildMessagesList({required this.conversations, required this.isDark, required this.textColor, this.myId});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final conv = conversations[index];
          final otherUser = conv.userOneId == myId ? conv.userTwo : conv.userOne;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Dismissible(
              key: Key(conv.id.toString()),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                HapticFeedback.heavyImpact();
                return await _showDeleteConfirm(context);
              },
              onDismissed: (direction) {
                context.read<ChatCubit>().deleteConversation(conv.id);
              },
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(28)),
                child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 30),
              ),
              child: GestureDetector(
                onTap: () async {
                  await context.push('/one_chat', extra: {
                    'id': conv.id,
                    'firstName': otherUser.first_name,
                    'lastName': otherUser.last_name,
                    'otherUserId': otherUser.id,
                  });
                  if (context.mounted) {
                    context.read<ChatCubit>().getConversations();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1B21) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 15, offset: const Offset(0, 8))
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: UserProfileImage(userId: otherUser!.id, firstName: otherUser.first_name, lastName: otherUser.last_name, radius: 28),
                    title: Text('${otherUser!.first_name} ${otherUser!.last_name}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                    subtitle: Text(tr.click_to_view, style: TextStyle(fontSize: 13, color: Colors.grey)),
                    trailing: _buildTrailing(conv, tr),
                  ),
                ),
              ),
            ),
          );
        }, childCount: conversations.length),
      ),
    );
  }

  Widget _buildTrailing(ConversationModel conv, AppLocalizations tr) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(tr.active, style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        if (conv.unreadCount > 0)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: ChatsColors.caramel, shape: BoxShape.circle),
            child: Text('${conv.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        else
          const Icon(Icons.done_all_rounded, size: 18, color: ChatsColors.caramel),
      ],
    );
  }

  Future<bool?> _showDeleteConfirm(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.delete_chat_title),
        content: Text(tr.delete_chat_confirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(tr.delete, style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}

class _BuildShimmerList extends StatelessWidget {
  final bool isDark;
  const _BuildShimmerList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) => Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[900]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
          child: Container(height: 90, margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28))),
        ), childCount: 6),
      ),
    );
  }
}

class _BuildHeader extends StatelessWidget {
  final String title;
  final Color textColor;
  const _BuildHeader({required this.title, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w900)),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: ChatsColors.caramel),
        ],
      ),
    );
  }
}