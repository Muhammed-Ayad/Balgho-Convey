import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Bus {
  static final provider = Provider<EventBus>((ref) {
    final bus = EventBus();
    ref.onDispose(bus.destroy);
    return bus;
  });
}
