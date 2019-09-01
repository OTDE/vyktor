import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AnimatorState extends Equatable {
  AnimatorState([List props = const <dynamic>[]]) : super(props);
}

enum SelectedPanel { tournament, mapSettings, searchSettings, info, none }

class TabAnimatorState extends AnimatorState {
  final SelectedPanel selectedPanel;

  TabAnimatorState({@required this.selectedPanel}) : super([selectedPanel]);

  @override
  String toString() => 'Selecting tab.';
}
