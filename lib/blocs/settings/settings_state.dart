import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class InitializingSettings extends SettingsState {
  @override
  String toString() => 'Initializing settings';
}

class SettingsLoaded extends SettingsState {
  final double radius;
  final DateTime afterDate;
  final DateTime beforeDate;
  final bool exploreModeEnabled;

  const SettingsLoaded({
    @required this.radius,
    @required this.afterDate,
    @required this.beforeDate,
    @required this.exploreModeEnabled
  });

  @override
  List<Object> get props => [radius, afterDate, beforeDate, exploreModeEnabled];

  @override
  String toString() => '''
    Settings loaded.
      radius: $radius,
      afterDate: $afterDate,
      beforeDate: $beforeDate,
      exploreModeEnabled: $exploreModeEnabled
  ''';
}