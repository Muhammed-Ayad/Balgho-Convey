import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:great_quran/core/helpers/boxes.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/theme/dimensions.dart';

class CardViewWidget extends StatelessWidget {
  const CardViewWidget(this.title, this.route, this.image, {super.key});
  final String title;
  final String route;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: D.sizeSmall, horizontal: D.sizeMedium),
      child: InkWell(
        onTap: () {
          context.push(route);
        },
        child: Column(
          children: [
            Flexible(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(D.sizeLarge),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      D.sizeSmall,
                    ),
                    color: context.colorScheme.secondary),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            B.verticalSizedBoxSmall,
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(
                  D.sizeSmall,
                ),
                color: context.colorScheme.primary,
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: context.colorScheme.onPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
