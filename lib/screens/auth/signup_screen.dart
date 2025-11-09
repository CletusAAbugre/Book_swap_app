import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/auth_provider.dart' as auth_provider;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F3A),
        foregroundColor: const Color(0xFFFDB750),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Book Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3150),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.person_add_rounded,
                        size: 40,
                        color: Color(0xFFFDB750),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Join BookSwap Community',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB0B5C9),
                    ),
                  ),
                  const SizedBox(height: 40),
              TextFormField(
                controller: _displayNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  labelStyle: const TextStyle(color: Color(0xFFB0B5C9)),
                  filled: true,
                  fillColor: const Color(0xFF252B47),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFDB750),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your display name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color(0xFFB0B5C9)),
                  filled: true,
                  fillColor: const Color(0xFF252B47),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFDB750),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0xFFB0B5C9)),
                  filled: true,
                  fillColor: const Color(0xFF252B47),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFDB750),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Consumer<auth_provider.AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.errorMessage != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(authProvider.errorMessage!)),
                      );
                    });
                  }

                  return SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDB750),
                        foregroundColor: const Color(0xFF1A1F3A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF1A1F3A),
                                ),
                              ),
                            )
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<auth_provider.AuthProvider>(context, listen: false);
      bool success = await authProvider.signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _displayNameController.text.trim(),
      );
      
      if (success && mounted) {
        _showEmailVerificationDialog();
      }
    }
  }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => PopScope(
        canPop: false, // Prevent back button dismiss
        child: EmailVerificationDialog(
          email: _emailController.text.trim(),
          onVerified: () {
            Navigator.of(context).pop(); // Dismiss dialog
            Navigator.of(context).pop(); // Go back to login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email verified! You can now sign in.'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
}

class EmailVerificationDialog extends StatefulWidget {
  final String email;
  final VoidCallback onVerified;

  const EmailVerificationDialog({
    super.key,
    required this.email,
    required this.onVerified,
  });

  @override
  State<EmailVerificationDialog> createState() => _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends State<EmailVerificationDialog> {
  bool _isChecking = false;
  bool _canResend = true;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _startPeriodicCheck();
  }

  void _startPeriodicCheck() {
    // Check every 3 seconds if email is verified
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _checkEmailVerification();
      }
    });
  }

  void _checkEmailVerification() async {
    if (!mounted) return;
    
    setState(() {
      _isChecking = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        
        if (user != null && user.emailVerified) {
          // Email verified! Update Firestore and call callback
          if (mounted) {
            final authProvider = Provider.of<auth_provider.AuthProvider>(context, listen: false);
            await authProvider.checkEmailVerification();
            widget.onVerified();
          }
          return;
        }
      }
    } catch (e) {
      // Handle error silently and continue checking
    }

    setState(() {
      _isChecking = false;
    });

    // Continue checking if not verified
    if (mounted) {
      _startPeriodicCheck();
    }
  }

  void _resendEmail() async {
    if (!_canResend) return;

    try {
      final authProvider = Provider.of<auth_provider.AuthProvider>(context, listen: false);
      await authProvider.sendEmailVerification();
      
      setState(() {
        _canResend = false;
        _resendCooldown = 60;
      });

      // Start cooldown timer
      for (int i = 60; i > 0; i--) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() {
            _resendCooldown = i - 1;
          });
        }
      }

      if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend email: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2A3150),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFDB750).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.email,
              color: Color(0xFFFDB750),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Verify Your Email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We\'ve sent a verification link to:',
            style: TextStyle(
              color: const Color(0xFFB0B5C9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFDB750).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              widget.email,
              style: const TextStyle(
                color: Color(0xFFFDB750),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Please check your email and click the verification link. This dialog will automatically close once your email is verified.',
            style: TextStyle(
              color: const Color(0xFFB0B5C9),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          if (_isChecking)
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFDB750)),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Checking verification status...',
                  style: TextStyle(
                    color: const Color(0xFFFDB750),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _canResend ? _resendEmail : null,
          child: Text(
            _canResend 
                ? 'Resend Email' 
                : 'Resend in ${_resendCooldown}s',
            style: TextStyle(
              color: _canResend 
                  ? const Color(0xFFFDB750) 
                  : const Color(0xFFB0B5C9),
            ),
          ),
        ),
      ],
    );
  }
}