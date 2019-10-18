import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

/// Base class for every map state in this BLoC.
@immutable
abstract class MapState extends Equatable {
  MapState([List props = const []]) : super(props);
}

/// The state of the BLoC when [MapData] is loading.
///
/// Default state before any data is loaded.
class MapDataLoading extends MapState {
  @override
  String toString() => 'Map data loading';
}

/// The state of the BLoC when all the [MapData] is loaded.
///
/// The [mapData] and [selectedTournament] are always used by this state,
/// while the [initialPosition] is only used when the app is first started,
/// so that the map loads a [CameraPosition] centered around the user's location.
class MapDataLoaded extends MapState {
  /// The [MapData] to be sent to the [GoogleMap] instance.
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
  String toString() => 'Map data loaded';
}

/// If this state is loaded, the BLoC has thrown some kind of exception.
///
/// UI should allow the user an exit from this state.
class MapDataNotLoaded extends MapState {
  @override
  String toString() => 'Map data not loaded';
}
