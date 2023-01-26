import 'package:flutter/material.dart';
import 'package:great_quran/data/local/json/azkar_by_category.dart';
import 'package:great_quran/ui/azkar/zekr_card.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class AzkarCategoryScreen extends StatefulWidget {
  const AzkarCategoryScreen({Key? key, required this.azkar}) : super(key: key);
  final String azkar;

  @override
  State<AzkarCategoryScreen> createState() => _AzkarCategoryScreenState();
}

class _AzkarCategoryScreenState extends State<AzkarCategoryScreen> {
  AzkarByCategory azkarByCategory = AzkarByCategory();

  @override
  void initState() {
    azkarByCategory.getAzkarByCategory(widget.azkar);
    super.initState();
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
