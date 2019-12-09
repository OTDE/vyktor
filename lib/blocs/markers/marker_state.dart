import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

/// Base class for every map state in this BLoC.
@immutable
abstract class MarkerState extends Equatable {
  const MarkerState();

  @override
  List<Object> get props => [];
}


class MarkerDataLoading extends MarkerState {
  @override
  String toString() => 'Marker data loading';
}


class MarkerDataLoaded extends MarkerState {
  /// The [MapData] to be sent to the [GoogleMap] instance.
  final List<Tournament> markerData;

  /// The [CameraPosition] used for the first build of the [GoogleMap] widget.
  final CameraPosition initialPosition;

  const MarkerDataLoaded(this.markerData, {this.initialPosition});

  @override
  List<Object> get props => [markerData, initialPosition];

  @override
  String toString() => 'Marker data loaded';
}

/// If this state is loaded, the BLoC has thrown some kind of exception.
///
/// UI should allow the user an exit from this state.
class MarkerDataNotLoaded extends MarkerState {
  @override
  String toString() => 'Marker data not loaded';
}
