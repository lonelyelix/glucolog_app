import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const GlucoLogApp());
}

class GlucoLogApp extends StatelessWidget {
  const GlucoLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GlucoLog',
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
