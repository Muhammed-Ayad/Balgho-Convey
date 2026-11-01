import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/prophet/logic/providers/prophet_provider.dart';
import 'package:great_quran/feature/prophet/view/widgets/prophet_header_banner.dart';
import 'package:great_quran/feature/prophet/view/widgets/prophet_search_and_chips.dart';
import 'package:great_quran/feature/prophet/view/widgets/prophet_topic_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProphetScreen extends ConsumerWidget {
  const ProphetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(filteredProphetTopicsProvider);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: const CustomAppBar(
        title: "اعرف نبيك ﷺ",
      ),
      body: ListView(
        children: [
          const ProphetHeaderBanner(),
          const SizedBox(height: D.sizeSmall),
          const ProphetSearchField(),
          const SizedBox(height: D.sizeSmall),
          const ProphetCategoryChips(),
          const SizedBox(height: D.sizeSmall),
          if (topics.isEmpty)
            Padding(
              padding: const EdgeInsets.all(D.sizeXXLarge),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: D.sizeSmall),
                  Text(
                    "لم يتم العثور على نتائج مطابقة للبحث",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            ...topics.map((t) => ProphetTopicCard(topic: t)),
          const SizedBox(height: D.sizeXXLarge),
        ],
      ),
    );
  }
}
