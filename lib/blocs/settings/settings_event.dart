import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class InitializeSettings extends SettingsEvent {
  @override
  String toString() => 'Initializing settings';
}

class SetRadius extends SettingsEvent {
  final double radius;

  const SetRadius(this.radius);

  @override
  List<Object> get props => [radius];

  @override
  String toString() => 'Setting radius to $radius';
}

class SetAfterDate extends SettingsEvent {
  final DateTime date;

  const SetAfterDate(this.date);

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'Setting afterDate to $date';
}

class SetBeforeDate extends SettingsEvent {
  final DateTime date;

  const SetBeforeDate(this.date);

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'Setting beforeDate to $date';
}

class SetExploreModeEnabled extends SettingsEvent {
  final bool exploreModeEnabled;

  const SetExploreModeEnabled(this.exploreModeEnabled);

  @override
  List<Object> get props => [exploreModeEnabled];

  @override
  String toString() => 'Setting exploreModeEnabled to $exploreModeEnabled';
}

