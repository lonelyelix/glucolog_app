import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'GlucoLog',
      currentIndex: 2,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 110),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildTitleCard(),
            const SizedBox(height: 14),
            _buildNotificationPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: const [
        CircleAvatar(
          radius: 24,
          backgroundColor: Color(0xFF6A6A6A),
          child: Icon(Icons.person_outline, color: Colors.white, size: 30),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Hero",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Ready to check?",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.notifications, size: 28, color: Color(0xFFF28A5A)),
      ],
    );
  }

  Widget _buildTitleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF8A8E97),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationPanel() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF173F1A),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: const [
          _NotificationItem(
            avatarColor: Color(0xFF7E5C4A),
            title: 'Dr. Nandy has accepted your appointment for\nthe 25th of October, 2025.',
            timestamp: 'Last Friday at 8:42 AM',
            showButtons: true,
          ),
          _DividerLine(),
          _NotificationItem(
            avatarColor: Color(0xFFC49574),
            title: 'Dr. Miki Has sent you a message',
            timestamp: 'Last Thursday at 10:42 AM',
          ),
          _DividerLine(),
          _NotificationItem(
            avatarColor: Color(0xFFB2B6C3),
            title: 'Dr. Johanes has replied to your message:',
            quote:
                '“Thanks for your message, could you please tell us\nwhat medications you’re currently on?”',
            timestamp: 'Last Wednesday at 9:42 AM',
          ),
          _DividerLine(),
          _NotificationItem(
            avatarColor: Color(0xFFBDA8A0),
            title: 'Dr. Maaya has sent a file',
            fileLabel: 'diet_plan.pdf  2mb',
            timestamp: 'Last Wednesday at 9:42 AM',
          ),
          _DividerLine(),
          _NotificationItem(
            avatarColor: Color(0xFF6E6C56),
            title: 'Dr. Santi has replied to your message:',
            quote: '“Have you been taking in a lot of sugar recently?”',
            actionLabel: 'Add to favorites',
            timestamp: 'Last Wednesday at 11:42 AM',
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final Color avatarColor;
  final String title;
  final String timestamp;
  final bool showButtons;
  final String? quote;
  final String? fileLabel;
  final String? actionLabel;

  const _NotificationItem({
    required this.avatarColor,
    required this.title,
    required this.timestamp,
    this.showButtons = false,
    this.quote,
    this.fileLabel,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 18, 10, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFF67AEFF),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 18,
                backgroundColor: avatarColor,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFD0D4CA),
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (showButtons) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _ActionButton(
                          label: 'Approve',
                          bgColor: Color(0xFFF07E54),
                          textColor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        _ActionButton(
                          label: 'Decline',
                          bgColor: Color(0xFF50525D),
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                  if (quote != null) ...[
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9CC33A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            quote!,
                            style: const TextStyle(
                              color: Color(0xFFC4C9BE),
                              fontSize: 15,
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (fileLabel != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C4730),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF647862),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.pie_chart,
                            color: Color(0xFFE46E59),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            fileLabel!,
                            style: const TextStyle(
                              color: Color(0xFFD0D4CA),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (actionLabel != null) ...[
                    const SizedBox(height: 14),
                    _ActionButton(
                      label: actionLabel!,
                      bgColor: Color(0xFFF08A4B),
                      textColor: Colors.white,
                      icon: Icons.add,
                    ),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    timestamp,
                    style: const TextStyle(
                      color: Color(0xFF7F8792),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData? icon;

  const _ActionButton({
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.2,
      color: const Color(0xFF98B53A),
    );
  }
}