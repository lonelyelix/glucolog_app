import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'create_account_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter email and password');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GlucoLogHomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showMessage(_getAuthErrorMessage(e));
    } catch (e) {
      showMessage('Something went wrong');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address';
      case 'invalid-credential':
        return 'Wrong email or password';
      case 'user-not-found':
        return 'No user found for that email';
      case 'wrong-password':
        return 'Wrong password';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return e.message ?? 'Authentication error';
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xFFF4F4F4),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: Color(0xFFD4D8E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: AppTheme.darkGreen,
              width: 1.5,
            ),
          ),
          suffixIcon: toggleObscure != null
              ? IconButton(
                  onPressed: toggleObscure,
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreen,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: AppTheme.lightGreen),
            ),
            Positioned(
              top: -40,
              left: -140,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: -20,
              left: -40,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Positioned(
              top: 34,
              left: 16,
              right: 16,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to\nGlucoLog',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 38,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      'Track your glucose levels',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Log your insulin intake',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'View your history',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Gain insights',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 220,
              child: Image.asset(
                'assets/images/fruits.png',
                height: 430,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 500,
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(34),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF677A9A),
                        ),
                      ),
                      const SizedBox(height: 18),
                      buildInput(
                        controller: emailController,
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 14),
                      buildInput(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: obscurePassword,
                        toggleObscure: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4F4F4),
                            foregroundColor: const Color(0xFF677A9A),
                            side: const BorderSide(color: Color(0xFFD4D8E1)),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateAccountScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC8D96B),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: isLoading ? null : signIn,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}