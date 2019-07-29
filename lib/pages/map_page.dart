import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/map/map_data_barrel.dart';
import 'package:vyktor/models/map_data.dart';
import 'package:geolocator/geolocator.dart';

/// TODO:
/// Connecting up the BLOC
/// StreamBuilder with current position
class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    var geolocator = Geolocator();
    geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((position) {
        _initialPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 10,
        );
        setState(() {});
      }
    );

    super.initState();
  }

  static final CameraPosition _testSocalPosition = CameraPosition(
    target: LatLng(33.7454725,-117.86765300000002),
    zoom: 10,
  );

  CameraPosition _initialPosition;

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    return BlocBuilder<MapDataBloc, MapDataState>(
        builder: (context, state) {
          if (state is MapDataLoaded) {
            return GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMove: (CameraPosition position) {

              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: state.mapMarkers,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }

}
