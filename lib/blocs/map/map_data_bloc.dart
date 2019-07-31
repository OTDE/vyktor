import 'dart:async';
import 'package:bloc/bloc.dart';
import 'map_data_barrel.dart';
import 'package:vyktor/models/map_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vyktor/services/location_utils.dart';

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
          dispatch(RefreshMarkerData(position));
        }
    );
  }

  @override
  Stream<MapDataState> mapEventToState(
      MapDataEvent event
  ) async* {
    if(event is InitializeMap) {
      yield* _mapInitializeMapDataToState(currentState, event);
    } else if(event is RefreshMarkerData) {
      yield* _mapRefreshMarkerDataToState(currentState, event);
    } else if(event is UpdateSelectedTournament) {
      yield* _mapUpdateSelectedTournamentToState(currentState, event);
    }
  }

  Stream<MapDataState> _mapInitializeMapDataToState(
      MapDataState currentState,
      InitializeMap event
  ) async* {
    try {
      if(!(currentState is MapDataLoaded)) {
        yield InitialMapDataState();
      }
    } catch (_) {
      yield MapDataNotLoaded();
    }
  }

  Stream<MapDataState> _mapRefreshMarkerDataToState(
      MapDataState currentState,
      RefreshMarkerData event
  ) async* {
    if(currentState is MapDataLoaded || currentState is InitialMapDataState) {
      await _mapDataProvider.refresh(event.currentPosition);
      final MapData mapDataToView = _mapDataProvider.mostRecentState;
      final Tournament tournamentToView = _mapDataProvider.selectedTournament
          ?? _mapDataProvider.mostRecentState.tournaments[0];
      final CameraPosition initialCamera = CameraPosition(
        target: positionToLatLng(event.currentPosition),
        zoom: DEFAULT_ZOOM_LEVEL,
      );
      yield MapDataLoaded(tournamentToView, _buildMarkerDataFrom(mapDataToView), initialCamera);
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
      var tourneyName = tournamentToView.name;
      print('new selected tournament: $tourneyName');
      yield MapDataLoaded(tournamentToView, _buildMarkerDataFrom(mapDataToView));
    }
  }

  Set<Marker> _buildMarkerDataFrom(MapData mapData) {
    var markerData = Set<Marker>();
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

  _launchURL(String slug) async {
    final url = _buildURL(slug);
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _buildURL(String slug) => 'http://smash.gg/' + slug;

  @override
  void dispose() {
    _currentPosition.cancel();
    super.dispose();
  }

}
