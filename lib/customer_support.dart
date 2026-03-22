import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  static const Color bgColor = Color(0xFFF6F3E6);
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF4B4B5C);
  static const Color selectedColor = Color(0xFF1F5A2E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'Customer support',
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: selectedColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GlucoLogHomeScreen()),
              );
              break;
            case 1:
              // Navigate to Reports page
              break;
            case 2:
              // Navigate to Notifications page
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined), label: "Reports"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _supportCard(
              icon: Icons.chat_bubble_outline,
              iconBg: Colors.blue[100]!,
              title: 'Live Chat with Doctor',
              subtitle: 'Get real-time support from healthcare professionals',
              status: 'Doctors available now',
              statusColor: Colors.green,
            ),
            const SizedBox(height: 16),
            _supportCard(
              icon: Icons.warning_amber_outlined,
              iconBg: Colors.red[100]!,
              title: 'Emergency support',
              subtitle: 'Call emergency services for urgent medical help',
              status: 'Available 24/7',
              statusColor: Colors.red,
            ),
            const SizedBox(height: 16),
            _supportCard(
              icon: Icons.help_outline,
              iconBg: Colors.green[100]!,
              title: 'Quick help & FAQs',
              subtitle: 'Find answers to common questions instantly',
              status: '',
              statusColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportCard({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                if (status.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}