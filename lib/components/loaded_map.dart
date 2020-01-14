import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
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
    final state = BlocProvider.of<MarkerBloc>(context).state as MarkerDataLoaded;
    return GoogleMap(
      mapToolbarEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition:
      _lastRecordedPosition ?? state.initialPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onCameraMove: _onCameraMove,
      onMapCreated: (controller) {
        _onMapCreated(controller, state);
      },
      onLongPress: (pressLocation) async {
        _onLongPress(pressLocation, context);
      },
      markers: _buildMarkerDataFrom(context, state),
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

  void _onMapCreated(GoogleMapController controller, MarkerDataLoaded state) {
    _mapController = controller;
    _lastRecordedPosition ??= state.initialPosition;
  }

  Future<void> _onLongPress(LatLng pressLocation, BuildContext context) async {
    var exploreModeEnabled = await Settings().getExploreMode();
    if (exploreModeEnabled) {
      Loading().isNow(true);
      BlocProvider.of<MarkerBloc>(context).add(RefreshMarkerData(Position(
          latitude: pressLocation.latitude,
          longitude: pressLocation.longitude)));
    }
  }

  /// Creates markers with attributes and fields pulled from [markerData].
  ///
  /// If [selectedTournament] is included in the arguments, adds it to the list
  /// of [Markers] to send to the [GoogleMap] widget. Each [onTap] callback
  /// triggers a [Bloc] event.
  Set<Marker> _buildMarkerDataFrom(BuildContext context, MarkerDataLoaded state) {
    final mapData = state.markerData;
    var markerData = Set<Marker>();
    for (Tournament tournament in mapData) {
      final id = MarkerId(tournament.id.toString());
      final attendeeColor = _toMarkerHue(tournament.participants.pageInfo.total);
      final mapMarker = Marker(
        markerId: id,
        icon: BitmapDescriptor.defaultMarkerWithHue(attendeeColor),
        position: LatLng(tournament.lat, tournament.lng),
        onTap: () async {
          _onMarkerTap(tournament.id, tournament, context);
        },
      );
      markerData.add(mapMarker);
    }
    return markerData;
  }

  Future<void> _onMarkerTap(
      int id, Tournament tournament, BuildContext context) async {
    BlocProvider.of<TournamentBloc>(context).add(SelectTournament(id));
    BlocProvider.of<PanelSelectorBloc>(context).add(SelectPanel(panel: SelectedPanel.tournament));
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(tournament.lat - 0.09, tournament.lng), 11.0));
  }

  /// Uses a log function to plot the color of each marker.
  double _toMarkerHue(int attendeeCount) =>
      ((math.log((attendeeCount.toDouble() * 0.0025) + 0.013) * 38.0) + 163.0)
          .clamp(0.0, 270.0);
}
