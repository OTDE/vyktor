import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
abstract class MapDataEvent extends Equatable {
  MapDataEvent([List props = const []]) : super(props);
}

class InitializeMap extends MapDataEvent {
  final Position initialPosition;

  InitializeMap(this.initialPosition) : super([initialPosition]);

  @override
  String toString() => 'Event triggered: initial map state.';
}

class RefreshMarkerData extends MapDataEvent {
  final Position currentPosition;

  RefreshMarkerData(this.currentPosition) : super([currentPosition]);

  @override
  String toString() => 'Event triggered: refreshing map data.';
}


class UpdateSelectedTournament extends MapDataEvent {
  final MarkerId markerId;

  UpdateSelectedTournament(this.markerId) : super([markerId]);

  @override
  String toString() => 'Event triggered: update selected tournament to id $markerId';
}