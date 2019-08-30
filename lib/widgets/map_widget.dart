import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:vyktor/models/map_data.dart';
import 'package:vyktor/blocs/blocs.dart';

/// The page containing the map.
///
/// (and, honestly, most of the other stuff too.)
/// TODO: separate out the map, formatting, and setting widgets.
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
            initialCameraPosition: _lastRecordedPosition ?? state.initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onCameraMove: _onCameraMove,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _lastRecordedPosition ??= state.initialPosition;
            },
            markers: _buildMarkerDataFrom(state.mapData, state.selectedTournament,
                mapBloc, state, animBloc),
            rotateGesturesEnabled: state.isMapUnlocked ?? true,
            tiltGesturesEnabled: state.isMapUnlocked ?? true,
            scrollGesturesEnabled: state.isMapUnlocked ?? true,
            zoomGesturesEnabled: state.isMapUnlocked ?? true,
            gestureRecognizers: state.isMapUnlocked
                ? <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
              ),
            ].toSet()
                : null,
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
          Tournament prev = state.selectedTournament;
            mapBloc.dispatch(UpdateSelectedTournament(id));
            _mapController.animateCamera(CameraUpdate.newLatLngZoom(
                LatLng(tournament.lat - 0.069, tournament.lng), 11.0));
            if(prev.id == tournament.id) { //Same marker, deselect
              animBloc.dispatch(DeselectAll());
            }
          animBloc.dispatch(SelectTournament(id)); // Lock and load
          mapBloc.dispatch(LockMap());
          _selectingTournament = false;
        },
      );
      markerData.add(mapMarker);
    }
    return markerData;
  }

  String _toDate(int timestamp) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    return '${date.month}/${date.day}/${date.year} — ${date.hour % 12}:'
        '${(int minute) {
      return minute < 10 ? '0$minute' : '$minute';
    }(date.minute)} '
        '${(int hour) {
      return hour > 12 ? 'PM' : 'AM';
    }(date.hour)}';
  }

  double _toMarkerHue(int attendeeCount) =>
      attendeeCount.clamp(0, 270).toDouble();
}
