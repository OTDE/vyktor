import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AnimationState extends Equatable {
  AnimationState([List props = const <dynamic>[]]) : super(props);
}

/// The types of panels that can be selected.
enum SelectedPanel { tournament, mapSettings, searchSettings, info, none }

/// The one and only state this BLoC can be in.
/// Covers every possible case of [SelectedPanel].
class AnimationPanelState extends AnimationState {
  final SelectedPanel selectedPanel;

  AnimationPanelState({@required this.selectedPanel}) : super([selectedPanel]);

  @override
  String toString() => 'Selecting panel.';
}
