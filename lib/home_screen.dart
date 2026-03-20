import 'package:flutter/material.dart';
import 'add_glucose_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'medical_records_screen.dart';

class GlucoLogHomeScreen extends StatelessWidget {
  GlucoLogHomeScreen({super.key});

  static const Color bgColor = Color(0xFFB9D45B);
  static const Color cardColor = Color(0xFFF3EEDB);
  static const Color mintCard = Color(0xFFDDF3E5);
  static const Color darkGreen = Color(0xFF1F5A2E);
  static const Color textDark = Color(0xFF2E2E2E);
  static const Color accentGreen = Color(0xFF76C44F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: darkGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildCurrentGlucoseCard(),
              const SizedBox(height: 16),
              _buildStatsGrid(),
              const SizedBox(height: 16),
              _buildChartCard(),
              const SizedBox(height: 16),
              _buildLoggingBanner(),
              const SizedBox(height: 16),
              _buildShortcutGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.grey, size: 30),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Hero",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Ready to check?",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        const Icon(Icons.notifications_none, size: 28, color: textDark),
      ],
    );
  }

  Widget _buildCurrentGlucoseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: mintCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: accentGreen.withOpacity(0.4)),
      ),
      child: Column(
        children: const [
          Text(
            "Current Glucose levels",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          SizedBox(height: 8),
          Text(
            "115 mg/dL",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Within target range",
            style: TextStyle(
              fontSize: 13,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        _MiniStatCard(title: "Log Food Intake", value: "1800", unit: "Cal/day"),
        _GlucoseNavCard(),
        _MiniStatCard(title: "Log Insulin Level", value: "8", unit: "u/mL"),
        _MiniStatCard(
          title: "Current Glucose Level",
          value: "In-range",
          unit: "",
        ),
      ],
    );
  }

  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mintCard,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "Chart Placeholder",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildLoggingBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              "Logging / Tracking\nLast logged: 23/10/2025 4:38 PM",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(Icons.bar_chart, color: Colors.greenAccent, size: 34),
        ],
      ),
    );
  }

  Widget _buildShortcutGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 0.95,
      children: const [
        _HistoryNavCard(),
        _ShortcutCard(
          title: "Graph &\nChart",
          icon: Icons.graphic_eq,
          color: Color(0xFF46C85B),
        ),
        _MedicalRecordsNavCard(),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GlucoLogHomeScreen.cardColor,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: GlucoLogHomeScreen.textDark,
                  ),
                ),
                TextSpan(
                  text: unit.isNotEmpty ? " $unit" : "",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _ShortcutCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(icon, size: 40, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _GlucoseNavCard extends StatelessWidget {
  const _GlucoseNavCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddGlucoseScreen()),
        );
      },
      child: const _MiniStatCard(
        title: "Log Glucose Level",
        value: "115",
        unit: "mg/dL",
      ),
    );
  }
}

class _HistoryNavCard extends StatelessWidget {
  const _HistoryNavCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen()),
        );
      },
      child: const _ShortcutCard(
        title: "Timeline/\nHistory",
        icon: Icons.timeline,
        color: Color(0xFF8EEA66),
      ),
    );
  }
}

class _MedicalRecordsNavCard extends StatelessWidget {
  const _MedicalRecordsNavCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MedicalRecordsScreen()),
        );
      },
      child: const _ShortcutCard(
        title: "Medical\nRecords",
        icon: Icons.folder_open,
        color: Color(0xFFF2E95A),
      ),
    );
  }
}
