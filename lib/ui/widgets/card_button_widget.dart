import 'package:flutter/material.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';

class CardButtonWidget extends StatelessWidget {
  const CardButtonWidget(
      {super.key,
      required this.onTap,
      required this.title,
      required this.icon});
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(
          D.sizeMedium,
        ),
        child: Card(
          elevation: D.sizeXXSmall,
          color: AppColors.greyShade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              D.sizeXLarge,
            ),
          ),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: context.textTheme.headlineLarge,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(
                    icon,
                    color: context.colorScheme.primary,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
