import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/prophet/logic/models/prophet_topic.dart';
import 'package:great_quran/feature/prophet/view/widgets/prophet_detail_widgets.dart';

class ProphetDetailScreen extends StatelessWidget {
  final ProphetTopic topic;

  const ProphetDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar(
        title: topic.title,
      ),
      body: ListView(
        padding: const EdgeInsets.all(D.sizeMedium),
        children: [
          ProphetDetailHeader(topic: topic),
          ProphetKeyPointsCard(points: topic.keyPoints),
          ProphetContentSection(content: topic.content),
          ProphetVersesAndHadithsSection(
            verses: topic.quranVerses,
            hadiths: topic.hadiths,
          ),
          ProphetSourcesCard(sources: topic.sources),
          const SizedBox(height: D.sizeXXLarge),
        ],
      ),
    );
  }
}
