import 'dart:async';

import 'package:bloc/bloc.dart';

import 'animation.dart';

/// The [Bloc] that regulates the state of the selected panels in Vyktor.
class AnimatorBloc extends Bloc<AnimationEvent, AnimationState> {
  /// No panels are selected to begin with. There's only one state.
  @override
  AnimationState get initialState =>
      AnimationPanelState(selectedPanel: SelectedPanel.none);

  /// On receiving an event, pushes a new state, dependent on the event type.
  ///
  /// Here, the event determines which panel is selected.
  @override
  Stream<AnimationState> mapEventToState(
    AnimationEvent event,
  ) async* {
    if (event is SelectTournamentPanel) {
      yield* _mapSelectTournamentToState(currentState, event);
    } else if (event is SelectMapSettingsPanel) {
      yield* _mapSelectMapSettingsToState(currentState, event);
    } else if (event is SelectSearchSettingsPanel) {
      yield* _mapSelectSearchSettingsToState(currentState, event);
    } else if (event is SelectInfoPanel) {
      yield* _mapSelectInfoToState(currentState, event);
    } else if (event is DeselectAllPanels) {
      yield* _mapDeselectAllToState(currentState, event);
    }
  }

  /// Each of these methods selects a different panel type, with the
  /// exception of [_mapDeselectAllToState], which deselects all panels.
  Stream<AnimationState> _mapSelectTournamentToState(
      AnimationState currentState, SelectTournamentPanel event) async* {
    yield AnimationPanelState(selectedPanel: SelectedPanel.tournament);
  }

  Stream<AnimationState> _mapSelectMapSettingsToState(
      AnimationState currentState, SelectMapSettingsPanel event) async* {
    yield AnimationPanelState(selectedPanel: SelectedPanel.mapSettings);
  }

  Stream<AnimationState> _mapSelectSearchSettingsToState(
      AnimationState currentState, SelectSearchSettingsPanel event) async* {
    yield AnimationPanelState(selectedPanel: SelectedPanel.searchSettings);
  }

  Stream<AnimationState> _mapSelectInfoToState(
      AnimationState currentState, SelectInfoPanel event) async* {
    yield AnimationPanelState(selectedPanel: SelectedPanel.info);
  }

  Stream<AnimationState> _mapDeselectAllToState(
      AnimationState currentState, DeselectAllPanels event) async* {
    yield AnimationPanelState(selectedPanel: SelectedPanel.none);
  }
}
