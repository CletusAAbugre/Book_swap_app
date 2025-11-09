import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F3A),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1A1F3A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final messenger = ScaffoldMessenger.of(context);
              await authProvider.checkEmailVerification();
              if (mounted) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Email verification status refreshed'),
                    backgroundColor: Color(0xFFFDB750),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          return ListView(
            children: [
              // Profile Section
              Container(
                margin: const EdgeInsets.all(16),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFFFDB750),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Color(0xFF1A1F3A),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'Unknown User',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                user?.email ?? 'No email',
                                style: const TextStyle(color: Color(0xFFB0B5C9)),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    user?.emailVerified == true ? Icons.verified : Icons.warning,
                                    color: user?.emailVerified == true ? Colors.green : Colors.orange,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    user?.emailVerified == true ? 'Verified' : 'Not Verified',
                                    style: TextStyle(
                                      color: user?.emailVerified == true ? Colors.green : Colors.orange,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Notification Settings
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(0xFF2A3150),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.notifications, color: Color(0xFFFDB750)),
                          SizedBox(width: 16),
                          Text(
                            'Notification Preferences',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SwitchListTile(
                      title: const Text(
                        'Push Notifications',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Receive notifications for swap requests',
                        style: TextStyle(color: Color(0xFFB0B5C9)),
                      ),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text(
                        'Email Notifications',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        'Receive email updates for important events',
                        style: TextStyle(color: Color(0xFFB0B5C9)),
                      ),
                      value: _emailNotifications,
                      onChanged: (value) {
                        setState(() {
                          _emailNotifications = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Account Actions
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(0xFF2A3150),
                child: Column(
                  children: [
                    if (user?.emailVerified == false)
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.orange),
                        title: const Text(
                          'Verify Email',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'Click to resend verification email',
                          style: TextStyle(color: Color(0xFFB0B5C9)),
                        ),
                        onTap: () {
                          final messenger = ScaffoldMessenger.of(context);
                          authProvider.sendEmailVerification().then((_) {
                            if (mounted) {
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Verification email sent!'),
                                ),
                              );
                            }
                          });
                        },
                      ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => _showSignOutDialog(context, authProvider),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // App Info
              const Center(
                child: Column(
                  children: [
                    Text(
                      'BookSwap App',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Color(0xFFB0B5C9)),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A3150),
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Color(0xFFB0B5C9)),
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
            onPressed: () {
              Navigator.pop(context);
              authProvider.signOut().then((_) {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}