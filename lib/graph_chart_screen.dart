import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'app_theme.dart';
import 'logging_screen.dart';

enum GraphRange { day, week, month, year, allTime }

class GraphChartScreen extends StatefulWidget {
  const GraphChartScreen({super.key});

  @override
  State<GraphChartScreen> createState() => _GraphChartScreenState();
}

class _GraphChartScreenState extends State<GraphChartScreen> {
  GraphRange selectedRange = GraphRange.week;

  DateTime? _parseTime(dynamic rawTime) {
    if (rawTime is Timestamp) {
      return rawTime.toDate();
    } else if (rawTime is String) {
      return DateTime.tryParse(rawTime);
    }
    return null;
  }

  String _rangeLabel() {
    final now = DateTime.now();

    if (selectedRange == GraphRange.day) {
      return '${now.day} ${_monthName(now.month)}';
    }

    if (selectedRange == GraphRange.week) {
      final start = now.subtract(const Duration(days: 7));
      return '${start.day} ${_monthName(start.month)} – ${now.day} ${_monthName(now.month)}';
    }

    if (selectedRange == GraphRange.month) {
      return '${_monthName(now.month)} ${now.year}';
    }

    if (selectedRange == GraphRange.year) {
      return '${now.year}';
    }

    return 'All Time';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  DateTime? _startDateForRange() {
    final now = DateTime.now();

    switch (selectedRange) {
      case GraphRange.day:
        return DateTime(now.year, now.month, now.day);
      case GraphRange.week:
        return now.subtract(const Duration(days: 7));
      case GraphRange.month:
        return DateTime(now.year, now.month, 1);
      case GraphRange.year:
        return DateTime(now.year, 1, 1);
      case GraphRange.allTime:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('entries')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];
        final startDate = _startDateForRange();

        final points = docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final glucose = (data['glucose'] as num?)?.toDouble();
              final insulin = (data['insulin'] as num?)?.toDouble();
              final food = (data['foodIntake'] as num?)?.toDouble();
              final time = _parseTime(data['time']);

              if (time == null) return null;
              if (startDate != null && time.isBefore(startDate)) return null;

              return _GraphEntry(
                time: time,
                glucose: glucose,
                insulin: insulin,
                food: food,
              );
            })
            .whereType<_GraphEntry>()
            .toList();

        final glucosePoints = points
            .where((entry) => entry.glucose != null)
            .map(
              (entry) => _GraphPoint(time: entry.time, value: entry.glucose!),
            )
            .toList();

        final totalInsulin = points.fold<double>(
          0,
          (total, entry) => total + (entry.insulin ?? 0),
        );

        final mealCount = points.where((entry) {
          final food = entry.food ?? 0;
          return food > 0;
        }).length;

