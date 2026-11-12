import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:great_quran/feature/feelings/logic/providers/feelings_provider.dart';
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

  group('FeelingAudioNotifier Tests', () {
    test('Initial state is VerseAudioStatus.initial with index 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(feelingAudioNotifierProvider);
      expect(state.status, VerseAudioStatus.initial);
      expect(state.activeAyahIndex, 0);
      expect(state.errorMessage, isNull);
    });

    test('onPageChanged updates index and resets status', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(feelingAudioNotifierProvider.notifier);
      notifier.onPageChanged(2);

      final state = container.read(feelingAudioNotifierProvider);
      expect(state.activeAyahIndex, 2);
      expect(state.status, VerseAudioStatus.initial);
    });

    test('pauseVerse and stopVerse update state correctly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(feelingAudioNotifierProvider.notifier);
      await notifier.pauseVerse();

      expect(
        container.read(feelingAudioNotifierProvider).status,
        VerseAudioStatus.paused,
      );

      await notifier.stopVerse();

      expect(
        container.read(feelingAudioNotifierProvider).status,
        VerseAudioStatus.initial,
      );
    });

    test('Disposes cleanly on container disposal', () {
      final container = ProviderContainer();
      container.read(feelingAudioNotifierProvider.notifier);
      expect(() => container.dispose(), returnsNormally);
    });
  });
}
