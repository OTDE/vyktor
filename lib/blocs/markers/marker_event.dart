import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

/// The base class for receiving BLoC events.
@immutable
abstract class MarkerEvent extends Equatable {
  const MarkerEvent();

  @override
  List<Object> get props => [];
}

class RefreshMarkerData extends MarkerEvent {

  @override
  String toString() =>
      'Refreshing marker data at user location';
}

class FetchMarkersAt extends MarkerEvent {
  final Position position;

  const FetchMarkersAt([this.position]);

  @override
  List<Object> get props => [position];

  @override
  String toString() =>
      'Fetching marker data at ${position?.latitude ?? 'the same lat'}, ${position?.longitude ?? 'the same lng'}';
}