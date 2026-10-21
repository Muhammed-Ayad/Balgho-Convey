import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/core/widgets/error_widget.dart';
import 'package:great_quran/core/widgets/loading_widget.dart';
import 'package:great_quran/feature/azkar/logic/providers/azkar_category_provider.dart';
import 'package:great_quran/feature/azkar/view/widgets/zekr_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AzkarCategoryScreen extends ConsumerWidget {
  const AzkarCategoryScreen({super.key, required this.azkar});
  final String azkar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(azkarCategoryProvider(azkar));

    return Scaffold(
      appBar: CustomAppBar(
        title: azkar,
        actions: [
          IconButton(
            tooltip: "إعادة تعيين الأذكار",
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(azkarCategoryProvider(azkar).notifier).reset();
            },
          ),
        ],
      ),
      body: state.when(
        loading: () => const LoadingWidget(),
        error: (err, stack) => CustomErrorWidget(
          errorMsg: err.toString(),
          onRefresh: () {
            ref.read(azkarCategoryProvider(azkar).notifier).loadCategoryAzkar();
          },
        ),
        data: (categoryState) {
          if (categoryState.isAllCompleted) {
            return AzkarCompletedView(category: azkar);
          }

          final activeItems = categoryState.activeItems;

          return Column(
            children: [
              AzkarProgressHeader(
                completed: categoryState.completedItems,
                total: categoryState.totalItems,
                progress: categoryState.progress,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: D.sizeXXLarge),
                  itemCount: activeItems.length,
                  itemBuilder: (context, index) {
                    final item = activeItems[index];
                    return ZekrCard(
                      key: ValueKey(item.id),
                      item: item,
                      category: azkar,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AzkarProgressHeader extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;

  const AzkarProgressHeader({
    super.key,
    required this.completed,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.all(D.sizeMedium),
      padding: const EdgeInsets.symmetric(
        horizontal: D.sizeLarge,
        vertical: D.sizeMedium,
      ),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(D.sizeMedium),
        border: Border.all(
          color: primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "تقدّم القراءة",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: primary,
                ),
              ),
              Text(
                "أنجزت $completed من $total ذكر",
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: D.sizeSmall),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: primary.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
        ],
      ),
    );
  }
}

class AzkarCompletedView extends ConsumerWidget {
  final String category;

  const AzkarCompletedView({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(D.sizeXXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(D.sizeXLarge),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 72,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: D.sizeLarge),
            Text(
              "تقبّل الله طاعتكم!",
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: D.sizeSmall),
            Text(
              "أتممت قراءة جميع أذكار هذا القسم بنجاح.",
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: D.sizeXXLarge),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(azkarCategoryProvider(category).notifier).reset();
              },
              icon: const Icon(Icons.replay_rounded, color: Colors.white),
              label: const Text(
                "إعادة قراءة الأذكار",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: D.sizeXXLarge,
                  vertical: D.sizeMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(D.sizeMedium),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
