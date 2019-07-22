import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vyktor/models/map_data.dart';

@immutable
abstract class MapState extends Equatable {
  MapState([List props = const []]) : super(props);
}

class InitialMapState extends MapState {}

class MapDataLoading extends MapState {}

class MapDataLoaded extends MapState {
  final MapData mapData;

  MapDataLoaded(this.mapData) : super([mapData]);
}

class MapDataNotLoaded extends MapState {}