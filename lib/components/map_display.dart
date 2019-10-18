import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../blocs/blocs.dart';
import '../models/map_model.dart';
import '../services/services.dart';

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
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return BlocBuilder<MapBloc, MapState>(builder: (context, state) {
      if (state is MapDataLoaded) {
        Future.delayed(Duration(milliseconds: 1200), () => Loading().isNow(false));
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
                Loading().isNow(true);
                mapBloc.dispatch(RefreshMarkerData(Position(
                    latitude: pressLocation.latitude,
                    longitude: pressLocation.longitude)));
              } else {
                return;
              }
            },
            markers: _buildMarkerDataFrom(state.mapData,
                state.selectedTournament, mapBloc, state),
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: state.isMapUnlocked ?? true,
            scrollGesturesEnabled: state.isMapUnlocked ?? true,
            zoomGesturesEnabled: state.isMapUnlocked ?? true,
          ),
        );
      } else if (state is MapDataNotLoaded) {
        return Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 24),
                Container(
                  height: 200,
                  child: Image.asset('assets/images/in-app/mobile_logo_transparent.png'),
                ),
                Spacer(flex: 2),
                Text(
                  'Couldn\'t load map data.\nTry again.',
                  style: Theme.of(context).primaryTextTheme.headline,
                  textAlign: TextAlign.center,
                ),
                Spacer(flex: 2),
                RaisedButton(
                  child: Text(
                    'Refresh',
                    style: Theme.of(context).primaryTextTheme.button,
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  textColor: Theme.of(context).colorScheme.onSurface,
                  onPressed: () async {
                    var currentPosition =
                        await Geolocator().getCurrentPosition();
                    mapBloc.dispatch(RefreshMarkerData(currentPosition));
                  },
                ),
                Spacer(flex: 20),
              ],
            ),
          ),
        );
      }
      Loading().isNow(true);
      return Container(
        color: Theme.of(context).primaryColor,
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
      MapBloc mapBloc,
      MapDataLoaded state) {
    var markerData = Set<Marker>();
    if (selectedTournament != null) {
      if (!mapData.tournaments.contains(selectedTournament))
        mapData.tournaments.add(selectedTournament);
    }
    for (Tournament tournament in mapData.tournaments) {
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
          mapBloc.dispatch(UpdateSelectedTournament(id));
          mapBloc.dispatch(LockMap());
          TabBehavior().setPanel(SelectedPanel.tournament);
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