        return AppShell(
          title: 'GlucoLog',
          currentIndex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(14, 20, 14, 28),
                  decoration: BoxDecoration(
                    color: AppTheme.cream,
                    borderRadius: BorderRadius.circular(34),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCDEEB3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'GLUCOSE TRENDS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4E0DF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            _RangeButton(
                              label: 'Day',
                              selected: selectedRange == GraphRange.day,
                              onTap: () {
                                setState(() {
                                  selectedRange = GraphRange.day;
                                });
                              },
                            ),
                            _RangeButton(
                              label: 'Week',
                              selected: selectedRange == GraphRange.week,
                              onTap: () {
                                setState(() {
                                  selectedRange = GraphRange.week;
                                });
                              },
                            ),
                            _RangeButton(
                              label: 'Month',
                              selected: selectedRange == GraphRange.month,
                              onTap: () {
                                setState(() {
                                  selectedRange = GraphRange.month;
                                });
                              },
                            ),
                            _RangeButton(
                              label: 'Year',
                              selected: selectedRange == GraphRange.year,
                              onTap: () {
                                setState(() {
                                  selectedRange = GraphRange.year;
                                });
                              },
                            ),
                            _RangeButton(
                              label: 'All Time',
                              selected: selectedRange == GraphRange.allTime,
                              onTap: () {
                                setState(() {
                                  selectedRange = GraphRange.allTime;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.black,
                            size: 26,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _rangeLabel(),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        height: 170,
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 4,
                          top: 4,
                          bottom: 4,
                        ),
                        child: glucosePoints.isEmpty
                            ? const Center(
                                child: Text(
                                  'No glucose data for this period',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            : CustomPaint(
                                painter: _TrendChartPainter(
                                  points: glucosePoints,
                                  selectedRange: selectedRange,
                                ),
                              ),
                      ),

                      const SizedBox(height: 26),

                      Row(
                        children: [
                          Expanded(
                            child: _InsightCard(
                              title: 'Insulin Usage',
                              color: const Color(0xFFFFC05B),
                              child: Center(
                                child: Container(
                                  width: 78,
                                  height: 78,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${totalInsulin.toStringAsFixed(0)}\nUnits',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _InsightCard(
                              title: 'Meal patterns',
                              color: const Color(0xFFFF9E6D),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 62,
                                    child: CustomPaint(
                                      painter: _MiniWavePainter(),
                                      child: Container(),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '$mealCount meals',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoggingScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 34,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC8D96B),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 7,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Log entry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GraphEntry {
  final DateTime time;
  final double? glucose;
  final double? insulin;
  final double? food;

  const _GraphEntry({
    required this.time,
    required this.glucose,
    required this.insulin,
    required this.food,
  });
}

class _GraphPoint {
  final DateTime time;
  final double value;

  const _GraphPoint({required this.time, required this.value});
}

class _RangeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RangeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;

  const _InsightCard({
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<_GraphPoint> points;
  final GraphRange selectedRange;

  const _TrendChartPainter({required this.points, required this.selectedRange});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.black.withOpacity(0.22)
      ..strokeWidth = 1;

    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const leftPadding = 34.0;
    const rightPadding = 10.0;
    const topPadding = 10.0;
    const bottomPadding = 28.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final values = points.map((point) => point.value).toList();

    double minValue = values.reduce((a, b) => a < b ? a : b);
    double maxValue = values.reduce((a, b) => a > b ? a : b);

    minValue = (minValue - 20).clamp(0, double.infinity);
    maxValue = maxValue + 20;

    if (minValue == maxValue) {
      minValue = 0;
      maxValue = maxValue + 50;
    }

    for (int i = 0; i <= 5; i++) {
      final y = topPadding + chartHeight * i / 5;
      final labelValue = maxValue - ((maxValue - minValue) * i / 5);

      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: labelValue.toStringAsFixed(0),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(leftPadding - textPainter.width - 5, y - 6),
      );
    }

    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, topPadding + chartHeight),
      axisPaint,
    );

    canvas.drawLine(
      Offset(leftPadding, topPadding + chartHeight),
      Offset(size.width - rightPadding, topPadding + chartHeight),
      axisPaint,
    );

    double xForIndex(int index) {
      if (points.length == 1) return leftPadding + chartWidth / 2;
      return leftPadding + chartWidth * index / (points.length - 1);
    }

    double yForValue(double value) {
      final normalized = (value - minValue) / (maxValue - minValue);
      return topPadding + chartHeight * (1 - normalized);
    }

    final path = Path();

    for (int i = 0; i < points.length; i++) {
      final x = xForIndex(i);
      final y = yForValue(points[i].value);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    final pointPaint = Paint()..color = Colors.white;
    final pointBorder = Paint()
      ..color = const Color(0xFF8DDB4D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < points.length; i++) {
      final point = Offset(xForIndex(i), yForValue(points[i].value));
      canvas.drawCircle(point, 4.5, pointPaint);
      canvas.drawCircle(point, 4.5, pointBorder);
    }

    final labels = _labelsForRange();

    for (int i = 0; i < labels.length; i++) {
      final x = leftPadding + chartWidth * i / (labels.length - 1);

      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, topPadding + chartHeight + 8),
      );
    }
  }

  List<String> _labelsForRange() {
    switch (selectedRange) {
      case GraphRange.day:
        return ['Morning', 'Noon', 'Night'];
      case GraphRange.week:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case GraphRange.month:
        return ['W1', 'W2', 'W3', 'W4'];
      case GraphRange.year:
        return ['Jan', 'Apr', 'Jul', 'Oct'];
      case GraphRange.allTime:
        return ['Start', 'Middle', 'Now'];
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.selectedRange != selectedRange;
  }
}

class _MiniWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.70);
    path.cubicTo(
      size.width * 0.10,
      size.height * 0.10,
      size.width * 0.20,
      size.height * 0.90,
      size.width * 0.30,
      size.height * 0.30,
    );
    path.cubicTo(
      size.width * 0.40,
      size.height * 0.00,
      size.width * 0.45,
      size.height * 0.85,
      size.width * 0.55,
      size.height * 0.70,
    );
    path.cubicTo(
      size.width * 0.65,
      size.height * 0.55,
      size.width * 0.70,
      size.height * 0.85,
      size.width * 0.78,
      size.height * 0.20,
    );
    path.cubicTo(
      size.width * 0.86,
      size.height * 0.00,
      size.width * 0.90,
      size.height * 0.50,
      size.width,
      size.height * 0.18,
    );

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = const Color(0xFFFFE86B);
    canvas.drawCircle(
      Offset(size.width * 0.80, size.height * 0.08),
      4,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniWavePainter oldDelegate) => false;
}
