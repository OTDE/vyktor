import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../models/models.dart';
import 'tournaments.dart';

/// The [Bloc] that regulates the state of Vyktor's map data.
class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {

  /// Initial state of the BLoC is loading the data. Will switch to [MarkerDataNotLoaded]
  /// on failure and [MarkerDataLoaded] on success.
  @override
  TournamentState get initialState => TournamentLoading();

  /// On receiving an event, pushes a new state, depending on event type.
  @override
  Stream<TournamentState> mapEventToState(TournamentEvent event) async* {
    if (event is SelectTournament) {
      yield* _mapSelectTournamentToState(state, event);
    } else if (event is DeselectTournament) {
      yield* _mapDeselectTournamentToState(state, event);
    }
  }

  Stream<TournamentState> _mapSelectTournamentToState(
      TournamentState state, SelectTournament event) async* {
      try {
        yield TournamentSelected(TournamentModel().select(event.id));
      } catch(_) {
        yield TournamentNotSelected();
      }
  }

  Stream<TournamentState> _mapDeselectTournamentToState(
      TournamentState state, DeselectTournament event) async* {
      yield TournamentNotSelected();
  }

  @override
  Future<void> close() {
    return super.close();
  }
}