import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:great_quran/feature/qibla/logic/repo/qibla_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final compassStreamProvider = StreamProvider<CompassEvent>((ref) {
  final events = FlutterCompass.events;
  if (events == null) {
    throw "مستشعر البوصلة غير مدعوم في هذا الجهاز أو المحاكي";
  }

  return events.timeout(
    const Duration(seconds: 4),
    onTimeout: (sink) {
      sink.addError("تعذر قراءة حساس البوصلة في هذا الجهاز أو المحاكي");
    },
  );
});

class QiblaDirectionNotifier extends StateNotifier<AsyncValue<double>> {
  static final provider =
      StateNotifierProvider<QiblaDirectionNotifier, AsyncValue<double>>((ref) {
    return QiblaDirectionNotifier(ref.read(QiblaRepository.provider));
  });

  final IQiblaRepository _repository;
  QiblaDirectionNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getQiblaDirection());
  }
}
