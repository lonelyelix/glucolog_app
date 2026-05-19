import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'create_account_screen.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentStep = 1;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController minGlucoseController = TextEditingController(
    text: '70',
  );
  final TextEditingController maxGlucoseController = TextEditingController(
    text: '180',
  );

  String diabetesType = 'Just monitoring my health';
  String medication = 'Insulin';
  String? selectedFileName;

  bool isSaving = false;

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    urlController.dispose();
    minGlucoseController.dispose();
    maxGlucoseController.dispose();
    super.dispose();
  }

  Future<void> pickMedicalFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'svg', 'zip', 'pdf'],
    );

    if (result == null) return;

    setState(() {
      selectedFileName = result.files.single.name;
    });
  }

  void nextStep() {
    if (currentStep == 1) {
      if (ageController.text.trim().isEmpty ||
          weightController.text.trim().isEmpty ||
          heightController.text.trim().isEmpty) {
        showMessage('Please fill in your basic information');
        return;
      }
    }

    if (currentStep < 4) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
      });
    }
  }

  Future<void> completeOnboarding() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMessage('User not found');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('user_profiles')
          .doc(user.uid)
          .set({
            'email': user.email,
            'age': ageController.text.trim(),
            'weightKg': weightController.text.trim(),
            'heightCm': heightController.text.trim(),
            'diabetesType': diabetesType,
            'medicalFileName': selectedFileName,
            'medicalFileUrl': urlController.text.trim(),
            'medication': medication,
            'targetGlucoseMin': minGlucoseController.text.trim(),
            'targetGlucoseMax': maxGlucoseController.text.trim(),
            'onboardingCompleted': true,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GlucoLogHomeScreen()),
      );
    } catch (e) {
      showMessage('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF9AA6BA),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.95),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Color(0xFFC8D96B)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Color(0xFFC8D96B), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: AppTheme.darkGreen, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget stepCircle(int step) {
    final bool completed = currentStep > step;
    final bool active = currentStep == step;

    return Column(
      children: [
        Text(
          'Step $step',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            color: completed || active ? AppTheme.darkGreen : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: completed || active
                  ? AppTheme.darkGreen
                  : const Color(0xFFD4D8E1),
            ),
          ),
          child: Center(
            child: completed
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : Text(
                    '$step',
                    style: TextStyle(
                      color: active ? Colors.white : const Color(0xFF6C7896),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget progressHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step $currentStep out of 4',
            style: const TextStyle(
              color: AppTheme.darkGreen,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              stepCircle(1),
              const Expanded(child: _Dots()),
              stepCircle(2),
              const Expanded(child: _Dots()),
              stepCircle(3),
              const Expanded(child: _Dots()),
              stepCircle(4),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: currentStep / 4,
              minHeight: 5,
              backgroundColor: const Color(0xFFE5E0C8),
              color: AppTheme.darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget pageCard({required Widget child}) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        decoration: BoxDecoration(
          color: AppTheme.cream.withOpacity(0.96),
          borderRadius: BorderRadius.circular(28),
        ),
        child: child,
      ),
    );
  }

  Widget stepOne() {
    return pageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic information',
            style: TextStyle(
              color: Color(0xFF6C7896),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'Help us understand your health profile better',
            style: TextStyle(
              color: Color(0xFF6C7896),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 22),
          const _InputLabel('How old are you?'),
          buildInput(
            controller: ageController,
            hintText: '',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 22),
          const _InputLabel("What's your weight? (kg)"),
          buildInput(
            controller: weightController,
            hintText: '',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 22),
          const _InputLabel("What's your height? (cm)"),
          buildInput(
            controller: heightController,
            hintText: '',
            keyboardType: TextInputType.number,
          ),
          const Spacer(),
          _BottomButtons(
            showBack: true,
            continueText: 'Continue',
            onBack: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateAccountScreen(),
                ),
              );
            },
            onContinue: nextStep,
          ),
          const _PrivateText(),
        ],
      ),
    );
  }

  Widget diabetesOption(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: diabetesType,
            activeColor: AppTheme.darkGreen,
            onChanged: (newValue) {
              setState(() {
                diabetesType = newValue ?? value;
              });
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  diabetesType = value;
                });
              },
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: const Color(0xFFC8D96B)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF6C7896),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stepTwo() {
    return pageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Diabetes information',
            style: TextStyle(
              color: Color(0xFF6C7896),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'This helps us provide better insights',
            style: TextStyle(
              color: Color(0xFF6C7896),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          const _InputLabel('Do you have diabetes?'),
          const SizedBox(height: 8),
          diabetesOption('Type 1 Diabetes'),
          diabetesOption('Type 2 Diabetes'),
          diabetesOption('Prediabetes'),
          diabetesOption('Just monitoring my health'),
          const Spacer(),
          _BottomButtons(
            showBack: true,
            continueText: 'Continue',
            onBack: previousStep,
            onContinue: nextStep,
          ),
          const _PrivateText(),
        ],
      ),
    );
  }

  Widget stepThree() {
    return pageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medical record (optional)',
            style: TextStyle(
              color: Color(0xFF6C7896),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'This helps us provide better insights',
            style: TextStyle(
              color: Color(0xFF6C7896),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          const _InputLabel('Attach a valid file below'),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 205,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC8D96B)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload,
                  color: AppTheme.darkGreen,
                  size: 55,
                ),
                Text(
                  selectedFileName ?? 'Drag and drop files to\nupload',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6C7896),
                    fontSize: 15,
                    height: 1.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'OR',
                  style: TextStyle(
                    color: Color(0xFF6C7896),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: pickMedicalFile,
                  child: Container(
                    width: 120,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFBE5C),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Browse',
                        style: TextStyle(
                          color: Color(0xFF6C7896),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Only support .jpg, .png and .svg and zip files',
            style: TextStyle(
              color: Color(0xFF6C7896),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Upload from URL',
            style: TextStyle(
              color: Color(0xFF6C7896),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          buildInput(controller: urlController, hintText: 'Add file URL'),
          const Spacer(),
          _BottomButtons(
            showBack: true,
            continueText: 'Continue',
            onBack: previousStep,
            onContinue: nextStep,
          ),
          const _PrivateText(),
        ],
      ),
    );
  }

  Widget medicationOption(String value) {
    return RadioListTile<String>(
      value: value,
      groupValue: medication,
      dense: true,
      activeColor: AppTheme.darkGreen,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      title: Text(
        value,
        style: const TextStyle(
          color: Color(0xFF6C7896),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
      onChanged: (newValue) {
        setState(() {
          medication = newValue ?? value;
        });
      },
    );
  }

  Widget stepFour() {
    return pageCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health management',
              style: TextStyle(
                color: Color(0xFF6C7896),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Set your medication and target glucose range',
              style: TextStyle(
                color: Color(0xFF6C7896),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Current medications (Optional)',
              style: TextStyle(
                color: Color(0xFF6C7896),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: const Color(0xFFC8D96B)),
              ),
              child: Column(
                children: [
                  medicationOption('Insulin'),
                  medicationOption('Metformin'),
                  medicationOption('Glipizide'),
                  medicationOption('Januvia'),
                  medicationOption('Ozempic'),
                  medicationOption('Other'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Target Glucose range',
              style: TextStyle(
                color: Color(0xFF6C7896),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Set your personal target range',
              style: TextStyle(
                color: Color(0xFF6C7896),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const _InputLabel('Minimum Level (mg/dL)'),
            buildInput(controller: minGlucoseController, hintText: '70'),
            const SizedBox(height: 12),
            const _InputLabel('Maximum Level (mg/dL)'),
            buildInput(controller: maxGlucoseController, hintText: '180'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDFA6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Recommended: 70–180 mg/dL. Consult with your healthcare provider for personalized targets.',
                style: TextStyle(
                  color: Color(0xFF6C7896),
                  fontSize: 11,
                  height: 1.35,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 22),
            _BottomButtons(
              showBack: true,
              continueText: isSaving ? 'Saving...' : 'Complete',
              onBack: previousStep,
              onContinue: isSaving ? () {} : completeOnboarding,
            ),
            const _PrivateText(),
          ],
        ),
      ),
    );
  }

  Widget currentStepBody() {
    if (currentStep == 1) return stepOne();
    if (currentStep == 2) return stepTwo();
    if (currentStep == 3) return stepThree();
    return stepFour();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreen,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: AppTheme.lightGreen)),
            Positioned(
              left: 0,
              right: 0,
              bottom: -10,
              child: Image.asset(
                'assets/images/fruits.png',
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'GlucoLog',
                      style: TextStyle(
                        fontFamily: 'Coiny',
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.cream.withOpacity(0.94),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: progressHeader(),
                  ),
                  const SizedBox(height: 24),
                  currentStepBody(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '•••',
        style: TextStyle(
          color: AppTheme.darkGreen,
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 3,
        ),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String text;

  const _InputLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF6C7896),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PrivateText extends StatelessWidget {
  const _PrivateText();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 6),
      child: Center(
        child: Text(
          'Your information is private and secure',
          style: TextStyle(
            color: Color(0xFF9AA6BA),
            fontSize: 8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {
  final bool showBack;
  final String continueText;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const _BottomButtons({
    required this.showBack,
    required this.continueText,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          Expanded(
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '← Back',
                    style: TextStyle(
                      color: Color(0xFF6C7896),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (showBack) const SizedBox(width: 14),
        Expanded(
          flex: showBack ? 2 : 1,
          child: GestureDetector(
            onTap: onContinue,
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFC8D96B),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$continueText →',
                  style: const TextStyle(
                    color: Color(0xFF6C7896),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
