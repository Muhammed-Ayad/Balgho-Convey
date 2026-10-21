import 'dart:math' as math;
import 'package:flutter/material.dart';

class QiblaCompassDial extends StatelessWidget {
  final double heading;
  final double qiblaDirection;
  final bool isAligned;

  const QiblaCompassDial({
    super.key,
    required this.heading,
    required this.qiblaDirection,
    required this.isAligned,
  });

  @override
  Widget build(BuildContext context) {
    // الزاوية المعكوسة لتدوير قرص البوصلة مع الهاتف
    final compassRotation = -heading * (math.pi / 180.0);
    // زاوية سهم القبلة بالنسبة للقرص
    final qiblaAngle = (qiblaDirection - heading) * (math.pi / 180.0);

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // قرص البوصلة الدائري الذي يدور مع الاتجاه
          Transform.rotate(
            angle: compassRotation,
            child: CustomPaint(
              size: const Size(290, 290),
              painter: CompassDialPainter(isAligned: isAligned),
            ),
          ),
          // سهم مؤشر القبلة المشير لمكة
          Transform.rotate(
            angle: qiblaAngle,
            child: QiblaPointerArrow(isAligned: isAligned),
          ),
          // حلقة المركز الإسلامية الزخرفية الذهبية
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isAligned
                      ? Colors.greenAccent.withValues(alpha: 0.4)
                      : const Color(0xFFC5A059).withValues(alpha: 0.3),
                  blurRadius: isAligned ? 24 : 12,
                  spreadRadius: isAligned ? 4 : 1,
                ),
              ],
            ),
            child: CustomPaint(
              size: const Size(130, 130),
              painter: IslamicMedallionPainter(isAligned: isAligned),
            ),
          ),
        ],
      ),
    );
  }
}

class QiblaPointerArrow extends StatelessWidget {
  final bool isAligned;

  const QiblaPointerArrow({super.key, required this.isAligned});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      height: 290,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.navigation_rounded,
                  size: 32,
                  color: isAligned ? const Color(0xFF00E676) : Colors.white,
                ),
                Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isAligned
                        ? const Color(0xFF00E676)
                        : Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
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

class CompassDialPainter extends CustomPainter {
  final bool isAligned;

  CompassDialPainter({required this.isAligned});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // خلفية القرص الدائري الشفاف
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 8, bgPaint);

    final borderPaint = Paint()
      ..color = isAligned
          ? Colors.greenAccent.withValues(alpha: 0.6)
          : Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius - 8, borderPaint);

    // رسم علامات الدرجات والاتجاهات الأساسية
    const int tickCount = 36;
    for (int i = 0; i < tickCount; i++) {
      final double angle = (i * 10) * (math.pi / 180.0);
      final bool isMajor = (i % 9 == 0); // 0, 90, 180, 270
      final bool isSemiMajor = (i % 3 == 0);

      final double tickLength = isMajor ? 14 : (isSemiMajor ? 9 : 5);
      final double startR = radius - 10 - tickLength;
      final double endR = radius - 10;

      final start = Offset(
        center.dx + startR * math.sin(angle),
        center.dy - startR * math.cos(angle),
      );
      final end = Offset(
        center.dx + endR * math.sin(angle),
        center.dy - endR * math.cos(angle),
      );

      final tickPaint = Paint()
        ..color = isMajor
            ? Colors.white
            : Colors.white.withValues(alpha: isSemiMajor ? 0.7 : 0.3)
        ..strokeWidth = isMajor ? 2.5 : (isSemiMajor ? 1.5 : 1.0)
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(start, end, tickPaint);
    }

    // كتابة الأحرف الأساسية (N, E, S, W)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    const labels = [
      {'text': 'N', 'angle': 0.0, 'color': Color(0xFFEF5350)},
      {'text': 'NE', 'angle': 45.0, 'color': Colors.cyanAccent},
      {'text': 'E', 'angle': 90.0, 'color': Colors.cyanAccent},
      {'text': 'SE', 'angle': 135.0, 'color': Colors.cyanAccent},
      {'text': 'S', 'angle': 180.0, 'color': Colors.cyanAccent},
      {'text': 'SW', 'angle': 225.0, 'color': Colors.cyanAccent},
      {'text': 'W', 'angle': 270.0, 'color': Colors.cyanAccent},
      {'text': 'NW', 'angle': 315.0, 'color': Colors.cyanAccent},
    ];

    for (final item in labels) {
      final angle = (item['angle'] as double) * (math.pi / 180.0);
      final text = item['text'] as String;
      final color = item['color'] as Color;

      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: text.length == 1 ? 13 : 9,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();

      final double r = radius - 32;
      final x = center.dx + r * math.sin(angle) - (textPainter.width / 2);
      final y = center.dy - r * math.cos(angle) - (textPainter.height / 2);

      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CompassDialPainter oldDelegate) {
    return oldDelegate.isAligned != isAligned;
  }
}

class IslamicMedallionPainter extends CustomPainter {
  final bool isAligned;

  IslamicMedallionPainter({required this.isAligned});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // الحلقة الخارجية الذهبية
    final goldBase = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, goldBase);

    // الحلقة الداخلية المزخرفة الداكنة
    final innerDark = Paint()
      ..color = const Color(0xFF1E332E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 8, innerDark);

    // تطريز هندسي إسلامي دائري
    final goldLine = Paint()
      ..color = const Color(0xFFF7E28B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawCircle(center, radius - 4, goldLine);
    canvas.drawCircle(center, radius - 16, goldLine);

    // رسم نجمة إسلامية أو زخرفة أندلسية محيطية
    const int petals = 16;
    for (int i = 0; i < petals; i++) {
      final double a = (i * (360 / petals)) * (math.pi / 180.0);
      final p1 = Offset(
        center.dx + (radius - 8) * math.sin(a),
        center.dy - (radius - 8) * math.cos(a),
      );
      final p2 = Offset(
        center.dx + (radius - 16) * math.sin(a + 0.15),
        center.dy - (radius - 16) * math.cos(a + 0.15),
      );
      canvas.drawLine(p1, p2, goldLine);
    }

    // قلب الحلقة المفرغة الشفافة
    final centerHole = Paint()
      ..color = isAligned ? const Color(0xFF003D32) : const Color(0xFF002924)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 24, centerHole);

    // إطار الحلقة الداخلية
    final centerBorder = Paint()
      ..color = isAligned ? Colors.greenAccent : const Color(0xFFD4AF37)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawCircle(center, radius - 24, centerBorder);
  }

  @override
  bool shouldRepaint(covariant IslamicMedallionPainter oldDelegate) {
    return oldDelegate.isAligned != isAligned;
  }
}
