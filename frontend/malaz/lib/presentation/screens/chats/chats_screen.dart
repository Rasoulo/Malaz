import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/domain/entities/user_entity.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/config/color/app_color.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../data/models/conversation_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/chat/chat_cubit.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../global_widgets/user_profile_image/user_profile_image.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final myUser = _getCurrentUser(context);

    return BlocProvider(
      create: (context) => sl<ChatCubit>()..getConversations(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: colorScheme.primary,
              onRefresh: () async => await context.read<ChatCubit>().getConversations(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  _buildAppBar(context, isDark, tr, colorScheme),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BuildHeader(title: tr.active_partners,colorScheme: colorScheme),
                        _buildActivitySection(state, isDark, myUser?.id),
                        _BuildHeader(title: tr.recent_messages,colorScheme: colorScheme),
                      ],
                    ),
                  ),
                  _buildMessagesContent(state, isDark, myUser?.id, tr, colorScheme),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark, AppLocalizations tr, ColorScheme colorScheme) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(decoration: const BoxDecoration(gradient: AppColors.premiumGoldGradient2)),
              PositionedDirectional(
                top: -20,
                start: -40,
                child: _buildGlowingKey(180, 0.15, -0.2),
              ),

              PositionedDirectional(
                bottom: 40,
                end: -10,
                child: _buildGlowingKey(140, 0.12, 0.5),
              ),
              Positioned(
                bottom: 16,
                left: 20,
                right: 20,
                child: Text(
                  tr.malaz_chat,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        _buildActionIcon(Icons.search_rounded),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildGlowingKey(double size, double opacity, double rotation) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryLight.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Image.asset(
            'assets/icons/key_logo.png',
            width: size,
            height: size,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
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

  Widget _buildMessagesContent(ChatState state, bool isDark, int? myId, AppLocalizations tr, colorScheme) {
    if (state is ChatConversationsLoading) return _BuildShimmerList(isDark: isDark);
    if (state is ChatConversationsLoaded) {
      if (state.conversations.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(child: Padding(padding: EdgeInsets.only(top: 80), child: Center(child: Text(tr.no_conversations)))),
        );
      }
      return _BuildMessagesList(conversations: state.conversations, isDark: isDark, myId: myId, colorScheme: colorScheme,);
    }
    if (state is ChatConversationsError) {
      return SliverToBoxAdapter(child: Center(child: Text(state.message, style: const TextStyle(color: Colors.red))));
    }
    return const SliverToBoxAdapter(child: SizedBox());
  }

  Widget _buildHorizontalShimmer(bool isDark) {
    return SizedBox(
      height: 115,
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[900]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22), // مطابق لشكل Squircle
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 115,
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
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGoldGradient,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: UserProfileImage(
                    userId: otherUser!.id,
                    firstName: otherUser.first_name,
                    lastName: otherUser.last_name,
                    radius: 28,
                    isPremiumStyle: true,
                  ),
                ),
                const SizedBox(height: 8),
                Text(otherUser.first_name,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
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
  final ColorScheme colorScheme;
  final int? myId;

  const _BuildMessagesList({required this.conversations, required this.isDark, required this.colorScheme, this.myId});

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
            padding: const EdgeInsets.only(bottom: 14),
            child: Dismissible(
              key: Key(conv.id.toString()),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                HapticFeedback.heavyImpact();
                return await _showDeleteConfirm(context);
              },
              onDismissed: (_) => context.read<ChatCubit>().deleteConversation(conv.id),
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(color: colorScheme.error.withOpacity(0.8), borderRadius: BorderRadius.circular(24)),
                child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
              ),
              child: InkWell(
                onTap: () => context.push('/one_chat', extra: {
                  'id': conv.id,
                  'firstName': otherUser!.first_name,
                  'lastName': otherUser.last_name,
                  'otherUserId': otherUser.id,
                }),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colorScheme.primary.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.03), blurRadius: 15, offset: const Offset(0, 5))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumGoldGradient,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: UserProfileImage(
                          userId: otherUser!.id,
                          firstName: otherUser.first_name,
                          lastName: otherUser.last_name,
                          radius: 25,
                          isPremiumStyle: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${otherUser.first_name} ${otherUser.last_name}',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: colorScheme.onSurface)
                            ),
                            const SizedBox(height: 4),
                            Text(
                                tr.click_to_view,
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.5))
                            ),
                          ],
                        ),
                      ),
                      _buildTrailing(conv, tr, colorScheme),
                    ],
                  ),
                ),
              ),
            ),
          );
        }, childCount: conversations.length),
      ),
    );
  }

  Widget _buildTrailing(ConversationModel conv, AppLocalizations tr, ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(tr.active, style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (conv.unreadCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(gradient: AppColors.premiumGoldGradient, borderRadius: BorderRadius.circular(10)),
            child: Text('${conv.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        else
          Icon(Icons.done_all_rounded, size: 18, color: colorScheme.primary.withOpacity(0.4)),
      ],
    );
  }
  Future<bool?> _showDeleteConfirm(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
            const SizedBox(width: 10),
            Text(tr.delete_chat_title,
                style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(tr.delete_chat_confirm,
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr.cancel,
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(tr.delete, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
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
    final skeletonColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => Shimmer.fromColors(
            baseColor: skeletonColor,
            highlightColor: highlightColor,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),

                  Container(
                    width: 30,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          childCount: 6,
        ),
      ),
    );
  }
}

class _BuildHeader extends StatelessWidget {
  final String title;
  final ColorScheme colorScheme;
  const _BuildHeader({required this.title, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: colorScheme.primary, fontSize: 19, fontWeight: FontWeight.w900)),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}