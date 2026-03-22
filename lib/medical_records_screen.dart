import 'package:flutter/material.dart';

class MedicalRecordsScreen extends StatelessWidget {
  MedicalRecordsScreen({super.key});

  final List<Map<String, String>> records = [
    {'title': 'Blood Test Report', 'date': '15 Mar 2026', 'type': 'PDF'},
    {
      'title': 'Diabetes Specialist Notes',
      'date': '02 Mar 2026',
      'type': 'DOC',
    },
    {'title': 'Glucose Lab Summary', 'date': '21 Feb 2026', 'type': 'PDF'},
  ];

  static const Color bgColor = Color(0xFFB9D45B);
  static const Color cardColor = Color(0xFFF3EEDB);
  static const Color darkGreen = Color(0xFF1F5A2E);
  static const Color textDark = Color(0xFF2E2E2E);

  IconData getFileIcon(String type) {
    if (type == 'PDF') return Icons.picture_as_pdf;
    if (type == 'DOC') return Icons.description;
    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'Medical Records',
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        onPressed: () {
          // TODO: upload later
        },
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Record'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Text(
              'Store and review important medical files such as blood test results, specialist notes, and treatment summaries.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 16),
          ...records.map((record) {
            final type = record['type'] ?? '';
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(getFileIcon(type), color: darkGreen),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        Text('Date: ${record['date']}'),
                        Text('Type: $type'),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility_outlined),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}