import 'dart:async';
import 'package:bloc/bloc.dart';
import './animation_barrel.dart';

class AnimatorBloc extends Bloc<AnimatorEvent, AnimatorState> {

  @override
  AnimatorState get initialState => TabAnimatorState(selectedPanel: SelectedPanel.none);

  @override
  Stream<AnimatorState> mapEventToState(
    AnimatorEvent event,
  ) async* {
    if (event is SelectTournament) {
      yield* _mapSelectTournamentToState(currentState, event);
    } else if (event is SelectMapSettings) {
      yield* _mapSelectMapSettingsToState(currentState, event);
    } else if (event is SelectSearchSettings) {
      yield* _mapSelectSearchSettingsToState(currentState, event);
    } else if (event is SelectInfo) {
      yield* _mapSelectInfoToState(currentState, event);
    } else if (event is DeselectAll) {
      yield* _mapDeselectAllToState(currentState, event);
    }
  }

  Stream<AnimatorState> _mapSelectTournamentToState(
      AnimatorState currentState, SelectTournament event) async* {
    yield TabAnimatorState(selectedPanel: SelectedPanel.tournament);
  }

  Stream<AnimatorState> _mapSelectMapSettingsToState(
      AnimatorState currentState, SelectMapSettings event) async* {
    yield TabAnimatorState(selectedPanel: SelectedPanel.mapSettings);
  }

  Stream<AnimatorState> _mapSelectSearchSettingsToState(
      AnimatorState currentState, SelectSearchSettings event) async* {
    yield TabAnimatorState(selectedPanel: SelectedPanel.searchSettings);
  }

  Stream<AnimatorState> _mapSelectInfoToState(
      AnimatorState currentState, SelectInfo event) async* {
    yield TabAnimatorState(selectedPanel: SelectedPanel.info);
  }

  Stream<AnimatorState> _mapDeselectAllToState(
      AnimatorState currentState, DeselectAll event) async* {
    yield TabAnimatorState(selectedPanel: SelectedPanel.none);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
