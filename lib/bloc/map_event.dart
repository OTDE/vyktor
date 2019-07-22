import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
abstract class MapEvent extends Equatable {
  MapEvent([List props = const []]) : super(props);
}


class FetchTournaments extends MapEvent {
  final LatLng location;
  final double radius;

  FetchTournaments(this.location, this.radius): super([location, radius]);
}

class UpdateTournaments extends MapEvent {
  final LatLng location;
  final double radius;

  UpdateTournaments(this.location, this.radius): super([location, radius]);
}