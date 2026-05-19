import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_shell.dart';

class AiAssistedChatScreen extends StatefulWidget {
  const AiAssistedChatScreen({super.key});

  @override
  State<AiAssistedChatScreen> createState() => _AiAssistedChatScreenState();
}

class _AiAssistedChatScreenState extends State<AiAssistedChatScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> messages = [
    const _ChatMessage(
      text:
          "Hi, I’m GlucoBot. I can help answer general questions about using GlucoLog. Choose a topic to begin.",
      isBot: true,
    ),
  ];

  final List<_ChatOption> options = const [
    _ChatOption(
      title: 'Blood glucose',
      subtitle: 'Target ranges and reading tips',
      answer:
          'General glucose targets can vary by person. Many adults with diabetes aim for about 80–130 mg/dL before meals and below 180 mg/dL around 1–2 hours after meals, but your personal target should come from your doctor. If your reading is very low, very high, or you feel unwell, contact a healthcare professional.',
    ),
    _ChatOption(
      title: 'Insulin logging',
      subtitle: 'How to record insulin safely',
      answer:
          'You can log insulin by entering the amount prescribed by your healthcare provider. GlucoLog can help you record the dose and time, but it should not decide your insulin amount. Never change your insulin dose without advice from your doctor or diabetes educator.',
    ),
    _ChatOption(
      title: 'Recommended levels',
      subtitle: 'Glucose and insulin guidance',
      answer:
          'For glucose, common general targets are about 80–130 mg/dL before meals and below 180 mg/dL after meals. Insulin does not have one universal “recommended level” because dose depends on your prescription, food intake, glucose reading, activity, and insulin type. Follow your care plan and ask your doctor for your personal insulin range.',
    ),
    _ChatOption(
      title: 'Medication reminders',
      subtitle: 'Alerts and notification help',
      answer:
          'Medication reminders can help you remember when to check or record important health information. If reminders are not appearing, check your notification settings and make sure GlucoLog notifications are allowed.',
    ),
    _ChatOption(
      title: 'Share data',
      subtitle: 'Reports for your doctor',
      answer:
          'You can use your saved glucose, insulin, and food intake records to discuss your progress with your doctor. Make sure the information is accurate before sharing it with a healthcare professional.',
    ),
    _ChatOption(
      title: 'App support',
      subtitle: 'Login, account, and data issues',
      answer:
          'For app issues, check that you are logged in, connected to the internet, and using the correct account. If your data is not loading, try restarting the app or checking your Firebase connection.',
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToAnswerEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final target = _scrollController.position.maxScrollExtent - 120;
      final safeTarget = target < 0 ? 0.0 : target;

      _scrollController.animateTo(
        safeTarget,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  void _selectOption(_ChatOption option) {
    setState(() {
      messages.add(_ChatMessage(text: option.title, isBot: false));

      messages.add(_ChatMessage(text: option.answer, isBot: true));
    });

    _scrollToAnswerEnd();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'GlucoLog',
      currentIndex: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 22),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.cream.withOpacity(0.55),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.darkGreen.withOpacity(0.25),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF2F6F24),
                    child: Icon(
                      Icons.smart_toy_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'GlucoBot',
                      style: TextStyle(
                        color: Color(0xFF1F5E1F),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...messages.map(
                        (message) => _ChatBubble(message: message),
                      ),

                      const SizedBox(height: 6),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 230,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFF6C7896).withOpacity(0.25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Choose a topic',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF6C7896),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...options.map(
                                (option) => _SmallTopicButton(
                                  title: option.title,
                                  subtitle: option.subtitle,
                                  onTap: () {
                                    _selectOption(option);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const _PrivacyNotice(),
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
}

class _ChatMessage {
  final String text;
  final bool isBot;

  const _ChatMessage({required this.text, required this.isBot});
}

class _ChatOption {
  final String title;
  final String subtitle;
  final String answer;

  const _ChatOption({
    required this.title,
    required this.subtitle,
    required this.answer,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment = message.isBot
        ? Alignment.centerLeft
        : Alignment.centerRight;

    final bgColor = message.isBot
        ? const Color(0xFFEAF5DD)
        : const Color(0xFFC7E8FF);

    final textColor = message.isBot
        ? const Color(0xFF4F5E75)
        : const Color(0xFF2F4D68);

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        constraints: const BoxConstraints(maxWidth: 255),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(17),
            topRight: const Radius.circular(17),
            bottomLeft: Radius.circular(message.isBot ? 4 : 17),
            bottomRight: Radius.circular(message.isBot ? 17 : 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            height: 1.35,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SmallTopicButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SmallTopicButton({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F7),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: const Color(0xFF6C7896).withOpacity(0.22),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF6C7896),
                size: 15,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF6C7896),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF8B95AD),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF6C7896),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyNotice extends StatelessWidget {
  const _PrivacyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0B94F)),
      ),
      child: const Text(
        'Privacy notice: Your AI-assisted chat may be reviewed to improve the chat experience. Do not enter emergency, urgent, or highly sensitive medical information here. This chat gives general app information only and does not replace medical advice.',
        style: TextStyle(
          color: Color(0xFF6C7896),
          fontSize: 10,
          height: 1.3,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
