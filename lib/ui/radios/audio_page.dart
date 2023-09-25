import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_quran/blocs/models/radios/radio.dart';
import 'package:great_quran/blocs/notifiers/audio_notifier.dart';
import 'package:great_quran/helpers/boxes.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/helpers/ui_helpers.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/ui/radios/play_radio_card.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class AudioPage extends ConsumerStatefulWidget {
  final RadioDetails radioDetails;

  const AudioPage({Key? key, required this.radioDetails}) : super(key: key);

  @override
  ConsumerState<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends ConsumerState<AudioPage> {
  @override
  void initState() {
    UiHelper.postBuild((_) {
      ref.read(AudioNotifier.provider.notifier).init(widget.radioDetails.url);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar(
        title: widget.radioDetails.name,
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
            PlayRadioCard(url: widget.radioDetails.url),
            B.verticalSizedBoxXXLarge,
          ],
        ),
      ),
    );
  }
}
