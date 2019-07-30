import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/blocs/map/map_data_barrel.dart';
import 'package:geolocator/geolocator.dart';


class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Geolocator _geolocator = Geolocator();

  static final CameraPosition _testSocalPosition = CameraPosition(
    target: LatLng(33.7454725, -117.86765300000002),
    zoom: 10,
  );

  CameraPosition _initialPosition;
  CameraPosition _lastRecordedPosition;

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    return BlocBuilder<MapDataBloc, MapDataState>(builder: (context, state) {
      if (state is MapDataLoaded) {
        return Stack(
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

  void _onCameraMove(CameraPosition position) {
    _lastRecordedPosition = position;
  }
}
