import 'package:flutter/material.dart';
import 'package:great_quran/core/assets/assets_manager.dart';
import 'package:great_quran/core/helpers/boxes.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:great_quran/feature/radios/logic/providers/audio_notifier.dart';
import 'package:great_quran/feature/radios/view/widgets/play_radio_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AudioPage extends ConsumerStatefulWidget {
  final RadioDetalis radioDetalis;

  const AudioPage({super.key, required this.radioDetalis});

  @override
  ConsumerState<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends ConsumerState<AudioPage> {
  @override
  void initState() {
    super.initState();
    UiHelper.postBuild((_) {
      ref.read(AudioNotifier.provider.notifier).init(widget.radioDetalis.url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar(
        title: widget.radioDetalis.name,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: context.height - context.heightR(0.3),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(ImageAssets.circ),
                ),
              ),
            ),
            PlayRadioCard(url: widget.radioDetalis.url),
            B.verticalSizedBoxXXLarge,
          ],
        ),
      ),
    );
  }
}
