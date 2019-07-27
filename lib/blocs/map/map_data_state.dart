import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vyktor/models/map/map_data.dart';

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
  final MapData mapData;
  final Tournament selectedTournament;

  MapDataLoaded(this.mapData, this.selectedTournament)
      : super([mapData, selectedTournament]);

  @override
  String toString() => 'Map data loaded.';
}

class MapDataNotLoaded extends MapDataState {
  @override
  String toString() => 'Map data not loaded.';
}