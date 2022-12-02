import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  final List _props;

  final bool isUrgent;

  const AppEvent(this.isUrgent, [this._props = const []]);

  @override
  List<Object?> get props => [..._props, runtimeType];
}
