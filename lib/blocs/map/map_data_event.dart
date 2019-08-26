import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

/// The blueprint for any kind of event this BLoC could receive.
@immutable
abstract class MapDataEvent extends Equatable {
  MapDataEvent([List props = const []]) : super(props);
}

/// The [MapDataEvent] for initializing the map.
///
/// Currently, this isn't in use. Again, boilerplate from learning how to
/// set one of these up. I don't think the current form this app is in
/// really requires it, either.
///
/// TODO: consider reworking this event or eliminating it entirely.
class InitializeMap extends MapDataEvent {
  /// The user's initial position. Used to create the map.
  ///
  /// (Or would, if it was used.)
  final Position initialPosition;

  InitializeMap(this.initialPosition) : super([initialPosition]);

  @override
  String toString() => 'Event triggered: initialize map state.';
}

/// Refreshes the set of [Marker] widgets to be displayed on-screen.
///
/// This event runs the show, really. Calls most of what makes this
/// app function. The UI dispatches this frequently. I have to always
/// pay attention to what this guy is doing.
class RefreshMarkerData extends MapDataEvent {
  /// The phone's current position.
  final Position currentPosition;

  RefreshMarkerData(this.currentPosition) : super([currentPosition]);

  @override
  String toString() => 'Event triggered: refreshing map data.';
}

/// Given a [markerId], sets the MapData's selected tournament.
///
/// Used for choosing which tournament to view additional data for.
/// In the future, will be used to build an info widget on tournament selection.
class UpdateSelectedTournament extends MapDataEvent {
  /// The [MarkerId] of the [Marker] whose tournament data this event will select.
  final MarkerId markerId;

  UpdateSelectedTournament(this.markerId) : super([markerId]);

  @override
  String toString() =>
      'Event triggered: update selected tournament to id $markerId';
}
