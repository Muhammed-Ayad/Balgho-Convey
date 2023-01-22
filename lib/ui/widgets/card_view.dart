import 'package:flutter/material.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/dimensions.dart';

class CardViewWidget extends StatelessWidget {
  const CardViewWidget(this.title, this.route, this.image, {super.key});
  final String title;
  final String route;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.all(
            D.sizeSmall,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Card(
                  elevation: D.sizeSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      D.sizeSmall,
                    ),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        D.sizeSmall,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(image),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  elevation: D.sizeSmall,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      D.sizeSmall,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
