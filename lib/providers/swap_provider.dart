import 'package:flutter/material.dart';
import '../models/swap_model.dart';
import '../services/swap_service.dart';

class SwapProvider with ChangeNotifier {
  final SwapService _swapService = SwapService();
  List<SwapModel> _userOffers = [];
  List<SwapModel> _userRequests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SwapModel> get userOffers => _userOffers;
  List<SwapModel> get userRequests => _userRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToUserOffers(String userId) {
    _swapService.getUserSwapOffers(userId).listen((offers) {
      _userOffers = offers;
      notifyListeners();
    });
  }

  void listenToUserRequests(String userId) {
    _swapService.getUserSwapRequests(userId).listen((requests) {
      _userRequests = requests;
      notifyListeners();
    });
  }

  Future<bool> createSwapOffer(SwapModel swap) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _swapService.createSwapOffer(swap);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateSwapStatus(String swapId, SwapStatus status) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _swapService.updateSwapStatus(swapId, status);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
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