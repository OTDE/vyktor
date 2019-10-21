import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import 'map.dart';

/// The [Bloc] that regulates the state of Vyktor's map data.
class MapBloc extends Bloc<MapEvent, MapState> {
  /// The facilitator for providing [MapData] to the [MapBloc].
  final MapDataProvider _mapDataProvider = MapDataProvider();

  /// The geolocation object used to track position changes.
  final Geolocator _geolocator = Geolocator();

  /// The options used to build the geolocator stream.
  ///
  /// [distanceFilter] dictates how many meters the user needs to move before
  /// triggering a new position yield from the stream.
  final LocationOptions _locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1000);
  StreamSubscription<Position> _currentPosition;
  Position _lastKnownPosition;

  /// Initial state of the BLoC is loading the data. Will switch to [MapDataNotLoaded]
  /// on failure and [MapDataLoaded] on success.
  @override
  MapState get initialState => MapDataLoading();

  /// On constructing this BLoC, it listens to a stream of the phone's position, and
  /// then fires a [RefreshMarkerData] event when it receives new data.
  MapBloc() {
    _currentPosition = _geolocator
        .getPositionStream(_locationOptions)
        .listen((Position position) {
      _lastKnownPosition = position;
      dispatch(RefreshMarkerData(position));
    });
  }

  /// On receiving an event, pushes a new state, depending on event type.
  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is RefreshMarkerData) {
      yield* _mapRefreshMarkerDataToState(currentState, event);
    } else if (event is UpdateSelectedTournament) {
      yield* _mapUpdateSelectedTournamentToState(currentState, event);
    } else if (event is EnableLocationListening) {
      yield* _mapEnableLocationListeningToState(currentState, event);
    } else if (event is DisableLocationListening) {
      yield* _mapDisableLocationListeningToState(currentState, event);
    }
  }

  /// Uses input from the [RefreshMarkerData] event to stream [MapData].
  ///
  /// Catches [BadRequestException] if the GraphQL query is malformed in some
  /// way and a [InternetException] if the query can't get to the endpoint in
  /// the first place.
  Stream<MapState> _mapRefreshMarkerDataToState(
      MapState currentState, RefreshMarkerData event) async* {
    Loading().isNow(true);
    final position = event.currentPosition ?? _lastKnownPosition;
    _lastKnownPosition = event.currentPosition ?? _lastKnownPosition;
    await _mapDataProvider.refresh(position);
    final MapData mapDataToView = _mapDataProvider.mostRecentState;
    if (mapDataToView.hasErrors) {
      yield MapDataNotLoaded();
    } else {
      final Tournament tournamentToView = _mapDataProvider.selectedTournament;
      final CameraPosition initialCamera = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 10.0,
      );
      yield MapDataLoaded(
        tournamentToView,
        mapDataToView,
        initialPosition: initialCamera,
      );
    }
  }

  /// Receives input from the selected marker and updates the [selectedTournament].
  Stream<MapState> _mapUpdateSelectedTournamentToState(
      MapState currentState, UpdateSelectedTournament event) async* {
    if (currentState is MapDataLoaded) {
      _mapDataProvider.setSelectedTournament(event.markerId);
      final MapData mapDataToView = _mapDataProvider.mostRecentState;
      final Tournament tournamentToView = _mapDataProvider.selectedTournament;
      yield MapDataLoaded(
        tournamentToView,
        mapDataToView,
      );
    }
  }

  /// Resumes the [StreamSubscription] inside the BLoC.
  Stream<MapState> _mapEnableLocationListeningToState(
      MapState currentState, EnableLocationListening event) async* {
    if (_currentPosition.isPaused) _currentPosition.resume();
    yield currentState;
  }

  /// Pauses the [StreamSubscription] inside the BloC.
  ///
  /// A typical use case is if Explore Mode is enabled by the user.
  /// This prevents the map data from refreshing back to the user's location
  /// if they're moving while using explore mode.
  Stream<MapState> _mapDisableLocationListeningToState(
      MapState currentState, DisableLocationListening event) async* {
    if (!_currentPosition.isPaused) _currentPosition.pause();
    yield currentState;
  }

  /// Gotta have one of these so we can dispose of the subscription if necessary.
  @override
  void dispose() {
    _currentPosition.cancel();
    super.dispose();
  }
}
