import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AnimatorEvent extends Equatable {
  AnimatorEvent([List props = const <dynamic>[]]) : super(props);
}

class SelectTournament extends AnimatorEvent {

  final MarkerId selectedTournament;

  SelectTournament(this.selectedTournament): super([selectedTournament]);

  @override
  String toString() => 'Event triggered: selecting tournament tab.';
}

class SelectMapSettings extends AnimatorEvent {
  SelectMapSettings(): super();

  @override
  String toString() => 'Event triggered: selecting map settings.';
}

class SelectSearchSettings extends AnimatorEvent {
  SelectSearchSettings(): super();

  @override
  String toString() => 'Event triggered: selecting search settings.';
}

class SelectInfo extends AnimatorEvent {
  SelectInfo(): super();

  @override
  String toString() => 'Event triggered: selecting search settings.';
}

class DeselectAll extends AnimatorEvent {
  DeselectAll(): super();

  @override
  String toString() => 'Event triggered: deselecting all widgets.';
}