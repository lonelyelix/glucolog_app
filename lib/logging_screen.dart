import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'app_theme.dart';
import 'models/glucose_entry.dart';

class LoggingScreen extends StatefulWidget {
  const LoggingScreen({super.key});

  @override
  State<LoggingScreen> createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController insulinController = TextEditingController();
  final TextEditingController foodController = TextEditingController();

  @override
  void dispose() {
    glucoseController.dispose();
    insulinController.dispose();
    foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'GlucoLog',
      currentIndex: 0,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.lightGreen,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 110),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE9D8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.lightGreen,
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'LOG YOUR GLUCOSE LEVEL!!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _buildLabel('Blood Glucose Level (mg/dL)'),
                    _buildInput(glucoseController),
                    const SizedBox(height: 16),
                    _buildLabel('Insulin Level (u/mL)'),
                    _buildInput(insulinController),
                    const SizedBox(height: 16),
                    _buildLabel('Food intake'),
                    _buildInput(foodController),
                    const SizedBox(height: 32),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.16),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightGreen,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(180, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () async {
                            final double? glucose = double.tryParse(
                              glucoseController.text,
                            );
                            final double? insulin = double.tryParse(
                              insulinController.text,
                            );
                            final double? foodIntake = double.tryParse(
                              foodController.text,
                            );

                            if (glucose == null ||
                                insulin == null ||
                                foodIntake == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter valid numbers'),
                                ),
                              );
                              return;
                            }

                            final entry = GlucoseEntry(
                              glucose: glucose,
                              insulin: insulin,
                              foodIntake: foodIntake,
                              time: DateTime.now(),
                            );

                            final docRef = await FirebaseFirestore.instance
                                .collection('entries')
                                .add({
                                  'glucose': entry.glucose,
                                  'insulin': entry.insulin,
                                  'foodIntake': entry.foodIntake,
                                  'time': Timestamp.now(),
                                });
                            print('saved doc id = ${docRef.id}');
                            print('saved glucose = ${entry.glucose}');

                            if (!context.mounted) return;
                            glucoseController.clear();
                            insulinController.clear();
                            foodController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Saved to Firebase'),
                              ),
                            );

                            //Navigator.pop(context);
                          },
                          child: const Text(
                            'Log entry',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(26, 24, 26, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent History',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 22),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('entries')
                            .orderBy('time', descending: true)
                            .limit(5)
                            .snapshots(),
                        builder: (context, snapshot) {
                          debugPrint(
                            'docs count: ${snapshot.data?.docs.length}',
                          );
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            final first =
                                snapshot.data!.docs.first.data()
                                    as Map<String, dynamic>;
                            print(
                              'top history item = ${first['glucose']} / ${first['time']}',
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                              ),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Text(
                              'No history yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                              ),
                            );
                          }

                          final docs = snapshot.data!.docs;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: docs.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final QueryDocumentSnapshot doc = entry.value;
                              final data = doc.data() as Map<String, dynamic>;
                              final rawTime = data['time'];

                              DateTime? time;
                              if (rawTime is Timestamp) {
                                time = rawTime.toDate();
                              } else if (rawTime is String) {
                                time = DateTime.tryParse(rawTime);
                              }

                              String label;
                              if (index == 0) {
                                label = 'Last logged';
                              } else if (index == 1) {
                                label = 'Before';
                              } else {
                                label = '';
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (label.isNotEmpty)
                                      Text(
                                        label,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    Text(
                                      time == null
                                          ? '${data['glucose']} mg/dL\nNo time'
                                          : '${data['glucose']} mg/dL\n'
                                                '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
                                                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6C7896),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: AppTheme.lightGreen.withOpacity(0.8),
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: AppTheme.lightGreen.withOpacity(0.8),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppTheme.darkGreen,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
