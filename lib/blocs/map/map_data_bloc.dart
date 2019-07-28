import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'map_data_barrel.dart';
import 'package:vyktor/models/map_data.dart';
import 'package:geolocator/geolocator.dart';

class MapDataBloc extends Bloc<MapDataEvent, MapDataState> {

  final MapDataProvider _mapDataProvider = MapDataProvider();
  final Geolocator _geolocator = Geolocator();
  final LocationOptions _locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 100);
  StreamSubscription<Position> _currentPosition;

  @override
  MapDataState get initialState => InitialMapDataState();

  MapDataBloc() {
    _currentPosition = _geolocator.getPositionStream(_locationOptions).listen(
        (Position position) {
          dispatch(RefreshMapData(position));
        }
    );
  }

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
      _mapDataProvider.refresh(event.currentPosition);
      final MapData mapDataToView = _mapDataProvider.mostRecentState;
      final Tournament tournamentToView = _mapDataProvider.selectedTournament;
      yield MapDataLoaded(mapDataToView, tournamentToView);
    } catch (_) {
      yield MapDataNotLoaded();
    }
  }

  Stream<MapDataState> _mapRefreshMapDataToState(
      MapDataState currentState,
      RefreshMapData event
  ) async* {
    if(currentState is MapDataLoaded || currentState is InitialMapDataState) {
      await _mapDataProvider.refresh(event.currentPosition);
      print(_mapDataProvider.mostRecentState.tournaments[0].name);
      final MapData mapDataToView = _mapDataProvider.mostRecentState;
      final Tournament tournamentToView = _mapDataProvider.selectedTournament
          ?? _mapDataProvider.mostRecentState.tournaments[0];
      yield MapDataLoaded(mapDataToView, tournamentToView);
    }
  }

  Stream<MapDataState> _mapUpdateSelectedTournamentToState(
      MapDataState currentState,
      UpdateSelectedTournament event
  ) async* {
    if(currentState is MapDataLoaded) {
      _mapDataProvider.setSelectedTournament(event.markerId);
      final MapData mapDataToView = _mapDataProvider.mostRecentState;
      final Tournament tournamentToView = _mapDataProvider.selectedTournament;
      yield MapDataLoaded(mapDataToView, tournamentToView);
    }
  }

  @override
  void dispose() {
    _currentPosition.cancel();
    super.dispose();
  }

}
