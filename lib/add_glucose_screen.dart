import 'package:flutter/material.dart';

class AddGlucoseScreen extends StatefulWidget {
  const AddGlucoseScreen({super.key});

  @override
  State<AddGlucoseScreen> createState() => _AddGlucoseScreenState();
}

class _AddGlucoseScreenState extends State<AddGlucoseScreen> {
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String selectedTime = 'Before Meal';
  String statusMessage = '';

  static const Color bgColor = Color(0xFFB9D45B);
  static const Color cardColor = Color(0xFFF3EEDB);
  static const Color darkGreen = Color(0xFF1F5A2E);
  static const Color textDark = Color(0xFF2E2E2E);

  void checkGlucoseLevel() {
    final value = double.tryParse(glucoseController.text);

    if (value == null) {
      setState(() {
        statusMessage = 'Please enter a valid glucose value.';
      });
      return;
    }

    setState(() {
      if (value < 70) {
        statusMessage = 'Glucose is too low.';
      } else if (value > 180) {
        statusMessage = 'Glucose is too high.';
      } else {
        statusMessage = 'Glucose is within safe range.';
      }
    });
  }

  @override
  void dispose() {
    glucoseController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'Add Glucose Entry',
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Glucose Value (mg/dL)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: glucoseController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter glucose value',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reading Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedTime,
                items: const [
                  DropdownMenuItem(
                    value: 'Before Meal',
                    child: Text('Before Meal'),
                  ),
                  DropdownMenuItem(
                    value: 'After Meal',
                    child: Text('After Meal'),
                  ),
                  DropdownMenuItem(value: 'Fasting', child: Text('Fasting')),
                  DropdownMenuItem(
                    value: 'Before Sleep',
                    child: Text('Before Sleep'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedTime = value!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Optional notes',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                  onPressed: checkGlucoseLevel,
                  child: const Text(
                    'Save Entry',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (statusMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    statusMessage,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
