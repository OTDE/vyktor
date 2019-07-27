import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

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
      ),
    );
  }

  ///TODO: REBUILD ONCE BLOC CONNECTS TO THIS
  // void _buildMarkerSet() {
  //    for (Tournament tournament in _mapData.tournaments) {
  //      MarkerId key = MarkerId(tournament.id.toString());
  //      Marker value = Marker(
  //          markerId: key,
  //          position: LatLng(tournament.lat, tournament.lng),
  //          infoWindow: InfoWindow(
  //            title: tournament.name,
  //            snippet: tournament.venueAddress,
  //          ),
  //          onTap: () {
  //            _onMarkerTapped(key);
  //          }
  //      );
  //      // markers.putIfAbsent(key, () => value);
  //    }
  //    setState(() {
  //
  //    });
  //  }



  // void _onMarkerTapped(MarkerId id) {}

}