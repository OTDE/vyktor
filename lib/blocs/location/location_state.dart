import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:geolocator/geolocator.dart';

@immutable
abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationLoading extends LocationState {
  @override
  String toString() => 'Location loading';
}

class LocationNotLoaded extends LocationState {
  @override
  String toString() => 'Location access denied';
}

class LocationLoaded extends LocationState {

  final Position position;

  const LocationLoaded({@required this.position});

  @override
  String toString() => 'Location given at ${position.latitude}, ${position.longitude}';
}