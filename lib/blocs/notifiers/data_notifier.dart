import 'package:great_quran/blocs/events/action_events.dart';
import 'package:great_quran/blocs/events/bus.dart';
import 'package:great_quran/blocs/states/generic_state.dart';
import 'package:great_quran/blocs/utils/bus_subscription.dart';
import 'package:great_quran/helpers/extensions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataNotifier extends StateNotifier<GenericState<String>>
    with BusSubscription {
  static final provider =
      StateNotifierProvider<DataNotifier, GenericState<String>>((ref) {
    return DataNotifier(
      ref.read(Bus.provider),
    );
  });

  final EventBus _eventBus;

  DataNotifier(this._eventBus) : super(GenericState.initial("Initial")) {
    on(
      const FetchDataEvent(),
      _eventBus,
      (event) async {
        "Fetch data event...".log();
        await _fetchData();
      },
    );
  }

  Future<void> _fetchData() async {
    try {
      state = GenericState.loading();
      await Future.delayed(
        const Duration(seconds: 1),
      );
      state = GenericState.success("Success");
    } catch (e) {
      e.log();
      state = GenericState.fail();
    }
  }
}
