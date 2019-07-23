import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vyktor/models/map_data.dart';

/// TODO:
/// Markers
/// Map Model
/// Location
class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  MapDataProvider _provider = MapDataProvider();
  MapData _mapData;

  @override
  void initState() {
    _provider.getCurrentMapData().then((mapData) {
      _initializeData(mapData);
      print(mapData.toString());
    });

    super.initState();
  }

  static final CameraPosition _testSocalPosition = CameraPosition(
    target: LatLng(33.7454725,-117.86765300000002),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _testSocalPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }

  void _initializeData(MapData mapData) {
    _mapData = mapData;
    _buildMarkerSet();
  }

  void _buildMarkerSet() {
    for (Tournament tournament in _mapData.tournaments) {
      MarkerId key = MarkerId(tournament.id.toString());
      Marker value = Marker(
          markerId: key,
          position: LatLng(tournament.lat, tournament.lng),
          infoWindow: InfoWindow(
            title: tournament.name,
            snippet: tournament.venueAddress,
          ),
          onTap: () {
            _onMarkerTapped(key);
          }
      );
      markers.putIfAbsent(key, () => value);
    }
  }

  void _onMarkerTapped(MarkerId id) {

  }

}