import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GlucoLogApp());
}

class GlucoLogApp extends StatelessWidget {
  const GlucoLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GlucoLog',
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}
