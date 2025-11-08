import 'dart:io';
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  final BookService _bookService = BookService();
  List<BookModel> _allBooks = [];
  List<BookModel> _userBooks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BookModel> get allBooks => _allBooks;
  List<BookModel> get userBooks => _userBooks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenToAllBooks() {
    _bookService.getAllBooks().listen((books) {
      _allBooks = books;
      notifyListeners();
    });
  }

  void listenToUserBooks(String userId) {
    _bookService.getUserBooks(userId).listen((books) {
      _userBooks = books;
      notifyListeners();
    });
  }

  Future<bool> createBook(BookModel book, File? imageFile) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _bookService.createBook(book, imageFile);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateBook(String bookId, BookModel book, File? imageFile) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _bookService.updateBook(bookId, book, imageFile);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteBook(String bookId) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _bookService.deleteBook(bookId);
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