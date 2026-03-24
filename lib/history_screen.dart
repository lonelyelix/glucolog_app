import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_shell.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final List<String> items = List.generate(
    7,
    (_) => 'Time : 23/10/2025 4:38 PM',
  );

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Timeline / History',
      currentIndex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cream,
            borderRadius: BorderRadius.circular(24),
          ),
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFA9E9A0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  items[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}