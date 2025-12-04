
import 'package:flutter/material.dart';

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
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: chats.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
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
                          Text(chat.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface)),
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
          );
        },
      ),
    );
  }
}
