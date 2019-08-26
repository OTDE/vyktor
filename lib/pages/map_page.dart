import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:vyktor/blocs/map/map_data_barrel.dart';

/// The page containing the map.
///
/// (and, honestly, most of the other stuff too.)
class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

/// The state of the [MapPage].
///
/// Uses a [_controller], which currently isn't being used,
/// since the map is listening to state changes in the BLoC.
/// [_geolocator] allows the [FloatingActionButton] to get
/// the phone's current location. The map also keeps track
/// of the [_lastRecordedPosition], so that marker updates
/// don't force the map to reload at the user location,
/// instead of wherever the map's camera previously was.
class MapPageState extends State<MapPage> {
  /// A future [GoogleMapController], to be completed [onMapCreated].
  Completer<GoogleMapController> _controller = Completer();

  /// A geolocation facilitator. Allows the refresh button to [getCurrentPosition].
  Geolocator _geolocator = Geolocator();

  /// The last recorded [CameraPosition] of this map.
  CameraPosition _lastRecordedPosition;

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    return BlocBuilder<MapDataBloc, MapDataState>(builder: (context, state) {
      if (state is MapDataLoaded) {
        return SafeArea(
            child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition:
                  _lastRecordedPosition ?? state.initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMove: _onCameraMove,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _lastRecordedPosition ??= state.initialPosition;
              },
              markers: state.mapMarkers,
            ),
            Align(
                alignment: Alignment(0.95, 0.8),
                child: FloatingActionButton(
                  child: Icon(Icons.refresh),
                  onPressed: () async {
                    var currentPosition =
                        await _geolocator.getCurrentPosition();
                    mapBloc.dispatch(RefreshMarkerData(currentPosition));
                  },
                )),
          ],
        ));
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
