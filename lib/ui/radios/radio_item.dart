import 'package:flutter/material.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';

class RadioItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const RadioItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: D.sizeXSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(D.sizeLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(D.sizeLarge),
          ),
          height: context.heightR(0.1),
          child: Padding(
            padding: const EdgeInsets.all(D.sizeSmall),
            child: Row(
              children: [
                Icon(
                  Icons.radio_outlined,
                  color: AppColors.primary,
                  size: D.size3XLarge,
                ),
                const SizedBox(width: D.sizeSmall),
                Flexible(
                  child: Text(
                    title,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
