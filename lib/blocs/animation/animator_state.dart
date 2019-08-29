import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AnimatorState extends Equatable {
  AnimatorState([List props = const <dynamic>[]]) : super(props);
}

class TabAnimatorState extends AnimatorState {
  final bool isTournamentSelected;

  final bool isMapSettingsSelected;

  final bool isSearchSettingsSelected;

  final bool isInfoSelected;

  TabAnimatorState(
      {@required this.isTournamentSelected,
      @required this.isMapSettingsSelected,
      @required this.isSearchSettingsSelected,
      @required this.isInfoSelected})
      : super([
          isTournamentSelected,
          isMapSettingsSelected,
          isSearchSettingsSelected,
          isInfoSelected
        ]);

  @override
  String toString() => 'Selecting tab.';
}
