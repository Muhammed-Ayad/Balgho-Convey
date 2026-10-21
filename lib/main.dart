import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_quran/app.dart';
import 'package:great_quran/feature/radios/logic/providers/radio_audio_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.grey,
    ),
  );

  RadioAudioHandler? audioHandler;
  try {
    audioHandler = await AudioService.init(
      builder: () => RadioAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.convey.ayah.mohamed.ayad.audio',
        androidNotificationChannelName: 'إذاعات القرآن الكريم',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        androidNotificationIcon: 'mipmap/ic_launcher',
      ),
    );
  } catch (e) {
    debugPrint("Failed to initialize AudioService: $e");
  }

  runApp(
    ProviderScope(
      overrides: [
        if (audioHandler != null)
          radioAudioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: MyApp(),
    ),
  );
}
