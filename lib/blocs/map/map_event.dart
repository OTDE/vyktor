import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

/// The base class for receiving BLoC events.
@immutable
abstract class MapEvent extends Equatable {
  MapEvent([List props = const []]) : super(props);
}

/// Refreshes the set of [Marker] widgets to be displayed on-screen.
class RefreshMarkerData extends MapEvent {
  /// In Explore Mode, wherever the user tapped on the map.
  /// Otherwise, the phones's current location.
  final Position currentPosition;

  RefreshMarkerData(this.currentPosition) : super([currentPosition]);

  @override
  String toString() =>
      'Event triggered: refreshing map data at ${currentPosition.latitude}, ${currentPosition.longitude}';
}

/// Given a [markerId], sets the MapData's selected tournament.
///
/// The optional parameter is intentional. This allows the frontend to
/// tell the BLoC when the user isn't selecting any tournament.
class UpdateSelectedTournament extends MapEvent {
  /// The [MarkerId] of the [Marker] whose tournament data this event will select.
  final MarkerId markerId;

  UpdateSelectedTournament([this.markerId]) : super([markerId]);

  @override
  String toString() =>
      'Event triggered: update selected tournament to id $markerId';
}

/// Pauses the [Position] stream in the BLoC.
class DisableLocationListening extends MapEvent {
  DisableLocationListening() : super();

  @override
  String toString() =>
      'Event triggered: disabled listening to phone\'s location';
}

/// Resumes the [Position] stream in the BLoC.
class EnableLocationListening extends MapEvent {
  EnableLocationListening() : super();

  @override
  String toString() =>
      'Event triggered: enabled listening to phone\'s location';
}

/// Locks the [GoogleMap].
class LockMap extends MapEvent {
  LockMap() : super();

  @override
  String toString() => 'Event triggered: locking map';
}

/// Unlocks the [GoogleMap].
class UnlockMap extends MapEvent {
  UnlockMap() : super();

  @override
  String toString() => 'Event triggered: unlocking map';
}
