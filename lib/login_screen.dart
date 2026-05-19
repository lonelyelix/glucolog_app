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
  bool rememberMe = false;

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
        MaterialPageRoute(builder: (context) => const GlucoLogHomeScreen()),
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

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage('Enter your email first');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showMessage('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      showMessage(_getAuthErrorMessage(e));
    } catch (e) {
      showMessage('Error: $e');
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
      case 'network-request-failed':
        return 'Network error. Check your internet connection';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'operation-not-allowed':
        return 'Email/password login is not enabled in Firebase';
      default:
        return e.message ?? 'Login failed';
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }

  void showSocialLoginMessage(String provider) {
    showMessage('$provider sign in is not connected yet');
  }

  Widget buildInput({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: hintText == 'Email'
            ? TextInputType.emailAddress
            : TextInputType.text,
        textInputAction: hintText == 'Email'
            ? TextInputAction.next
            : TextInputAction.done,
        onSubmitted: (_) {
          if (hintText == 'Password') {
            signIn();
          }
        },
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
            borderSide: const BorderSide(color: AppTheme.darkGreen, width: 1.5),
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

  Widget socialButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4D8E1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
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
              top: 28,
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
                        fontSize: 34,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Track your glucose levels',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Log your insulin intake',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'View your history',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Gain insights',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 13,
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
              top: 250,
              child: Image.asset(
                'assets/images/fruits.png',
                height: 210,
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 390,
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
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

                    const SizedBox(height: 14),

                    buildInput(controller: emailController, hintText: 'Email'),

                    const SizedBox(height: 12),

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

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          activeColor: AppTheme.darkGreen,
                          visualDensity: VisualDensity.compact,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Remember me',
                          style: TextStyle(
                            color: Color(0xFF677A9A),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: forgotPassword,
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Color(0xFF677A9A),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
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
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
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

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4F4F4),
                          foregroundColor: const Color(0xFF677A9A),
                          side: const BorderSide(color: Color(0xFFD4D8E1)),
                          elevation: 3,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
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

                    const SizedBox(height: 12),

                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            color: Color(0xFFD4D8E1),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Or sign in with',
                            style: TextStyle(
                              color: Color(0xFF677A9A),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFFD4D8E1),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialButton(
                          label: 'G',
                          color: Colors.red,
                          onTap: () {
                            showSocialLoginMessage('Google');
                          },
                        ),
                        const SizedBox(width: 14),
                        socialButton(
                          label: 'f',
                          color: Colors.blue,
                          onTap: () {
                            showSocialLoginMessage('Facebook');
                          },
                        ),
                        const SizedBox(width: 14),
                        socialButton(
                          label: '',
                          color: Colors.black,
                          onTap: () {
                            showSocialLoginMessage('Apple');
                          },
                        ),
                      ],
                    ),

                    const Spacer(),
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
