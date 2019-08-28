import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:vyktor/blocs/map/map_data_barrel.dart';

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
  Completer<GoogleMapController> _controller = Completer();

  /// A geolocation facilitator. Allows the refresh button to [getCurrentPosition].
  Geolocator _geolocator = Geolocator();

  /// The last recorded [CameraPosition] of this map.
  CameraPosition _lastRecordedPosition;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapDataBloc, MapDataState>(builder: (context, state) {
      if (state is MapDataLoaded) {
        return GoogleMap(
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: _lastRecordedPosition ?? state.initialPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onCameraMove: _onCameraMove,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _lastRecordedPosition ??= state.initialPosition;
          },
          markers: state.mapMarkers,
          rotateGesturesEnabled: state.isMapUnlocked ?? true,
          tiltGesturesEnabled: state.isMapUnlocked ?? true,
          scrollGesturesEnabled: state.isMapUnlocked ?? true,
          zoomGesturesEnabled: state.isMapUnlocked ?? true,
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
}
