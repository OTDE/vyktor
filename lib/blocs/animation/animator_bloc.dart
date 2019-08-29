import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './animation_barrel.dart';

class AnimatorBloc extends Bloc<AnimatorEvent, AnimatorState> {
  MarkerId _selectedTournament;

  @override
  AnimatorState get initialState => TabAnimatorState(
        isTournamentSelected: false,
        isMapSettingsSelected: false,
        isSearchSettingsSelected: false,
        isInfoSelected: false,
      );

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
    if (currentState is TabAnimatorState) {
      if (currentState.isTournamentSelected &&
          (_selectedTournament == null ||
              _selectedTournament == event.selectedTournament)) {
        print('$_selectedTournament <- old \n${event.selectedTournament} <-new');
        _selectedTournament = event.selectedTournament;
        this.dispatch(DeselectAll());
      } else {
        _selectedTournament = event.selectedTournament;
        yield TabAnimatorState(
          isTournamentSelected: true,
          isMapSettingsSelected: false,
          isSearchSettingsSelected: false,
          isInfoSelected: false,
        );
      }
    }
  }

  Stream<AnimatorState> _mapSelectMapSettingsToState(
      AnimatorState currentState, SelectMapSettings event) async* {
    yield TabAnimatorState(
      isTournamentSelected: false,
      isMapSettingsSelected: true,
      isSearchSettingsSelected: false,
      isInfoSelected: false,
    );
  }

  Stream<AnimatorState> _mapSelectSearchSettingsToState(
      AnimatorState currentState, SelectSearchSettings event) async* {
    yield TabAnimatorState(
      isTournamentSelected: false,
      isMapSettingsSelected: false,
      isSearchSettingsSelected: true,
      isInfoSelected: false,
    );
  }

  Stream<AnimatorState> _mapSelectInfoToState(
      AnimatorState currentState, SelectInfo event) async* {
    yield TabAnimatorState(
      isTournamentSelected: false,
      isMapSettingsSelected: false,
      isSearchSettingsSelected: false,
      isInfoSelected: true,
    );
  }

  Stream<AnimatorState> _mapDeselectAllToState(
      AnimatorState currentState, DeselectAll event) async* {
    yield TabAnimatorState(
      isTournamentSelected: false,
      isMapSettingsSelected: false,
      isSearchSettingsSelected: false,
      isInfoSelected: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
