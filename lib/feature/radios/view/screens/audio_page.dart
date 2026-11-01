import 'package:flutter/material.dart';
import 'package:great_quran/core/helpers/extensions.dart';
import 'package:great_quran/core/helpers/ui_helpers.dart';
import 'package:great_quran/core/theme/dimensions.dart';
import 'package:great_quran/core/widgets/custom_app_bar.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:great_quran/feature/radios/logic/providers/audio_notifier.dart';
import 'package:great_quran/feature/radios/view/widgets/audio_artwork_card.dart';
import 'package:great_quran/feature/radios/view/widgets/audio_player_controls.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_station_list_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AudioPage extends ConsumerStatefulWidget {
  final List<RadioDetalis> radioList;
  final int initialIndex;

  AudioPage({
    super.key,
    required List<RadioDetalis> radioList,
    this.initialIndex = 0,
  }) : radioList = radioList.isNotEmpty
            ? radioList
            : const [RadioDetalis("إذاعة القرآن الكريم", "")];

  AudioPage.single({
    super.key,
    required RadioDetalis radioDetalis,
  })  : radioList = [radioDetalis],
        initialIndex = 0;

  @override
  ConsumerState<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends ConsumerState<AudioPage> {
  @override
  void initState() {
    super.initState();
    UiHelper.postBuild((_) {
      ref
          .read(AudioNotifier.provider.notifier)
          .initPlaylist(widget.radioList, widget.initialIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(AudioNotifier.provider);
    final currentRadio = notifier.currentRadio ??
        (widget.radioList.isNotEmpty ? widget.radioList.first : null);
    final title = currentRadio?.name ?? "إذاعة القرآن الكريم";

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar(
        title: title,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: D.sizeMedium),
              AudioArtworkCard(
                title: title,
                isPlaying: notifier.isPlaying,
              ),
              const SizedBox(height: D.sizeMedium),
              AudioPlayerControls(
                notifier: notifier,
              ),
              if (notifier.totalCount > 1) ...[
                const SizedBox(height: D.sizeMedium),
                RadioStationListWidget(
                  stations: notifier.playlist,
                  currentIndex: notifier.currentIndex,
                  onSelect: (index) {
                    ref
                        .read(AudioNotifier.provider.notifier)
                        .selectStation(index);
                  },
                ),
              ],
              const SizedBox(height: D.sizeXXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
