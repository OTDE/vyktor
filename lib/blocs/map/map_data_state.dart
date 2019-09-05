import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

import 'package:vyktor/models/map_data.dart';

/// The blueprint for all the states this BLoC can take on.\
///
/// Extending [Equatable] allows us to use "is" in conditionals.
@immutable
abstract class MapDataState extends Equatable {
  MapDataState([List props = const []]) : super(props);
}

/// The state of the BLoC when [MapData] is loading.
///
/// Default state before any data is loaded.
class MapDataLoading extends MapDataState {
  @override
  String toString() => 'Map data loading...';
}

/// The state of the BLoC when all the [MapData] is loaded.
///
/// The [mapData] and [selectedTournament] are always used by this state,
/// while the [initialPosition] is only used when the app is first started,
/// so that the map loads a [CameraPosition] centered around the user's location.
class MapDataLoaded extends MapDataState {
  /// The markers that will be applied to the [GoogleMap] widget's [markers] field.
  final MapData mapData;

  /// The [Tournament] currently selected by the user.
  final Tournament selectedTournament;

  /// The [CameraPosition] used for the first build of the [GoogleMap] widget.
  final CameraPosition initialPosition;

  /// If the [GoogleMap] is locked.
  final bool isMapUnlocked;

  MapDataLoaded(this.selectedTournament, this.mapData,
  {this.initialPosition, this.isMapUnlocked})
      : super([selectedTournament, mapData, initialPosition, isMapUnlocked]);

  @override
  String toString() => 'Map data loaded.';
}

/// If this state is loaded, something's fishy.
class MapDataNotLoaded extends MapDataState {
  @override
  String toString() => 'Map data not loaded.';
}
