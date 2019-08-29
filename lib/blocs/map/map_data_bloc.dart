import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:vyktor/models/map_data.dart';
import 'package:vyktor/services/location_utils.dart';

import 'map_data_barrel.dart';

/// The "go-between" for the pages and the models of this app.
///
/// Broadcasts various [MapData] states through a [Stream] built
/// by the [mapEventToState] function.
class MapDataBloc extends Bloc<MapDataEvent, MapDataState> {
  /// The facilitator for providing [MapData] to the [MapDataBloc].
  final MapDataProvider _mapDataProvider = MapDataProvider();

  /// The geolocation object used to track position changes.
  final Geolocator _geolocator = Geolocator();

  /// The options used to build the geolocator stream.
  ///
  /// The [LocationAccuracy] defaults to high, and the stream updates
  /// when the user moves a number of meters determined by [distanceFilter]
  /// away from the last position.
  final LocationOptions _locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 100);
  StreamSubscription<Position> _currentPosition;

  /// Creates the initial state of the [MapDataBloc].
  ///
  /// TODO: consider making this [MapDataLoading].
  @override
  MapDataState get initialState => InitialMapDataState();

  /// On constructing this, listens to a stream of the phone's positions, and
  /// then fires a [RefreshMarkerData] event when it receives new data.
  MapDataBloc() {
    _currentPosition = _geolocator
        .getPositionStream(_locationOptions)
        .listen((Position position) {
      dispatch(RefreshMarkerData(position));
    });
  }

  /// On receiving an event, pushes a new state, depending on event type.
  @override
  Stream<MapDataState> mapEventToState(MapDataEvent event) async* {
    if (event is InitializeMap) {
      yield* _mapInitializeMapDataToState(currentState, event);
    } else if (event is RefreshMarkerData) {
      yield* _mapRefreshMarkerDataToState(currentState, event);
    } else if (event is UpdateSelectedTournament) {
      yield* _mapUpdateSelectedTournamentToState(currentState, event);
    } else if (event is ToggleLocationListening) {
      yield* _mapToggleLocationListeningToState(currentState, event);
    } else if (event is ToggleMapLocking) {
      yield* _mapToggleMapLockingToState(currentState, event);
    } else if (event is LockMap) {
      yield* _mapLockMapToState(currentState, event);
    } else if (event is UnlockMap) {
      yield* _mapUnlockMapToState(currentState, event);
    }
  }

  /// Is this used? Consider cleaning up if the case.
  Stream<MapDataState> _mapInitializeMapDataToState(
      MapDataState currentState, InitializeMap event) async* {
    try {
      if (!(currentState is MapDataLoaded)) {
        yield InitialMapDataState();
      }
    } catch (_) {
      yield MapDataNotLoaded();
    }
  }

  /// Uses input from the [RefreshMarkerData] event to stream [MapData].
  Stream<MapDataState> _mapRefreshMarkerDataToState(
      MapDataState currentState, RefreshMarkerData event) async* {
    if (currentState is MapDataLoaded || currentState is InitialMapDataState) {
      await _mapDataProvider.refresh(event.currentPosition);
      final MapData mapDataToView = _mapDataProvider.mostRecentState;
      final Tournament tournamentToView =
          _mapDataProvider.selectedTournament ?? Tournament(id: -1);
      final CameraPosition initialCamera = CameraPosition(
        target: positionToLatLng(event.currentPosition),
        zoom: DEFAULT_ZOOM_LEVEL,
      );
      yield MapDataLoaded(
        tournamentToView,
        mapDataToView,
        initialPosition: initialCamera,
        isMapUnlocked: true,
      );
    }
  }

  /// Receives input from the selected marker and updates the [selectedTournament].
  Stream<MapDataState> _mapUpdateSelectedTournamentToState(
      MapDataState currentState, UpdateSelectedTournament event) async* {
    if (currentState is MapDataLoaded) {
      if (int.parse(event.markerId.value) != -1) {
        _mapDataProvider.setSelectedTournament(event.markerId);
      }
      final MapData mapDataToView = _mapDataProvider.mostRecentState;
      final Tournament tournamentToView =
          (int.parse(event.markerId.value) != -1)
              ? _mapDataProvider.selectedTournament
              : Tournament(id: -1);
      yield MapDataLoaded(
        tournamentToView,
        mapDataToView,
        isMapUnlocked: currentState.isMapUnlocked,
      );
    }
  }

  /// Toggles the subscription to the phone's location.
  ///
  /// TODO: think about less boilerplate-y ways to accomplish this.
  /// Maybe have it pass a boolean to ensure the logic doesn't flip accidentally?
  Stream<MapDataState> _mapToggleLocationListeningToState(
      MapDataState currentState, ToggleLocationListening event) async* {
    _togglePositionSubscription();
    yield currentState;
  }

  Stream<MapDataState> _mapToggleMapLockingToState(
      MapDataState currentState, ToggleMapLocking event) async* {
    if (currentState is MapDataLoaded) {
      yield MapDataLoaded(currentState.selectedTournament, currentState.mapData,
          isMapUnlocked: !currentState.isMapUnlocked ?? false);
    }
  }

  Stream<MapDataState> _mapLockMapToState(
      MapDataState currentState, LockMap event) async* {
    if (currentState is MapDataLoaded) {
      yield MapDataLoaded(currentState.selectedTournament, currentState.mapData,
          isMapUnlocked: false);
    }
  }

  Stream<MapDataState> _mapUnlockMapToState(
      MapDataState currentState, UnlockMap event) async* {
    if (currentState is MapDataLoaded) {
      yield MapDataLoaded(currentState.selectedTournament, currentState.mapData,
          isMapUnlocked: true);
    }
  }

  /// Toggles the subscription to the phone's location.
  void _togglePositionSubscription() {
    if (_currentPosition.isPaused) {
      _currentPosition.resume();
    } else {
      _currentPosition.pause();
    }
  }

  @override
  void dispose() {
    _currentPosition.cancel();
    super.dispose();
  }
}
