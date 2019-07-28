import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
abstract class MapDataEvent extends Equatable {
  MapDataEvent([List props = const []]) : super(props);
}

class InitializeMapData extends MapDataEvent {
  final Position currentPosition;

  InitializeMapData(this.currentPosition) : super([currentPosition]);

  @override
  String toString() => 'Event triggered: initial map state.';
}

class RefreshMapData extends MapDataEvent {
  final Position currentPosition;

  RefreshMapData(this.currentPosition) : super([currentPosition]);

  @override
  String toString() => 'Event triggered: refreshing map data.';
}

class UpdateSelectedTournament extends MapDataEvent {
  final MarkerId markerId;

  UpdateSelectedTournament(this.markerId) : super([markerId]);

  @override
  String toString() => 'Event triggered: update selected tournament to id $markerId';
}