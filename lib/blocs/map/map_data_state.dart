import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vyktor/models/map_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
abstract class MapDataState extends Equatable {
  MapDataState([List props = const []]) : super(props);
}

class InitialMapDataState extends MapDataState {
  @override
  String toString() => 'Initial map data state';
}

class MapDataLoading extends MapDataState {
  @override
  String toString() => 'Map data loading...';
}

class MapDataLoaded extends MapDataState {
  final Set<Marker> mapMarkers;
  final Tournament selectedTournament;
  final CameraPosition initialPosition;

  MapDataLoaded(this.selectedTournament, [this.mapMarkers, this.initialPosition])
      : super([selectedTournament, mapMarkers, initialPosition]);

  @override
  String toString() => 'Map data loaded.';
}

class MapDataNotLoaded extends MapDataState {
  @override
  String toString() => 'Map data not loaded.';
}