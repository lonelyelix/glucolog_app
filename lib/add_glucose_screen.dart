import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_shell.dart';

class AddGlucoseScreen extends StatefulWidget {
  const AddGlucoseScreen({super.key});

  @override
  State<AddGlucoseScreen> createState() => _AddGlucoseScreenState();
}

class _AddGlucoseScreenState extends State<AddGlucoseScreen> {
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
      title: 'Log Your Glucose Level',
      currentIndex: 0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cream,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Blood Glucose Level (mg/dL)',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: glucoseController),
                  const SizedBox(height: 14),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Insulin Level (u/mL)',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: insulinController),
                  const SizedBox(height: 14),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Food Intake',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: foodController),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Log Entry'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}