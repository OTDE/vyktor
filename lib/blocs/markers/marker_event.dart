import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

/// The base class for receiving BLoC events.
@immutable
abstract class MarkerEvent extends Equatable {
  const MarkerEvent();

  @override
  List<Object> get props => [];
}

/// Refreshes the set of [Marker] widgets to be displayed on-screen.
class RefreshMarkerData extends MarkerEvent {
  /// In Explore Mode, wherever the user tapped on the map.
  /// Otherwise, the phones's current location.
  final Position position;

  const RefreshMarkerData([this.position]);

  @override
  List<Object> get props => [position];

  @override
  String toString() =>
      'Refreshing marker data at ${position?.latitude ?? 'the same lat'}, ${position?.longitude ?? 'the same lng'}';
}
