import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  List<ChatRoom> _chatRooms = [];
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChatRoom> get chatRooms => _chatRooms;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToUserChatRooms(String userId) {
    _chatService.getUserChatRooms(userId).listen((rooms) {
      _chatRooms = rooms;
      notifyListeners();
    });
  }

  void listenToChatMessages(String chatRoomId) {
    _chatService.getChatMessages(chatRoomId).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  Future<String?> createChatRoom(String swapId, List<String> participants) async {
    _setLoading(true);
    _clearError();
    
    try {
      String chatRoomId = await _chatService.createChatRoom(swapId, participants);
      _setLoading(false);
      return chatRoomId;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return null;
    }
  }

  Future<bool> sendMessage(String chatRoomId, ChatMessage message) async {
    try {
      await _chatService.sendMessage(chatRoomId, message);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<String?> getChatRoomBySwapId(String swapId) async {
    try {
      return await _chatService.getChatRoomBySwapId(swapId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}