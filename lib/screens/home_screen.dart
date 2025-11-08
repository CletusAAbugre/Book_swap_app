import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/book_provider.dart';
import '../providers/swap_provider.dart';
import '../providers/chat_provider.dart';
import 'browse_listings_screen.dart';
import 'my_listings_screen.dart';
import 'chats_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const BrowseListingsScreen(),
      const MyListingsScreen(),
      const ChatsScreen(),
      const SettingsScreen(),
    ];

    // Initialize providers with user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });
  }

  void _initializeProviders() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final swapProvider = Provider.of<SwapProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      // Always listen to all books for browse screen - this ensures immediate updates
      bookProvider.listenToAllBooks();
      // Listen to user's specific books for my books screen
      bookProvider.listenToUserBooks(authProvider.currentUser!.uid);
      swapProvider.listenToUserOffers(authProvider.currentUser!.uid);
      swapProvider.listenToUserRequests(authProvider.currentUser!.uid);
      chatProvider.listenToUserChatRooms(authProvider.currentUser!.uid);
      
      // Providers initialized successfully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Reinitialize providers when auth state changes
        if (authProvider.currentUser != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeProviders();
          });
        }
        
        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF252B47),
            selectedItemColor: const Color(0xFFFDB750),
            unselectedItemColor: const Color(0xFFB0B5C9),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Browse',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'My Books',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}