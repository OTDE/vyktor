import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

/// This file contains utility functions and variables related to the following:
///
/// google_maps_flutter:
/// [CameraPosition]
/// [LatLng]
///
/// geolocator:
/// [Position]

/// The default zoom level of the application.
const double DEFAULT_ZOOM_LEVEL = 10.0;

/// Converts [target] to a Geolocator [Position].
Position latLngToPosition(LatLng target) =>
    Position(latitude: target.latitude, longitude: target.longitude);

/// Converts [position] to a Google Maps [LatLng].
LatLng positionToLatLng(Position position) =>
    LatLng(position.latitude, position.longitude);

/// Converts [position] to a Google Maps [CameraPosition].
///
/// Uses [zoom] level if supplied, defaults to [DEFAULT_ZOOM_LEVEL] otherwise.
CameraPosition buildFromPosition(Position position,
        {double zoom = DEFAULT_ZOOM_LEVEL}) =>
    CameraPosition(target: positionToLatLng(position), zoom: zoom);
