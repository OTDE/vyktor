import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for handling animation events.
@immutable
abstract class AnimationEvent extends Equatable {
  AnimationEvent([List props = const <dynamic>[]]) : super(props);
}

/// Each of these classes represents an event for selecting a specific tab.
/// They're fairly self-explanatory, since this is a simple BLoC.
class SelectTournamentPanel extends AnimationEvent {
  SelectTournamentPanel() : super();

  @override
  String toString() => 'Event triggered: selecting tournament tab';
}

class SelectMapSettingsPanel extends AnimationEvent {
  SelectMapSettingsPanel() : super();

  @override
  String toString() => 'Event triggered: selecting map settings';
}

class SelectSearchSettingsPanel extends AnimationEvent {
  SelectSearchSettingsPanel() : super();

  @override
  String toString() => 'Event triggered: selecting search settings';
}

class SelectInfoPanel extends AnimationEvent {
  SelectInfoPanel() : super();

  @override
  String toString() => 'Event triggered: selecting info panel';
}

class DeselectAllPanels extends AnimationEvent {
  DeselectAllPanels() : super();

  @override
  String toString() => 'Event triggered: deselecting all widgets';
}
