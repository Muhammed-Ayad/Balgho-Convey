import 'package:flutter/material.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/azkar/logic/data/azkar_by_category.dart';
import 'package:great_quran/feature/azkar/view/widgets/zekr_card.dart';

class AzkarCategoryScreen extends StatefulWidget {
  const AzkarCategoryScreen({super.key, required this.azkar});
  final String azkar;

  @override
  State<AzkarCategoryScreen> createState() => _AzkarCategoryScreenState();
}

class _AzkarCategoryScreenState extends State<AzkarCategoryScreen> {
  final AzkarByCategory azkarByCategory = AzkarByCategory();

  @override
  void initState() {
    super.initState();
    azkarByCategory.getAzkarByCategory(widget.azkar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.azkar,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: azkarByCategory.azkarList.map((azkar) {
            return ZekrCard(
              azkar: azkar,
            );
          }).toList(),
        ),
      ),
    );
  }
}
