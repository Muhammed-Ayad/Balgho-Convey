import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:great_quran/blocs/models/radios/radios.dart';
import 'package:great_quran/helpers/boxes.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:great_quran/theme/colors.dart';
import 'package:great_quran/theme/dimensions.dart';
import 'package:great_quran/resources/assets_manager.dart';
import 'package:great_quran/ui/widgets/custom_app_bar.dart';

class AudioPage extends StatefulWidget {
  final Radios radios;
  const AudioPage({Key? key, required this.radios}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(widget.radios.url);
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
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: widget.radios.name,
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
                        color: AppColors.cyanOne,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyanTwo,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(D.sizeXLarge),
                        border: Border.all(
                          color: AppColors.cyanTwo,
                          width: D.sizeXXSmall,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(D.sizeSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.skip_next,
                                size: context.widthR(0.12),
                                color: AppColors.black38,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(D.sizeSmall),
                              child: IconButton(
                                onPressed: () {
                                  if (_isPlaying) {
                                    _audioPlayer.stop();
                                    setState(() {
                                      _isPlaying = false;
                                    });
                                  } else {
                                    _isPlaying = true;
                                    _playMusic(widget.radios.url);
                                  }
                                },
                                icon: _isPlaying
                                    ? Icon(
                                        Icons.stop_circle_outlined,
                                        size: context.widthR(0.12),
                                        color: AppColors.darkGrey,
                                      )
                                    : Icon(
                                        Icons.play_circle_filled,
                                        size: context.widthR(0.12),
                                        color: AppColors.darkGrey,
                                      ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.skip_previous,
                                size: context.widthR(0.12),
                                color: AppColors.black38,
                              ),
                            ),
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
