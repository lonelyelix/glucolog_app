import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'onboarding_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool agreed = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match');
      return;
    }

    if (!agreed) {
      showMessage('Please agree before creating an account');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } on FirebaseAuthException catch (e) {
      showMessage(_getAuthErrorMessage(e));
    } catch (e) {
      showMessage('Error: $e');
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
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'network-request-failed':
        return 'Network error. Check your internet connection';
      case 'operation-not-allowed':
        return 'Email/password sign up is not enabled in Firebase';
      default:
        return e.message ?? 'Account creation failed';
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: hintText.toLowerCase().contains('email')
            ? TextInputType.emailAddress
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF9AA6BA),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.95),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Color(0xFFC8D96B)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Color(0xFFC8D96B), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: AppTheme.darkGreen, width: 1.5),
          ),
          suffixIcon: toggleObscure != null
              ? IconButton(
                  onPressed: toggleObscure,
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black45,
                    size: 18,
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
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: AppTheme.lightGreen)),

            Positioned(
              top: -60,
              left: -120,
              child: Container(
                width: 310,
                height: 310,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              top: -30,
              left: 60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            const Positioned(
              top: 44,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to\nGlucoLog',
                    style: TextStyle(
                      fontFamily: 'Coiny',
                      fontSize: 34,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.darkGreen,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Track your glucose levels',
                    style: TextStyle(
                      fontFamily: 'Coiny',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkGreen,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Log your insulin intake',
                    style: TextStyle(
                      fontFamily: 'Coiny',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkGreen,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'View your history',
                    style: TextStyle(
                      fontFamily: 'Coiny',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkGreen,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Gain insights',
                    style: TextStyle(
                      fontFamily: 'Coiny',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkGreen,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 46,
              right: 28,
              child: Text(
                'Sample',
                style: TextStyle(
                  color: AppTheme.darkGreen.withOpacity(0.65),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              top: 248,
              child: Image.asset(
                'assets/images/fruits.png',
                height: 175,
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 425,
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
                decoration: BoxDecoration(
                  color: AppTheme.cream.withOpacity(0.96),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 17,
                              color: Color(0xFF6C7896),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Sign up to get started!',
                              style: TextStyle(
                                color: Color(0xFF6C7896),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 34),
                      ],
                    ),

                    const SizedBox(height: 18),

                    buildInput(
                      controller: emailController,
                      hintText: 'Enter your email address...',
                    ),

                    const SizedBox(height: 14),

                    buildInput(
                      controller: passwordController,
                      hintText: 'Create a password...',
                      obscureText: obscurePassword,
                      toggleObscure: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    buildInput(
                      controller: confirmPasswordController,
                      hintText: 'Confirm your password...',
                      obscureText: obscureConfirmPassword,
                      toggleObscure: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: agreed,
                          activeColor: const Color(0xFFC8D96B),
                          checkColor: Colors.white,
                          visualDensity: VisualDensity.compact,
                          onChanged: (value) {
                            setState(() {
                              agreed = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'By checking the box, you agree to accept our notifications, and consent to the use of your data',
                              style: TextStyle(
                                color: Color(0xFF6C7896),
                                fontSize: 11,
                                height: 1.35,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    GestureDetector(
                      onTap: isLoading ? null : createAccount,
                      child: Container(
                        width: 150,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8D96B),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Create account',
                                  style: TextStyle(
                                    color: Color(0xFF6C7896),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
