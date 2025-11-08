import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        // Reload user to get latest email verification status
        await user.reload();
        user = _auth.currentUser;
        
        if (user != null && user.emailVerified) {
          _currentUser = await _authService.getCurrentUserData();
          // Update Firestore with latest verification status
          await _firestore.collection('users').doc(user.uid).update({
            'emailVerified': true,
          });
        } else {
          _currentUser = null;
        }
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    _setLoading(true);
    _clearError();
    
    try {
      UserModel? user = await _authService.signUp(email, password, displayName);
      if (user != null) {
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _setError(e.toString());
    }
    
    _setLoading(false);
    return false;
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      UserModel? user = await _authService.signIn(email, password);
      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        notifyListeners();
        return true;
      }
    } catch (e) {
      _setError(e.toString());
    }
    
    _setLoading(false);
    return false;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        user = _auth.currentUser;
        
        if (user != null && user.emailVerified) {
          // Update Firestore with verification status
          await _firestore.collection('users').doc(user.uid).update({
            'emailVerified': true,
          });
          
          // Update current user data
          _currentUser = await _authService.getCurrentUserData();
          notifyListeners();
        }
      }
    } catch (e) {
      _setError(e.toString());
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