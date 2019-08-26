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
      final Tournament tournamentToView = _mapDataProvider.selectedTournament ??
          _mapDataProvider.mostRecentState.tournaments[0];
      final CameraPosition initialCamera = CameraPosition(
        target: positionToLatLng(event.currentPosition),
        zoom: DEFAULT_ZOOM_LEVEL,
      );
      yield MapDataLoaded(tournamentToView,
          _buildMarkerDataFrom(mapDataToView, tournamentToView), initialCamera);
    }
  }

  /// Receives input from the selected marker and updates the [selectedTournament].
  Stream<MapDataState> _mapUpdateSelectedTournamentToState(
      MapDataState currentState, UpdateSelectedTournament event) async* {
    if (currentState is MapDataLoaded) {
      _mapDataProvider.setSelectedTournament(event.markerId);
      final MapData mapDataToView = _mapDataProvider.mostRecentState;
      final Tournament tournamentToView = _mapDataProvider.selectedTournament;
      yield MapDataLoaded(
          tournamentToView, _buildMarkerDataFrom(mapDataToView));
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

  /// Creates markers with attributes and fields pulled from [mapData].
  ///
  /// If [selectedTournament] is included in the arguments, adds it to the list
  /// of [Markers] to send to the [GoogleMap] widget. Each [onTap] callback
  /// triggers a [Bloc] event.
  Set<Marker> _buildMarkerDataFrom(MapData mapData,
      [Tournament selectedTournament]) {
    var markerData = Set<Marker>();
    if (selectedTournament != null) {
      if (!mapData.tournaments.contains(selectedTournament))
        mapData.tournaments.add(selectedTournament);
    }
    for (Tournament tournament in mapData.tournaments) {
      var id = MarkerId(tournament.id.toString());
      var mapMarker = Marker(
        markerId: id,
        position: LatLng(tournament.lat, tournament.lng),
        infoWindow: InfoWindow(
          title: tournament.name,
          snippet: tournament.venueAddress,
          onTap: () {
            _launchURL(tournament.slug);
          },
        ),
        onTap: () {
          this.dispatch(UpdateSelectedTournament(id));
        },
      );
      markerData.add(mapMarker);
    }
    return markerData;
  }

  /// Launches a URL with the given [slug].
  ///
  /// See [_buildURL] for the format of the URL.
  _launchURL(String slug) async {
    final url = _buildURL(slug);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _buildURL(String slug) => 'http://smash.gg/' + slug;

  /// Toggles the subscription to the phone's location.
  void _togglePositionSubscription() {
    if(_currentPosition.isPaused) {
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
