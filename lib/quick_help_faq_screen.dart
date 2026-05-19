import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_shell.dart';
import 'ai_assisted_chat_screen.dart';

class QuickHelpFaqScreen extends StatelessWidget {
  const QuickHelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = [
      'How do I log my insulin dose?',
      'What should my glucose target range be?',
      'How do I set up glucose alerts?',
      'Can I share my data with my doctor?',
      'What if I miss logging a dose?',
      'How do I interpret my glucose trends?',
    ];

    return AppShell(
      title: 'GlucoLog',
      currentIndex: 2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 110),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          decoration: BoxDecoration(
            color: AppTheme.cream,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 6, top: 4),
                child: Text(
                  'Customer support',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6C7896),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F7),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.14),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF2F8A2F),
                          child: Text(
                            '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Quick help & FAQs',
                          style: TextStyle(
                            color: Color(0xFF6C7896),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    ...questions.map(
                      (question) => Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              question,
                              style: const TextStyle(
                                color: Color(0xFF6C7896),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 18,
                            thickness: 1,
                            color: Color(0xFFB8BBC4),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AiAssistedChatScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7E8FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF2F8A2F)),
                        ),
                        child: Column(
                          children: const [
                            Text(
                              "Can’t find what you’re looking for?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C789A),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Continue to AI-assisted chat',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 250),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 34,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.14),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Color(0xFF68758F),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Color(0xFF68758F),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
