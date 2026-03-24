import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'medical_records_screen.dart';
import 'customer_support.dart';
import 'logging_screen.dart';
import 'app_theme.dart';
import 'app_shell.dart';

class GlucoLogHomeScreen extends StatelessWidget {
  GlucoLogHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'GlucoLog',
      currentIndex: 0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 110),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildCurrentGlucoseCard(),
            const SizedBox(height: 14),
            _buildStatsGrid(),
            const SizedBox(height: 14),
            _buildChartCard(),
            const SizedBox(height: 16),
            _buildLoggingBanner(context),
            const SizedBox(height: 16),
            _buildShortcutLayout(context),
            const SizedBox(height: 16),
            _buildMedicalRecordsBanner(context),
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
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.grey, size: 30),
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
                  color: AppTheme.textDark,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Ready to check?",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.notifications, size: 24, color: AppTheme.textDark),
      ],
    );
  }

  Widget _buildCurrentGlucoseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF3E5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.darkGreen.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: const [
          Text(
            "Current Glucose levels",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "115",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
              height: 1,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "mg/dL",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Within target range",
            style: TextStyle(
              fontSize: 13,
              color: Colors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.38,
      children: const [
        _FoodNavCard(),
        _GlucoseNavCard(),
        _InsulinNavCard(),
        _MiniStatCard(
          title: "Current Glucose Level",
          value: "In-range",
          unit: "",
        ),
      ],
    );
  }

  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      height: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF3E5),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ChartPainter(),
        child: const Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "Weekly Trend",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoggingBanner(BuildContext context) {
    return _HoverScaleCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoggingScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Logging /\nTracking",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.05,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Last logged : 23/10/2025 4:38 PM",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: 54,
              height: 54,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _Bar(height: 18),
                  _Bar(height: 28),
                  _Bar(height: 38),
                  _Bar(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutLayout(BuildContext context) {
    return SizedBox(
      height: 245,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 11,
            child: _HoverScaleCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: AppTheme.softGreenCard,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "Timeline/\nHistory",
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.05,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Icon(Icons.list_alt_rounded, color: Colors.blue, size: 28),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _TimelineBar(height: 130),
                        _TimelineBar(height: 88),
                        _TimelineBar(height: 58),
                        _TimelineBar(height: 112),
                        _TimelineBar(height: 150),
                        _TimelineBar(height: 126),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 10,
            child: Column(
              children: [
                Expanded(
                  child: _HoverScaleCard(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(
                        color: AppTheme.graphGreen,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Graph &\nChart",
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.05,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 42,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                10,
                                (index) => Container(
                                  width: 2,
                                  height: 10.0 + (index % 5) * 6,
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? const Color(0xFFA3F2A5)
                                        : const Color(0xFFF6B7A9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: _HoverScaleCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerSupportScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                      decoration: BoxDecoration(
                        color: AppTheme.supportYellow,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer\nSupport",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Icon(
                              Icons.support_agent,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalRecordsBanner(BuildContext context) {
    return _HoverScaleCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicalRecordsScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.cream,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppTheme.darkGreen.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: const [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Medical Records",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "View and manage your medical documents,\nreports, and uploaded records.",
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 14),
            Icon(
              Icons.folder_open_rounded,
              size: 42,
              color: AppTheme.darkGreen,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                TextSpan(
                  text: unit.isNotEmpty ? " $unit" : "",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlucoseNavCard extends StatelessWidget {
  const _GlucoseNavCard();

  @override
  Widget build(BuildContext context) {
    return _HoverScaleCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoggingScreen()),
        );
      },
      child: const _MiniStatCard(
        title: "Log Glucose Level",
        value: "115",
        unit: "mg/dL",
      ),
    );
  }
}

class _InsulinNavCard extends StatelessWidget {
  const _InsulinNavCard();

  @override
  Widget build(BuildContext context) {
    return _HoverScaleCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoggingScreen()),
        );
      },
      child: const _MiniStatCard(
        title: "Log Insulin Level",
        value: "8",
        unit: "u/mL",
      ),
    );
  }
}

class _FoodNavCard extends StatelessWidget {
  const _FoodNavCard();

  @override
  Widget build(BuildContext context) {
    return _HoverScaleCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoggingScreen()),
        );
      },
      child: const _MiniStatCard(
        title: "Log Food Intake",
        value: "1800",
        unit: "Cal/day",
      ),
    );
  }
}

class _HoverScaleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HoverScaleCard({
    required this.child,
    required this.onTap,
  });

  @override
  State<_HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<_HoverScaleCard> {
  bool _hovering = false;
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    final scale = _pressing
        ? 0.98
        : _hovering
            ? 1.02
            : 1.0;

    final translateY = _hovering ? -3.0 : 0.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) {
        setState(() {
          _hovering = false;
          _pressing = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressing = true),
        onTapUp: (_) => setState(() => _pressing = false),
        onTapCancel: () => setState(() => _pressing = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, translateY)
            ..scale(scale),
          child: widget.child,
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;

  const _Bar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF8DDB4D),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _TimelineBar extends StatelessWidget {
  final double height;

  const _TimelineBar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF53D53F),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE7A974).withOpacity(0.45)
      ..strokeWidth = 1.1;

    final linePaint = Paint()
      ..color = const Color(0xFF9AD94A)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(16, y), Offset(size.width - 16, y), gridPaint);
    }

    final path = Path();
    path.moveTo(25, size.height * 0.78);
    path.cubicTo(70, size.height * 0.80, 95, size.height * 0.74, 130, size.height * 0.60);
    path.cubicTo(160, size.height * 0.48, 190, size.height * 0.38, 225, size.height * 0.42);
    path.cubicTo(250, size.height * 0.44, 270, size.height * 0.28, 300, size.height * 0.30);
    path.cubicTo(320, size.height * 0.32, 340, size.height * 0.48, size.width - 26, size.height * 0.22);

    canvas.drawPath(path, linePaint);

    final pointPaint = Paint()..color = Colors.white;
    final pointBorder = Paint()
      ..color = const Color(0xFF9AD94A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final point = Offset(size.width - 70, size.height * 0.30);
    canvas.drawCircle(point, 5, pointPaint);
    canvas.drawCircle(point, 5, pointBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}