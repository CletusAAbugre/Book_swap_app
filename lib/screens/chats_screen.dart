import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';

import 'chat_detail_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.chatRooms.isEmpty) {
            return const Center(
              child: Text('No chats yet'),
            );
          }

          return ListView.builder(
            itemCount: chatProvider.chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatProvider.chatRooms[index];
              final currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;
              
              // Get the other participant's name
              String otherParticipant = 'Unknown';
              if (currentUser != null) {
                // This is a simplified approach - in a real app, you'd store participant names
                otherParticipant = chatRoom.participants
                    .where((id) => id != currentUser.uid)
                    .first;
              }

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text('Chat with $otherParticipant'),
                  subtitle: Text('Swap ID: ${chatRoom.swapId}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          chatRoom: chatRoom,
                          otherParticipantName: otherParticipant,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}