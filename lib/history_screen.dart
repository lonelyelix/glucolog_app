import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String formatDateTime(DateTime time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final day = twoDigits(time.day);
    final month = twoDigits(time.month);
    final year = time.year;

    int hour = time.hour;
    final minute = twoDigits(time.minute);
    final period = hour >= 12 ? 'PM' : 'AM';

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '$day/$month/$year  $hour:$minute $period';
  }

  DateTime? parseTime(dynamic rawTime) {
    if (rawTime is Timestamp) {
      return rawTime.toDate();
    } else if (rawTime is String) {
      return DateTime.tryParse(rawTime);
    }
    return null;
  }

  Future<void> deleteEntry(String docId) async {
    await FirebaseFirestore.instance.collection('entries').doc(docId).delete();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Entry deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> showDeleteDialog(String docId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await deleteEntry(docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('entries')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text('No history yet', style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final double glucose = (data['glucose'] as num?)?.toDouble() ?? 0;
              final double insulin = (data['insulin'] as num?)?.toDouble() ?? 0;
              final double foodIntake =
                  (data['foodIntake'] as num?)?.toDouble() ?? 0;
              final DateTime? time = parseTime(data['time']);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Glucose: $glucose',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Insulin: $insulin',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Food Intake: $foodIntake',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              time != null
                                  ? 'Time: ${formatDateTime(time)}'
                                  : 'Time: No time',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDeleteDialog(doc.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
