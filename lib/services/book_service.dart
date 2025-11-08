import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/book_model.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<BookModel>> getAllBooks() {
    return _firestore
        .collection('books')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<BookModel>> getUserBooks(String userId) {
    return _firestore
        .collection('books')
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<String> uploadImage(File imageFile, String fileName) async {
    try {
      Reference ref = _storage.ref().child('book_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> createBook(BookModel book, File? imageFile) async {
    try {
      String imageUrl = '';
      if (imageFile != null) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${book.title}';
        imageUrl = await uploadImage(imageFile, fileName);
      }

      BookModel bookWithImage = BookModel(
        id: '',
        title: book.title,
        author: book.author,
        condition: book.condition,
        imageUrl: imageUrl,
        ownerId: book.ownerId,
        ownerName: book.ownerName,
        createdAt: book.createdAt,
        isAvailable: book.isAvailable,
      );

      await _firestore.collection('books').add(bookWithImage.toMap());
    } catch (e) {
      throw Exception('Failed to create book: $e');
    }
  }

  Future<void> updateBook(String bookId, BookModel book, File? imageFile) async {
    try {
      String imageUrl = book.imageUrl;
      if (imageFile != null) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${book.title}';
        imageUrl = await uploadImage(imageFile, fileName);
      }

      Map<String, dynamic> updateData = book.toMap();
      updateData['imageUrl'] = imageUrl;

      await _firestore.collection('books').doc(bookId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  Future<BookModel?> getBook(String bookId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('books').doc(bookId).get();
      if (doc.exists) {
        return BookModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      throw Exception('Failed to get book: $e');
    }
    return null;
  }
}