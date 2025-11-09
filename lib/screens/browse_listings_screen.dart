import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/book_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/swap_provider.dart';
import '../models/book_model.dart';
import '../models/swap_model.dart';
import 'add_book_screen.dart';

class BrowseListingsScreen extends StatelessWidget {
  const BrowseListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F3A),
      appBar: AppBar(
        title: const Text('Browse Books'),
        backgroundColor: const Color(0xFF1A1F3A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          if (bookProvider.allBooks.isEmpty) {
            return const Center(
              child: Text(
                'No books available',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: bookProvider.allBooks.length,
            itemBuilder: (context, index) {
              final book = bookProvider.allBooks[index];
              final currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3A4A6B),
                      Color(0xFF2D3A5F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Book Image
                      Container(
                        width: 70,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF1E2749),
                          border: Border.all(
                            color: const Color(0xFFFDB750).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: book.imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: book.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFDB750),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.menu_book_rounded,
                                    color: Color(0xFFFDB750),
                                    size: 40,
                                  ),
                                )
                              : const Icon(
                                  Icons.menu_book_rounded,
                                  color: Color(0xFFFDB750),
                                  size: 40,
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Book Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'by ${book.author}',
                              style: const TextStyle(
                                color: Color(0xFFFDB750),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDB750).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    book.conditionString,
                                    style: const TextStyle(
                                      color: Color(0xFFFDB750),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Owner: ${book.ownerName}',
                              style: const TextStyle(
                                color: Color(0xFFB0B5C9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Action Button
                      Column(
                        children: [
                          currentUser != null && book.ownerId == currentUser.uid
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDB750).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFFDB750),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'Your Book',
                                    style: TextStyle(
                                      color: Color(0xFFFDB750),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : book.isAvailable
                                  ? ElevatedButton(
                                      onPressed: () => _showSwapDialog(context, book),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFDB750),
                                        foregroundColor: const Color(0xFF1A1F3A),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        'Swap',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Unavailable',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBookScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFFDB750),
        foregroundColor: const Color(0xFF1A1F3A),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSwapDialog(BuildContext context, BookModel book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A3150),
        title: const Text(
          'Swap Request',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Do you want to request a swap for "${book.title}"?',
          style: const TextStyle(color: Color(0xFFB0B5C9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFB0B5C9)),
            ),
          ),
          ElevatedButton(
            onPressed: () => _requestSwap(context, book),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDB750),
              foregroundColor: const Color(0xFF1A1F3A),
            ),
            child: const Text('Request Swap'),
          ),
        ],
      ),
    );
  }

  void _requestSwap(BuildContext context, BookModel book) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final swapProvider = Provider.of<SwapProvider>(context, listen: false);

    if (authProvider.currentUser == null) return;

    final swap = SwapModel(
      id: '',
      requesterId: authProvider.currentUser!.uid,
      requesterName: authProvider.currentUser!.displayName,
      ownerId: book.ownerId,
      ownerName: book.ownerName,
      bookId: book.id,
      bookTitle: book.title,
      status: SwapStatus.pending,
      createdAt: DateTime.now(),
    );

    bool success = await swapProvider.createSwapOffer(swap);
    
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success 
              ? 'Swap request sent successfully!' 
              : 'Failed to send swap request'),
        ),
      );
    }
  }
}