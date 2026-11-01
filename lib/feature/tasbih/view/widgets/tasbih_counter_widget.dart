import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/feature/tasbih/logic/models/tasbih_item.dart';
import 'package:great_quran/feature/tasbih/logic/providers/tasbih_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasbihCounterWidget extends ConsumerStatefulWidget {
  final TasbihItem item;

  const TasbihCounterWidget({
    super.key,
    required this.item,
  });

  @override
  ConsumerState<TasbihCounterWidget> createState() =>
      _TasbihCounterWidgetState();
}

class _TasbihCounterWidgetState extends ConsumerState<TasbihCounterWidget>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    ref.read(tasbihProvider.notifier).increment();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final item = widget.item;
    final progress =
        item.target > 0 ? (item.count % item.target) / item.target : 0.0;

    return Center(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: primary.withValues(alpha: 0.2),
                width: 4,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (item.target > 0)
                  SizedBox(
                    width: 228,
                    height: 228,
                    child: CircularProgressIndicator(
                      value: progress == 0 && item.count > 0 ? 1.0 : progress,
                      strokeWidth: 6,
                      backgroundColor: primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.count.toString(),
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                        color: primary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    if (item.target > 0)
                      Text(
                        "الهدف: ${item.target}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      "المجموع: ${item.totalCount}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TasbihResetButtonWidget extends ConsumerWidget {
  const TasbihResetButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: "تصفير العداد",
      icon: const Icon(Icons.refresh_rounded, size: 28),
      onPressed: () {
        ref.read(tasbihProvider.notifier).resetCurrent();
      },
    );
  }
}
