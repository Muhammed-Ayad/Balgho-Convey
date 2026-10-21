import 'package:flutter/material.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class QiblaCalibrationDialog extends StatelessWidget {
  final double? accuracy;

  const QiblaCalibrationDialog({
    super.key,
    this.accuracy,
  });

  static void show(BuildContext context, {double? accuracy}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => QiblaCalibrationDialog(accuracy: accuracy),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2625),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "تحسين الدقة",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: D.sizeLarge),
            const InfinityMotionGraphic(),
            const SizedBox(height: D.sizeLarge),
            Text(
              "أبقِ جهازك بعيداً عن المعادن (مجال مغناطيسي)،\nقم بتقويم البوصلة عن طريق تحريك هاتفك على شكل 8.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 14,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: D.sizeLarge),
            CustomPaint(
              size: const Size(double.infinity, 1),
              painter: DottedLinePainter(),
            ),
            const SizedBox(height: D.sizeMedium),
            const CalibrationSensorStatusWidget(),
            const SizedBox(height: D.sizeLarge),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "إغلاق",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfinityMotionGraphic extends StatelessWidget {
  const InfinityMotionGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 90,
      child: CustomPaint(
        painter: InfinityFigure8Painter(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 14,
              top: 14,
              child: Transform.rotate(
                angle: -0.4,
                child: const PhoneIconWidget(),
              ),
            ),
            Positioned(
              right: 14,
              top: 14,
              child: Transform.rotate(
                angle: 0.4,
                child: const PhoneIconWidget(),
              ),
            ),
            const Center(
              child: PhoneIconWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneIconWidget extends StatelessWidget {
  const PhoneIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF2A3635),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white70, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal.shade300,
            ),
            child: const Icon(Icons.explore_rounded,
                size: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CalibrationSensorStatusWidget extends StatelessWidget {
  const CalibrationSensorStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "دقة بوصلة الهاتف: ",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              "متوسطة",
              style: TextStyle(
                color: Colors.amber.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "شدة المجال المغناطيسي: ",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              "42 µT",
              style: TextStyle(
                color: Colors.teal.shade300,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1;

    const double dashWidth = 4;
    const double dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class InfinityFigure8Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.5, h * 0.5);
    path.cubicTo(w * 0.25, h * 0.0, 0, h * 0.2, 0, h * 0.5);
    path.cubicTo(0, h * 0.8, w * 0.25, h * 1.0, w * 0.5, h * 0.5);
    path.cubicTo(w * 0.75, 0, w, h * 0.2, w, h * 0.5);
    path.cubicTo(w, h * 0.8, w * 0.75, h * 1.0, w * 0.5, h * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
