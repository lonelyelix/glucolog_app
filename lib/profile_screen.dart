import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_shell.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditingPersonalInfo = false;

  final TextEditingController ageController = TextEditingController(text: '22');
  final TextEditingController weightController = TextEditingController(
    text: '154 lbs',
  );
  final TextEditingController heightController = TextEditingController(
    text: "5'9",
  );
  final TextEditingController conditionController = TextEditingController(
    text: 'Type 1 Diabetes',
  );

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    conditionController.dispose();
    super.dispose();
  }

  void togglePersonalInfoEdit() {
    setState(() {
      isEditingPersonalInfo = !isEditingPersonalInfo;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditingPersonalInfo
              ? 'Personal Information edit mode enabled'
              : 'Personal Information saved',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Profile',
      currentIndex: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cream,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 44, color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'CSIT321',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('CSIT321isfun@gmail.com'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _ProfileSection(
              title: 'Personal Information',
              action: TextButton(
                onPressed: togglePersonalInfoEdit,
                child: Text(isEditingPersonalInfo ? 'Save' : 'Edit'),
              ),
              children: [
                _EditableInfoRow(
                  label: 'Age',
                  controller: ageController,
                  isEditing: isEditingPersonalInfo,
                ),
                _EditableInfoRow(
                  label: 'Weight',
                  controller: weightController,
                  isEditing: isEditingPersonalInfo,
                ),
                _EditableInfoRow(
                  label: 'Height',
                  controller: heightController,
                  isEditing: isEditingPersonalInfo,
                ),
                _EditableInfoRow(
                  label: 'Condition',
                  controller: conditionController,
                  isEditing: isEditingPersonalInfo,
                ),
              ],
            ),

            const SizedBox(height: 16),

            const _ProfileSection(
              title: 'Health Targets',
              children: [
                _InfoRow(
                  label: 'Target Glucose Range',
                  value: '70 - 180 mg/dL',
                ),
                _InfoRow(label: 'Insulin Goal', value: '8 u/mL'),
                _InfoRow(label: 'Daily Calories', value: '1800'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? action;

  const _ProfileSection({
    required this.title,
    required this.children,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _EditableInfoRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;

  const _EditableInfoRow({
    required this.label,
    required this.controller,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: isEditing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Text(label)),
                Text(
                  controller.text,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
    );
  }
}
