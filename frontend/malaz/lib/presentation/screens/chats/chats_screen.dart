import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/presentation/screens/chats/ChatWithAPerson.dart';

class ChatModel {
  final String name;
  final String message;
  final String time;
  final String imageUrl;
  final int unreadCount;

  ChatModel({required this.name, required this.message, required this.time, required this.imageUrl, this.unreadCount = 0});
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Mock Data
    final List<ChatModel> chats = [
      ChatModel(name: 'Sarah Johnson', message: 'Yes, the apartment is still available...', time: '2 min ago', unreadCount: 2, imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&fit=crop'),
      ChatModel(name: 'Michael Chen', message: 'Thank you for your interest.', time: '1 hour ago', imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&fit=crop'),
    ];

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 80,
        // leading: IconButton(
        //   onPressed: () {
        //     context.go('/home');
        //   },
        //   icon: Icon(
        //     weight: 30,
        //     size: 30,
        //     Icons.arrow_back,
        //     color: colorScheme.surface,
        //   ),
        // ),
        title: const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 36)),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.surface,
      ),
      body: ListView(
        children: [
          _buildHeader(colorScheme: colorScheme, title: 'Activities'),
          _buildActivitiesListView(colorScheme: colorScheme, chats: chats),
          _buildHeader(colorScheme: colorScheme, title: 'Messages'),
          _buildMessagesListView(chats: chats, colorScheme: colorScheme),
        ]
      ),
    );
  }
}

class _buildMessagesListView extends StatelessWidget {
  const _buildMessagesListView({
    super.key,
    required this.chats,
    required this.colorScheme,
  });

  final List<ChatModel> chats;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 12,//chats.length,
      itemBuilder: (context, index) {
        final chat = chats[0];
        return Padding(
          padding: EdgeInsets.all(8),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatWithAPerson()));
              //context.push('/one_chat');
            },
            child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: BoxBorder.all(color: colorScheme.primary),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(chat.imageUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(chat.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.primary)),
                              Text(chat.time, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chat.message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: chat.unreadCount > 0 ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (chat.unreadCount > 0) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                        child: Text(
                          chat.unreadCount.toString(),
                          style: TextStyle(color: colorScheme.onPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]
                  ],
                ),
            ),
          ),
        );
      }
    );
  }
}

class _buildActivitiesListView extends StatelessWidget {
  const _buildActivitiesListView({
    super.key,
    required this.colorScheme,
    required this.chats,
  });

  final ColorScheme colorScheme;
  final List<ChatModel> chats;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: CircleAvatar(
              radius: 43,
              backgroundColor: colorScheme.primary,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: colorScheme.surface,
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(chats[0].imageUrl),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _buildHeader extends StatelessWidget {
  const _buildHeader({
    super.key,
    required this.colorScheme, required this.title,
  });

  final ColorScheme colorScheme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
