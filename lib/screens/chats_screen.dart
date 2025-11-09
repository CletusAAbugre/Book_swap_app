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
      backgroundColor: const Color(0xFF1A1F3A),
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: const Color(0xFF1A1F3A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.chatRooms.isEmpty) {
            return const Center(
              child: Text(
                'No chats yet',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
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
                color: const Color(0xFF2A3150),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFDB750),
                    child: Icon(Icons.person, color: Color(0xFF1A1F3A)),
                  ),
                  title: Text(
                    'Chat with $otherParticipant',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Swap ID: ${chatRoom.swapId}',
                    style: const TextStyle(color: Color(0xFFB0B5C9)),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFFDB750)),
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