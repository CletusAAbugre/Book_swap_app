import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/book_provider.dart';
import '../providers/swap_provider.dart';
import '../models/book_model.dart';
import '../models/swap_model.dart';
import 'add_book_screen.dart';
import 'edit_book_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1F3A),
        appBar: AppBar(
          title: const Text('My Books'),
          backgroundColor: const Color(0xFF1A1F3A),
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'My Books'),
              Tab(text: 'My Offers'),
              Tab(text: 'Requests'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MyBooksTab(),
            _MyOffersTab(),
            _RequestsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddBookScreen()),
            );
          },
          backgroundColor: const Color(0xFFFDB750),
          foregroundColor: const Color(0xFF1A1F3A),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _MyBooksTab extends StatelessWidget {
  const _MyBooksTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        if (bookProvider.userBooks.isEmpty) {
          return const Center(
            child: Text(
              'No books listed yet',
              style: TextStyle(color: Color(0xFFB0B5C9)),
            ),
          );
        }

        return ListView.builder(
          itemCount: bookProvider.userBooks.length,
          itemBuilder: (context, index) {
            final book = bookProvider.userBooks[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF3A4A6B),
                    const Color(0xFF2D3A5F),
                    if (!book.isAvailable) Colors.orange.withValues(alpha: 0.15),
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
                border: !book.isAvailable 
                    ? Border.all(color: Colors.orange.withValues(alpha: 0.5), width: 1)
                    : null,
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
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: book.isAvailable 
                                      ? Colors.green.withValues(alpha: 0.2)
                                      : Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  book.isAvailable ? 'Available' : 'In Swap',
                                  style: TextStyle(
                                    color: book.isAvailable ? Colors.green : Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Action Menu
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Color(0xFFFDB750),
                      ),
                      color: const Color(0xFF2A3150),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: const [
                              Icon(Icons.edit, color: Color(0xFFFDB750), size: 20),
                              SizedBox(width: 8),
                              Text('Edit', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: const [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookScreen(book: book),
                            ),
                          );
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, book);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, BookModel book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A3150),
        title: const Text(
          'Delete Book',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${book.title}"?',
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
            onPressed: () async {
              final bookProvider = Provider.of<BookProvider>(context, listen: false);
              await bookProvider.deleteBook(book.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book deleted successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _MyOffersTab extends StatelessWidget {
  const _MyOffersTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<SwapProvider>(
      builder: (context, swapProvider, child) {
        if (swapProvider.userOffers.isEmpty) {
          return const Center(
            child: Text(
              'No swap offers made',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: swapProvider.userOffers.length,
          itemBuilder: (context, index) {
            final swap = swapProvider.userOffers[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              color: const Color(0xFF2A3150),
              child: ListTile(
                title: Text(
                  swap.bookTitle,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Owner: ${swap.ownerName}',
                      style: const TextStyle(color: Color(0xFFB0B5C9)),
                    ),
                    Text(
                      'Status: ${swap.statusString}',
                      style: const TextStyle(color: Color(0xFFFDB750)),
                    ),
                    Text(
                      'Date: ${swap.createdAt.toString().split(' ')[0]}',
                      style: const TextStyle(color: Color(0xFFB0B5C9)),
                    ),
                  ],
                ),
                trailing: _getStatusIcon(swap.status),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getStatusIcon(SwapStatus status) {
    switch (status) {
      case SwapStatus.pending:
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
      case SwapStatus.accepted:
        return const Icon(Icons.check_circle, color: Colors.green);
      case SwapStatus.rejected:
        return const Icon(Icons.cancel, color: Colors.red);
    }
  }
}

class _RequestsTab extends StatelessWidget {
  const _RequestsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<SwapProvider>(
      builder: (context, swapProvider, child) {
        if (swapProvider.userRequests.isEmpty) {
          return const Center(
            child: Text(
              'No swap requests received',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: swapProvider.userRequests.length,
          itemBuilder: (context, index) {
            final swap = swapProvider.userRequests[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              color: const Color(0xFF2A3150),
              child: ListTile(
                title: Text(
                  swap.bookTitle,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requested by: ${swap.requesterName}',
                      style: const TextStyle(color: Color(0xFFB0B5C9)),
                    ),
                    Text(
                      'Status: ${swap.statusString}',
                      style: const TextStyle(color: Color(0xFFFDB750)),
                    ),
                    Text(
                      'Date: ${swap.createdAt.toString().split(' ')[0]}',
                      style: const TextStyle(color: Color(0xFFB0B5C9)),
                    ),
                  ],
                ),
                trailing: swap.status == SwapStatus.pending
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _updateSwapStatus(context, swap.id, SwapStatus.accepted),
                            icon: const Icon(Icons.check, color: Colors.green),
                          ),
                          IconButton(
                            onPressed: () => _updateSwapStatus(context, swap.id, SwapStatus.rejected),
                            icon: const Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      )
                    : _getStatusIcon(swap.status),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getStatusIcon(SwapStatus status) {
    switch (status) {
      case SwapStatus.pending:
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
      case SwapStatus.accepted:
        return const Icon(Icons.check_circle, color: Colors.green);
      case SwapStatus.rejected:
        return const Icon(Icons.cancel, color: Colors.red);
    }
  }

  void _updateSwapStatus(BuildContext context, String swapId, SwapStatus status) async {
    final swapProvider = Provider.of<SwapProvider>(context, listen: false);
    bool success = await swapProvider.updateSwapStatus(swapId, status);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success 
              ? 'Swap ${status.name} successfully!' 
              : 'Failed to update swap status'),
        ),
      );
    }
  }
}