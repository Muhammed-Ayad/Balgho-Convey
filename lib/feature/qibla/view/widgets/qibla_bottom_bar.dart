import 'package:flutter/material.dart';
import 'package:great_quran/feature/qibla/view/widgets/qibla_calibration_dialog.dart';

class QiblaBottomBar extends StatelessWidget {
  final bool isCalibrated;

  const QiblaBottomBar({
    super.key,
    this.isCalibrated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => QiblaCalibrationDialog.show(context),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                "معايرة",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                isCalibrated
                    ? "دقة البوصلة ممتازة"
                    : "يحتاج مستشعر الهاتف إلى المعايرة",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCalibrated
                      ? Colors.greenAccent
                      : const Color(0xFFFF5252),
                  boxShadow: [
                    BoxShadow(
                      color: isCalibrated
                          ? Colors.greenAccent.withValues(alpha: 0.5)
                          : const Color(0xFFFF5252).withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
