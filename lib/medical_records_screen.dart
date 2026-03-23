import 'package:flutter/material.dart';
import 'app_theme.dart';

class MedicalRecordsScreen extends StatelessWidget {
  MedicalRecordsScreen({super.key});

  final List<Map<String, String>> records = [
    {'title': 'Blood Test Report', 'date': '15 Mar 2026', 'type': 'PDF'},
    {'title': 'Diabetes Specialist Notes', 'date': '02 Mar 2026', 'type': 'DOC'},
    {'title': 'Glucose Lab Summary', 'date': '21 Feb 2026', 'type': 'PDF'},
  ];

  IconData getFileIcon(String type) {
    if (type == 'PDF') return Icons.picture_as_pdf;
    if (type == 'DOC') return Icons.description;
    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreen,
      appBar: AppBar(
        title: const Text(
          'Medical Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.darkGreen,
        foregroundColor: Colors.white,
        onPressed: () {},
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Record'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...records.map((record) {
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cream,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(
                      getFileIcon(record['type'] ?? ''),
                      color: AppTheme.darkGreen,
                    ),
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
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Date: ${record['date']}'),
                        Text('Type: ${record['type']}'),
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