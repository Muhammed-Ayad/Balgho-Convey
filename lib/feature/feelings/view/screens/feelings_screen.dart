import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/feelings/logic/providers/feelings_provider.dart';
import 'package:great_quran/feature/feelings/view/widgets/feeling_grid_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeelingsScreen extends ConsumerWidget {
  const FeelingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feelingsAsync = ref.watch(feelingsListProvider);
    final primary = context.colorScheme.primary;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "ما الذي تشعر به الآن؟",
      ),
      body: feelingsAsync.when(
        data: (feelings) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    D.sizeLarge,
                    D.sizeMedium,
                    D.sizeLarge,
                    D.sizeSmall,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(D.sizeMedium),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(D.sizeLarge),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: D.sizeMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "اختر حالتك، ودع القرآن يمنحك السكينة",
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "آيات مختارة تواسي قلبك وتبث فيك الطمأنينة والسكينة",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: context.colorScheme.onSurface
                                      .withValues(alpha: 0.65),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(D.sizeMedium),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: D.sizeMedium,
                    crossAxisSpacing: D.sizeMedium,
                    childAspectRatio: 1.05,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return FeelingGridCard(
                        feeling: feelings[index],
                      );
                    },
                    childCount: feelings.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: D.sizeXLarge),
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(
          message: "جاري تحميل مشاعر وآيات...",
        ),
        error: (err, stack) => CustomErrorWidget(
          errorMsg: "تعذر تحميل بيانات المشاعر",
          onRefresh: () => ref.invalidate(feelingsListProvider),
        ),
      ),
    );
  }
}
