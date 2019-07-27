import 'dart:async';
import 'package:bloc/bloc.dart';
import 'map_bloc_barrel.dart';
import 'package:vyktor/models/map/map_data.dart';

class MapDataBloc extends Bloc<MapDataEvent, MapDataState> {

  final MapDataProvider mapDataProvider = MapDataProvider();

  @override
  MapDataState get initialState => InitialMapDataState();

  @override
  Stream<MapDataState> mapEventToState(
      MapDataEvent event
  ) async* {
    if(event is InitializeMapData) {
      yield* _mapInitializeMapDataToState(currentState, event);
    } else if(event is RefreshMapData) {
      yield* _mapRefreshMapDataToState(currentState, event);
    } else if(event is UpdateSelectedTournament) {
      yield* _mapUpdateSelectedTournamentToState(currentState, event);
    }
  }

  Stream<MapDataState> _mapInitializeMapDataToState(
      MapDataState currentState,
      InitializeMapData event
  ) async* {
    try {
      mapDataProvider.refresh(event.currentPosition);
      final MapData mapDataToView = mapDataProvider.mostRecentState;
      final Tournament tournamentToView = mapDataProvider.selectedTournament;
      yield MapDataLoaded(mapDataToView, tournamentToView);
    } catch (_) {
      yield MapDataNotLoaded();
    }
  }

  Stream<MapDataState> _mapRefreshMapDataToState(
      MapDataState currentState,
      RefreshMapData event
  ) async* {
    if(currentState is MapDataLoaded) {
      mapDataProvider.refresh(event.currentPosition);
      final MapData mapDataToView = mapDataProvider.mostRecentState;
      final Tournament tournamentToView = mapDataProvider.selectedTournament
          ?? mapDataProvider.mostRecentState.tournaments[0];
      yield MapDataLoaded(mapDataToView, tournamentToView);
    }
  }

  Stream<MapDataState> _mapUpdateSelectedTournamentToState(
      MapDataState currentState,
      UpdateSelectedTournament event
  ) async* {
    if(currentState is MapDataLoaded) {
      mapDataProvider.setSelectedTournament(event.markerId);
      final MapData mapDataToView = mapDataProvider.mostRecentState;
      final Tournament tournamentToView = mapDataProvider.selectedTournament;
      yield MapDataLoaded(mapDataToView, tournamentToView);
    }
  }

}
