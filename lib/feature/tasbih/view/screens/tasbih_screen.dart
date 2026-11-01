import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/tasbih/logic/providers/tasbih_provider.dart';
import 'package:great_quran/feature/tasbih/view/widgets/tasbih_counter_widget.dart';
import 'package:great_quran/feature/tasbih/view/widgets/tasbih_target_chips.dart';
import 'package:great_quran/feature/tasbih/view/widgets/tasbih_zekr_selector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasbihProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: "المسبحة الإلكترونية",
        actions: [
          state.when(
            data: (s) => IconButton(
              tooltip: s.vibrateEnabled ? "كتم الاهتزاز" : "تشغيل الاهتزاز",
              icon: Icon(
                s.vibrateEnabled
                    ? Icons.vibration_rounded
                    : Icons.mobile_off_rounded,
              ),
              onPressed: () {
                ref.read(tasbihProvider.notifier).toggleVibration();
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const TasbihResetButtonWidget(),
        ],
      ),
      body: state.when(
        loading: () => const LoadingWidget(),
        error: (err, stack) => CustomErrorWidget(
          errorMsg: err.toString(),
        ),
        data: (tasbihState) {
          final currentItem = tasbihState.currentItem;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: D.sizeMedium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TasbihActiveZekrCardWidget(
                    item: currentItem,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (ctx) => TasbihZekrListModal(
                          items: tasbihState.items,
                          activeIndex: tasbihState.activeIndex,
                        ),
                      );
                    },
                  ),
                  TasbihCounterWidget(item: currentItem),
                  Column(
                    children: [
                      TasbihTargetChipsWidget(
                          currentTarget: currentItem.target),
                      const SizedBox(height: D.sizeSmall),
                      Text(
                        "اضغط داخل الدائرة لاحتساب التسبيح",
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
