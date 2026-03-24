import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_shell.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Profile',
      currentIndex: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cream,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 44, color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'CSIT321',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('CSIT321isfun@gmail.com'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ProfileSection(
              title: 'Personal Information',
              children: const [
                _InfoRow(label: 'Age', value: '22'),
                _InfoRow(label: 'Weight', value: '154 lbs'),
                _InfoRow(label: 'Height', value: '5\'9'),
                _InfoRow(label: 'Condition', value: 'Type 1 Diabetes'),
              ],
            ),
            const SizedBox(height: 16),
            _ProfileSection(
              title: 'Health Targets',
              children: const [
                _InfoRow(label: 'Target Glucose Range', value: '70 - 180 mg/dL'),
                _InfoRow(label: 'Insulin Goal', value: '8 u/mL'),
                _InfoRow(label: 'Daily Calories', value: '1800'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}