import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../blocs/blocs.dart';
import 'tournaments.dart';

class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {

  @override
  TournamentState get initialState => TournamentLoading();

  final MarkerBloc markerBloc;

  TournamentBloc({@required this.markerBloc});

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
        final markerState = markerBloc.state;
        if (markerState is MarkerDataLoaded) {
          final selection = markerState.markerData.firstWhere((tournament) {
            return tournament.id == event.id;
          });
          yield TournamentSelected(selection);
        }
        yield TournamentNotSelected();
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