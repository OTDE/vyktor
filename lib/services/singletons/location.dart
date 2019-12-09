import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class PhoneLocation {

  final Stream<Position>_locationStream = Geolocator().getPositionStream(
    LocationOptions(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 1000
    ));

  static final _defaultPosition = Position(
      longitude: -122.5119,
      latitude: 47.1624,
  );

  static final PhoneLocation _location = PhoneLocation._internal();

  final lastKnownPosition = BehaviorSubject<Position>();

  PhoneLocation._internal();

  factory PhoneLocation() => _location;

  init() => _locationStream.listen((position) => lastKnownPosition.add(position));

  Position get location => lastKnownPosition.hasValue ? lastKnownPosition.value : _defaultPosition;

}