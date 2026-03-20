import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color bgColor = Color(0xFFB9D45B);
  static const Color cardColor = Color(0xFFF3EEDB);
  static const Color darkGreen = Color(0xFF1F5A2E);
  static const Color textDark = Color(0xFF2E2E2E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
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
                    'John Doe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'john.doe@email.com',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _infoCard(
              title: 'Personal Information',
              children: const [
                _InfoRow(label: 'Age', value: '24'),
                _InfoRow(label: 'Gender', value: 'Male'),
                _InfoRow(label: 'Condition', value: 'Type 1 Diabetes'),
              ],
            ),
            const SizedBox(height: 16),
            _infoCard(
              title: 'Health Targets',
              children: const [
                _InfoRow(
                  label: 'Target Glucose Range',
                  value: '70 - 180 mg/dL',
                ),
                _InfoRow(label: 'Insulin Goal', value: '8 u/mL'),
                _InfoRow(label: 'Daily Calorie Goal', value: '1800 Cal'),
              ],
            ),
            const SizedBox(height: 16),
            _infoCard(
              title: 'Account Settings',
              children: const [
                _InfoRow(label: 'Notifications', value: 'Enabled'),
                _InfoRow(label: 'Reminders', value: 'Active'),
                _InfoRow(label: 'Dark Mode', value: 'Off'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ProfileScreen.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
