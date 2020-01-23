import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:geolocator/geolocator.dart';

@immutable
abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class RefreshLocationOnce extends LocationEvent {
  @override
  String toString() => 'Refreshing location';
}

class UpdateLocationFromStream extends LocationEvent {

  final Position position;

  const UpdateLocationFromStream({@required this.position});

  @override
  String toString() => 'Updating location: ${position.latitude}, ${position.longitude}';
}

class DenyLocationAccess extends LocationEvent {
  @override
  String toString() => 'Denying location access';
}