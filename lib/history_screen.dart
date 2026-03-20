import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final List<Map<String, String>> glucoseLogs = [
    {
      'value': '115 mg/dL',
      'time': 'Today, 8:30 AM',
      'status': 'Within target range',
    },
    {'value': '185 mg/dL', 'time': 'Yesterday, 7:45 PM', 'status': 'Too high'},
    {'value': '68 mg/dL', 'time': 'Yesterday, 6:15 AM', 'status': 'Too low'},
    {
      'value': '124 mg/dL',
      'time': '22 Mar 2026, 1:10 PM',
      'status': 'Within target range',
    },
  ];

  static const Color bgColor = Color(0xFFB9D45B);
  static const Color cardColor = Color(0xFFF3EEDB);
  static const Color darkGreen = Color(0xFF1F5A2E);
  static const Color textDark = Color(0xFF2E2E2E);

  Color getStatusColor(String status) {
    if (status == 'Too high') return Colors.red;
    if (status == 'Too low') return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'History / Timeline',
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: glucoseLogs.length,
        itemBuilder: (context, index) {
          final log = glucoseLogs[index];
          final status = log['status'] ?? '';
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: getStatusColor(status).withOpacity(0.15),
                  child: Icon(
                    Icons.monitor_heart,
                    color: getStatusColor(status),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log['value'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        log['time'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: getStatusColor(status),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
