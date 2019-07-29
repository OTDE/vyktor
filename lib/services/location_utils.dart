import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

const double DEFAULT_ZOOM_LEVEL = 10.0;

Position latLngToPosition(LatLng target) => Position(latitude: target.latitude, longitude: target.longitude);

LatLng positionToLatLng(Position position) => LatLng(position.latitude, position.longitude);

CameraPosition buildfromPosition(Position position, {double zoom = DEFAULT_ZOOM_LEVEL})
  => CameraPosition(target: positionToLatLng(position), zoom: zoom);

