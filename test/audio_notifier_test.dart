import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/radios/logic/models/radio.dart';
import 'package:great_quran/feature/radios/logic/providers/audio_notifier.dart';
import 'package:great_quran/feature/radios/view/widgets/radio_mini_player_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const globalChannel = MethodChannel('xyz.luan/audioplayers.global');
    const playerChannel = MethodChannel('xyz.luan/audioplayers');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(globalChannel, (call) async => 1);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(playerChannel, (call) async => 1);
  });

  group('Live Stream AudioNotifier tests', () {
    test('Initializes with default state', () {
      final notifier = AudioNotifier();
      addTearDown(notifier.dispose);

      expect(notifier.isPlaying, false);
      expect(notifier.currentRadio, isNull);
      expect(notifier.hasNext, false);
      expect(notifier.hasPrevious, false);
      expect(notifier.totalCount, 0);
    });

    test('Playlist navigation updates current station and indices', () {
      final notifier = AudioNotifier();
      addTearDown(notifier.dispose);

      final stations = [
        const RadioDetalis("إذاعة القاهرة", "https://example.com/stream1"),
        const RadioDetalis("إذاعة مكة المكرمة", "https://example.com/stream2"),
        const RadioDetalis("إذاعة تلاوات خاشعة", "https://example.com/stream3"),
      ];

      notifier.initPlaylist(stations, 1);

      expect(notifier.currentRadio?.name, "إذاعة مكة المكرمة");
      expect(notifier.currentIndex, 1);
      expect(notifier.totalCount, 3);
      expect(notifier.hasNext, true);
      expect(notifier.hasPrevious, true);
    });

    test('Safe dispose does not throw or crash', () {
      final notifier = AudioNotifier();
      expect(() => notifier.dispose(), returnsNormally);
    });

    testWidgets('RadioMiniPlayerWidget renders shrink when stopped',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              bottomNavigationBar: RadioMiniPlayerWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(RadioMiniPlayerWidget), findsOneWidget);
      expect(find.text("بث حي مباشر"), findsNothing);
    });
  });
}
