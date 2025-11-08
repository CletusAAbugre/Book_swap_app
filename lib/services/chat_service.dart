import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createChatRoom(String swapId, List<String> participants) async {
    try {
      ChatRoom chatRoom = ChatRoom(
        id: '',
        participants: participants,
        swapId: swapId,
        createdAt: DateTime.now(),
      );

      DocumentReference ref = await _firestore.collection('chats').add(chatRoom.toMap());
      return ref.id;
    } catch (e) {
      throw Exception('Failed to create chat room: $e');
    }
  }

  Stream<List<ChatRoom>> getUserChatRooms(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoom.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<ChatMessage>> getChatMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> sendMessage(String chatRoomId, ChatMessage message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<String?> getChatRoomBySwapId(String swapId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .where('swapId', isEqualTo: swapId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }
    } catch (e) {
      throw Exception('Failed to get chat room: $e');
    }
    return null;
  }
}