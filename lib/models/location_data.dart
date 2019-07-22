import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationData {

  /// Converts a [geolocatorStream] into a stream that outputs LatLng values.
  Stream<LatLng> getLocationStream(Stream<Position> geolocatorStream) async* {
    await for(Position position in geolocatorStream) {
      yield LatLng(position.latitude, position.longitude);
    }
  }

}

