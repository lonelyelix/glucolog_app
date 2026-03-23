import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_shell.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Customer Support',
      currentIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cream,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.support_agent, size: 56, color: AppTheme.darkGreen),
              SizedBox(height: 16),
              Text(
                'Need help?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Contact our support team for help with glucose logging, profile issues, and medical records access.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 20),
              Text('Email: support@glucolog.com'),
              SizedBox(height: 8),
              Text('Phone: +61 400 000 000'),
            ],
          ),
        ),
      ),
    );
  }
}