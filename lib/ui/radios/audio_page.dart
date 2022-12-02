import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:great_quran/blocs/models/radios/radios.dart';
import 'package:great_quran/helpers/constants.dart';
import 'package:great_quran/ui/resources/assets_manager.dart';
import 'package:great_quran/ui/resources/color_manager.dart';
import 'package:great_quran/ui/resources/values_manager.dart';
import 'package:great_quran/ui/widgets/appbar_widget.dart';

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
      backgroundColor: ColorManager.white,
      appBar: appBarWidget(
        widget.radios.name,
        Constants.elevationAppBarOne,
        context,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - AppSize.s250,
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
                      horizontal: AppSize.s10, vertical: AppSize.s16),
                  child: Card(
                    elevation: AppSize.s5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s20)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorManager.cyanOne,
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.cyanTwo,
                            offset: const Offset(AppSize.s0, AppSize.s2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(AppSize.s20),
                        border: Border.all(
                          color: ColorManager.cyanTwo,
                          width: AppSize.s1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppPadding.p8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.skip_next,
                                size: AppSize.s50,
                                color: ColorManager.black38,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(AppPadding.p8),
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
                                        size: AppSize.s50,
                                        color: ColorManager.darkGrey,
                                      )
                                    : Icon(
                                        Icons.play_circle_filled,
                                        size: AppSize.s50,
                                        color: ColorManager.darkGrey,
                                      ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.skip_previous,
                                size: AppSize.s50,
                                color: ColorManager.black38,
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
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
