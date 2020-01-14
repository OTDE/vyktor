import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum SelectedPanel { tournament, mapSettings, searchSettings, info }

@immutable
abstract class PanelSelectorState extends Equatable {
  const PanelSelectorState();

  @override
  List<Object> get props => [];
}

class PanelHidden extends PanelSelectorState {
  @override
  String toString() => 'Panel hidden';
}

class PanelSelected extends PanelSelectorState {
  final SelectedPanel panel;

  const PanelSelected(this.panel);

  @override
  List<Object> get props => [panel];

  @override
  String toString() => 'Panel selected: $panel';
}