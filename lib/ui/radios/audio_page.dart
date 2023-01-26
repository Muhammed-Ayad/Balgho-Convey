import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:great_quran/blocs/models/radios/radio.dart';
import 'package:great_quran/helpers/boxes.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class AudioPage extends StatefulWidget {
  final RadioDetalis radioDetalis;
  const AudioPage({Key? key, required this.radioDetalis}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(widget.radioDetalis.url);
    _isPlaying = true;
    listenRadio();
    super.initState();
  }

  listenRadio() {
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
        // event = PlayerState.STOPPED;
      }
    });
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
    setState(() {});
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: D.sizeMedium,
                    vertical: D.sizeLarge,
                  ),
                  child: Card(
                    elevation: D.sizeXSmall,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(D.sizeXLarge)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.primary.withOpacity(0.1),
                            offset: const Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(D.sizeXLarge),
                        border: Border.all(
                          color: context.colorScheme.primary,
                          width: D.sizeXXSmall,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(D.sizeSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (_isPlaying) {
                                    _audioPlayer.stop();
                                    setState(() {
                                      _isPlaying = false;
                                    });
                                  } else {
                                    _isPlaying = true;
                                    _playMusic(widget.radioDetalis.url);
                                  }
                                },
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  _isPlaying
                                      ? Icons.stop_circle_outlined
                                      : Icons.play_circle_filled,
                                  size: context.widthR(0.12),
                                  color: context.colorScheme.primary,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            B.verticalSizedBoxXXLarge,
          ],
        ),
      ),
    );
  }
}
