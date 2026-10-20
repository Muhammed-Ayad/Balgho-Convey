import 'package:flutter/material.dart';
import 'package:great_quran/core/assets/assets_manager.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/utilities.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.titleHello,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          image: const DecorationImage(
            image: AssetImage(ImageAssets.contact),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    context.l10n.titleContactUs,
                    style: context.textTheme.displayLarge,
                  ),
                ),
                const Spacer(),
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundColor: context.colorScheme.error,
                        radius: D.sizeXXLarge,
                        child: CircleAvatar(
                          radius: D.sizeXLarge,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              Icons.mail_outline_outlined,
                              color: context.colorScheme.error,
                            ),
                            onPressed: Utilities.sendMessage,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
