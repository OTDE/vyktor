import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

/// The blueprint for any kind of event this BLoC could receive.
@immutable
abstract class MapDataEvent extends Equatable {
  MapDataEvent([List props = const []]) : super(props);
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

  UpdateSelectedTournament([this.markerId]) : super([markerId]);

  @override
  String toString() =>
      'Event triggered: update selected tournament to id $markerId';
}


/// Resumes the [Position] stream in the BLoC.
class EnableLocationListening extends MapDataEvent {

  EnableLocationListening(): super();

  @override
  String toString() =>
      'Event triggered: toggled listening to phone\'s location';
}

/// Pauses the [Position] stream in the BLoC.
class DisableLocationListening extends MapDataEvent {

  DisableLocationListening(): super();

  @override
  String toString() =>
      'Event triggered: toggled listening to phone\'s location';
}


/// Toggles if the [GoogleMap] instance is locked.
class ToggleMapLocking extends MapDataEvent {

  ToggleMapLocking(): super();

  @override
  String toString() =>
      'Event triggered: toggled map locking.';
}

/// Toggles if the [GoogleMap] instance is locked.
class LockMap extends MapDataEvent {

  LockMap(): super();

  @override
  String toString() =>
      'Event triggered: locking map.';
}

/// Toggles if the [GoogleMap] instance is locked.
class UnlockMap extends MapDataEvent {

  UnlockMap(): super();

  @override
  String toString() =>
      'Event triggered: unlocking map.';
}