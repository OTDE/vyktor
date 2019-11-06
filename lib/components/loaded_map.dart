import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/blocs.dart';
import '../models/map_model.dart';
import '../services/services.dart';

class LoadedMap extends StatefulWidget {

  const LoadedMap();

  @override
  _LoadedMapState createState() => _LoadedMapState();
}

class _LoadedMapState extends State<LoadedMap> {

  /// A future [GoogleMapController], to be completed [onMapCreated].
  GoogleMapController _mapController;

  /// The last recorded [CameraPosition] of this map.
  CameraPosition _lastRecordedPosition;

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final state = mapBloc.currentState as MapDataLoaded;
    return GoogleMap(
      mapToolbarEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition:
      _lastRecordedPosition ?? state.initialPosition,
      myLocationEnabled: true,
      // This is false by default.
      // This is just a reminder to keep it that way,
      // since it creates an extra FAB in iOS.
      myLocationButtonEnabled: false,
      onCameraMove: _onCameraMove,
      onMapCreated: (controller) {
        _onMapCreated(controller, state);
      },
      onLongPress: (pressLocation) async {
        _onLongPress(pressLocation, mapBloc);
      },
      markers: _buildMarkerDataFrom(mapBloc, state),
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
    );
  }

  /// Updates [_lastRecordedPosition] when the camera moves to a new [position].
  void _onCameraMove(CameraPosition position) {
    _lastRecordedPosition = position;
  }

  void _onMapCreated(GoogleMapController controller, MapDataLoaded state) {
    _mapController = controller;
    _lastRecordedPosition ??= state.initialPosition;
  }

  Future<void> _onLongPress(LatLng pressLocation, MapBloc mapBloc) async {
    var exploreModeEnabled = await Settings().getExploreMode();
    if (exploreModeEnabled) {
      Loading().isNow(true);
      mapBloc.dispatch(RefreshMarkerData(Position(
          latitude: pressLocation.latitude,
          longitude: pressLocation.longitude)));
    }
  }

  /// Creates markers with attributes and fields pulled from [mapData].
  ///
  /// If [selectedTournament] is included in the arguments, adds it to the list
  /// of [Markers] to send to the [GoogleMap] widget. Each [onTap] callback
  /// triggers a [Bloc] event.
  Set<Marker> _buildMarkerDataFrom(MapBloc mapBloc, MapDataLoaded state) {
    final mapData = state.mapData;
    final selectedTournament = state.selectedTournament;

    final isTabOpen = TabBehavior().panelSubject.value == SelectedPanel.tournament;
    final isAbsentFromMapData = !mapData.tournaments.contains(selectedTournament);
    final isNotNull = selectedTournament != null;
    final shouldAddToMarkerSet = isTabOpen && isAbsentFromMapData && isNotNull;
    if (shouldAddToMarkerSet) mapData.tournaments.add(selectedTournament);

    var markerData = Set<Marker>();
    for (Tournament tournament in mapData.tournaments) {
      final id = MarkerId(tournament.id.toString());
      final attendeeColor = _toMarkerHue(tournament.participants.pageInfo.total);
      final mapMarker = Marker(
        markerId: id,
        icon: BitmapDescriptor.defaultMarkerWithHue(attendeeColor),
        position: LatLng(tournament.lat, tournament.lng),
        onTap: () async {
          _onMarkerTap(id, tournament, mapBloc);
        },
      );
      markerData.add(mapMarker);
    }
    return markerData;
  }

  Future<void> _onMarkerTap(
      MarkerId id, Tournament tournament, MapBloc mapBloc) async {
    MapLocker().lock();
    mapBloc.dispatch(UpdateSelectedTournament(id));
    TabBehavior().setPanel(SelectedPanel.tournament);
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(tournament.lat - 0.09, tournament.lng), 11.0));
  }

  /// Uses a log function to plot the color of each marker.
  double _toMarkerHue(int attendeeCount) =>
      ((math.log((attendeeCount.toDouble() * 0.0025) + 0.013) * 38.0) + 163.0)
          .clamp(0.0, 270.0);
}
