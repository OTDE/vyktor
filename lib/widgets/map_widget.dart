import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:vyktor/models/map_data.dart';
import 'package:vyktor/models/settings_data.dart';
import 'package:vyktor/blocs/blocs.dart';

/// The page containing the map and its associated data.
class VyktorMap extends StatefulWidget {
  VyktorMap({Key key}) : super(key: key);

  @override
  State<VyktorMap> createState() => VyktorMapState();
}

/// The state of the [VyktorMap].
///
/// Uses a [_controller], which currently isn't being used,
/// since the map is listening to state changes in the BLoC.
/// [_geolocator] allows the [FloatingActionButton] to get
/// the phone's current location. The map also keeps track
/// of the [_lastRecordedPosition], so that marker updates
/// don't force the map to reload at the user location,
/// instead of wherever the map's camera previously was.
class VyktorMapState extends State<VyktorMap> {
  /// A future [GoogleMapController], to be completed [onMapCreated].
  GoogleMapController _mapController;

  /// A geolocation facilitator. Allows the refresh button to [getCurrentPosition].
  Geolocator _geolocator = Geolocator();

  /// The last recorded [CameraPosition] of this map.
  CameraPosition _lastRecordedPosition;

  bool _selectingTournament = false;

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    final animBloc = BlocProvider.of<AnimatorBloc>(context);
    return BlocBuilder<MapDataBloc, MapDataState>(builder: (context, state) {
      if (state is MapDataLoaded) {
        return IgnorePointer(
          ignoring: !state.isMapUnlocked,
          child: GoogleMap(
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
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _lastRecordedPosition ??= state.initialPosition;
            },
            onLongPress: (pressLocation) async {
              var exploreModeEnabled = await Settings().getExploreMode();
              if (exploreModeEnabled) {
                mapBloc.dispatch(RefreshMarkerData(Position(
                    latitude: pressLocation.latitude,
                    longitude: pressLocation.longitude)));
              } else {
                return;
              }
            },
            markers: _buildMarkerDataFrom(state.mapData,
                state.selectedTournament, mapBloc, state, animBloc),
            rotateGesturesEnabled: state.isMapUnlocked ?? true,
            tiltGesturesEnabled: state.isMapUnlocked ?? true,
            scrollGesturesEnabled: state.isMapUnlocked ?? true,
            zoomGesturesEnabled: state.isMapUnlocked ?? true,
          ),
        );
      }
      return Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).canvasColor,
          ),
        ),
      );
    });
  }

  /// Updates [_lastRecordedPosition] when the camera moves to a new [position].
  void _onCameraMove(CameraPosition position) {
    _lastRecordedPosition = position;
  }

  /// Creates markers with attributes and fields pulled from [mapData].
  ///
  /// If [selectedTournament] is included in the arguments, adds it to the list
  /// of [Markers] to send to the [GoogleMap] widget. Each [onTap] callback
  /// triggers a [Bloc] event.
  Set<Marker> _buildMarkerDataFrom(
      MapData mapData,
      Tournament selectedTournament,
      MapDataBloc mapBloc,
      MapDataLoaded state,
      AnimatorBloc animBloc) {
    var markerData = Set<Marker>();
    if (selectedTournament != null) {
      if (!mapData.tournaments.contains(selectedTournament))
        mapData.tournaments.add(selectedTournament);
    }
    for (Tournament tournament in mapData.tournaments) {
      if (tournament.id == -1) continue;
      var id = MarkerId(tournament.id.toString());
      var attendeeColor = _toMarkerHue(tournament.participants.pageInfo.total);
      var mapMarker = Marker(
        markerId: id,
        icon: BitmapDescriptor.defaultMarkerWithHue(attendeeColor),
        position: LatLng(tournament.lat, tournament.lng),
        onTap: () async {
          if (_selectingTournament) {
            return;
          }
          _selectingTournament = true;
          mapBloc.dispatch(LockMap());
          mapBloc.dispatch(UpdateSelectedTournament(id));
          animBloc.dispatch(SelectTournament(id));
          _mapController.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(tournament.lat - 0.069, tournament.lng),
              11.0)); // Lock and load
          _selectingTournament = false;
        },
      );
      markerData.add(mapMarker);
    }
    return markerData;
  }

  /// Uses a log function to plot the color of each marker.
  double _toMarkerHue(int attendeeCount) =>
      ((math.log((attendeeCount.toDouble() * 0.0025) + 0.013) * 38.0) + 163.0)
          .clamp(0.0, 270.0);
}
