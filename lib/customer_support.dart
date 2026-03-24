import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_shell.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6C7896),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              _SupportCard(
                bgColor: const Color(0xFFF4F4F7),
                iconBg: const Color(0xFFAFC2F0),
                icon: Icons.chat_bubble_outline,
                title: 'Live Chat with Doctor',
                subtitle:
                    'Get real-time support from healthcare\nprofessionals',
                footer: Row(
                  children: const [
                    _StatusDot(color: Color(0xFF76E245)),
                    SizedBox(width: 10),
                    Text(
                      'Doctors available now',
                      style: TextStyle(
                        color: Color(0xFFF08538),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _SupportCard(
                bgColor: const Color(0xFFE8B1A4),
                iconBg: const Color(0xFFEF6D3A),
                icon: Icons.priority_high,
                title: 'Emergency support',
                subtitle:
                    'Call emergency services for urgent medical help',
                footer: const Text(
                  'Available 24/7',
                  style: TextStyle(
                    color: Color(0xFFF06F2E),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _SupportCard(
                bgColor: const Color(0xFFF4F4F7),
                iconBg: const Color(0xFF2F6F24),
                icon: Icons.question_mark,
                title: 'Quick help & FAQs',
                subtitle:
                    'Find answers to common questions instantly',
                footer: const SizedBox.shrink(),
              ),

              const SizedBox(height: 120),

              Center(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
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
                        borderRadius: BorderRadius.circular(22),
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
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: Color(0xFF68758F),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
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

class _SupportCard extends StatelessWidget {
  final Color bgColor;
  final Color iconBg;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget footer;

  const _SupportCard({
    required this.bgColor,
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF6C7896),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6C7896),
                        fontSize: 15,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    footer,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;

  const _StatusDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF6C7896),
          width: 1,
        ),
      ),
    );
  }
}