import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/swap_model.dart';
import '../models/chat_model.dart';

class SwapService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createSwapOffer(SwapModel swap) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      // Create swap offer
      DocumentReference swapRef = _firestore.collection('swaps').doc();
      batch.set(swapRef, swap.toMap());
      
      // Update book availability
      DocumentReference bookRef = _firestore.collection('books').doc(swap.bookId);
      batch.update(bookRef, {'isAvailable': false});
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to create swap offer: $e');
    }
  }

  Stream<List<SwapModel>> getUserSwapOffers(String userId) {
    return _firestore
        .collection('swaps')
        .where('requesterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SwapModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<SwapModel>> getUserSwapRequests(String userId) {
    return _firestore
        .collection('swaps')
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SwapModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateSwapStatus(String swapId, SwapStatus status) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      // Update swap status
      DocumentReference swapRef = _firestore.collection('swaps').doc(swapId);
      batch.update(swapRef, {
        'status': status.index,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Get swap details
      DocumentSnapshot swapDoc = await _firestore.collection('swaps').doc(swapId).get();
      if (swapDoc.exists) {
        SwapModel swap = SwapModel.fromMap(swapDoc.data() as Map<String, dynamic>, swapDoc.id);
        
        if (status == SwapStatus.rejected) {
          // Make book available again
          DocumentReference bookRef = _firestore.collection('books').doc(swap.bookId);
          batch.update(bookRef, {'isAvailable': true});
        } else if (status == SwapStatus.accepted) {
          // Create chat room for accepted swap
          DocumentReference chatRef = _firestore.collection('chats').doc();
          ChatRoom chat = ChatRoom(
            id: chatRef.id,
            participants: [swap.requesterId, swap.ownerId],
            swapId: swapId,
            createdAt: DateTime.now(),
          );
          batch.set(chatRef, chat.toMap());
          
          // Add initial system message
          DocumentReference messageRef = chatRef.collection('messages').doc();
          ChatMessage initialMessage = ChatMessage(
            id: messageRef.id,
            senderId: 'system',
            senderName: 'BookSwap',
            message: 'Swap accepted! You can now chat about the book exchange details.',
            timestamp: DateTime.now(),
          );
          batch.set(messageRef, initialMessage.toMap());
        }
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to update swap status: $e');
    }
  }

  Future<SwapModel?> getSwap(String swapId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('swaps').doc(swapId).get();
      if (doc.exists) {
        return SwapModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      throw Exception('Failed to get swap: $e');
    }
    return null;
  }
}