import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'panel_selector.dart';

@immutable
abstract class PanelSelectorEvent extends Equatable {
  const PanelSelectorEvent();

  @override
  List<Object> get props => [];
}

class SelectPanel extends PanelSelectorEvent {
  final SelectedPanel panel;

  const SelectPanel({@required this.panel});

  @override
  List<Object> get props => [panel];

  @override
  String toString() => 'Setting selected panel to $panel';
}

class HidePanel extends PanelSelectorEvent {
  @override
  String toString() => 'Hiding panel';
}