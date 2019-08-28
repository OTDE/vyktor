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

/// The initial state of the BLoC, before any [MapData] loads.
///
/// This state is represented in the UI layer as a loading animation.
/// Perhaps replacing it with [MapDataLoading] could work?
///
/// TODO: rework this in conjunction with [MapDataLoading].
class InitialMapDataState extends MapDataState {
  @override
  String toString() => 'Initial map data state';
}

/// The state of the BLoC when [MapData] is loading.
///
/// This is possibly not needed. Built this out of boilerplate
/// when learning how to make BLoCs and haven't really touched it
/// (or used it, really) since.
///
/// TODO: consider reworking this state.
class MapDataLoading extends MapDataState {
  @override
  String toString() => 'Map data loading...';
}

/// The state of the BLoC when all the [MapData] is loaded.
///
/// The [mapMarkers] and [selectedTournament] are always used by this state,
/// while the [initialPosition] is only used when the app is first started,
/// so that the map loads a [CameraPosition] centered around the user's location.
class MapDataLoaded extends MapDataState {
  /// The markers that will be applied to the [GoogleMap] widget's [markers] field.
  final Set<Marker> mapMarkers;

  /// The [Tournament] currently selected by the user.
  final Tournament selectedTournament;

  /// The [CameraPosition] used for the first build of the [GoogleMap] widget.
  final CameraPosition initialPosition;

  /// If the [GoogleMap] is locked.
  final bool isMapUnlocked;

  MapDataLoaded(this.selectedTournament, this.mapMarkers,
  {this.initialPosition, this.isMapUnlocked})
      : super([selectedTournament, mapMarkers, initialPosition, isMapUnlocked]);

  @override
  String toString() => 'Map data loaded.';
}

/// If this state is loaded, something's fishy.
///
/// TODO: build display widget for this state, in case something DOES happen.
class MapDataNotLoaded extends MapDataState {
  @override
  String toString() => 'Map data not loaded.';
}
