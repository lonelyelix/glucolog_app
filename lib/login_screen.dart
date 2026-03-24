import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreen,
      body: SafeArea(
        child: Stack(
          children: [
            // background
            Positioned.fill(
              child: Container(
                color: AppTheme.lightGreen,
              ),
            ),

            // soft background curves
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

            // top text
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

            // fruit image
            Positioned(
              left: 0,
              right: 0,
              bottom: 190,
              child: Image.asset(
                'assets/images/fruits.png',
                height: 500,
                fit: BoxFit.contain,
              ),
            ),

            // login panel
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 540,
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
                    const SizedBox(height: 24),

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
                        onPressed: () {},
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

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
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GlucoLogHomeScreen(),
                            ),
                          );
                        },
                        child: const Text(
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
          ],
        ),
      ),
    );
  }
}