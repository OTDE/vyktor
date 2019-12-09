import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/models.dart';
import '../../services/services.dart';
import 'markers.dart';

/// The [Bloc] that regulates the state of Vyktor's map data.
class MarkerBloc extends Bloc<MarkerEvent, MarkerState> {

  static final _geolocator = Geolocator();

  final Stream<Position>_locationStream = _geolocator.getPositionStream(
      LocationOptions(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 1000
      ));

  StreamSubscription<Position> _subscription;

  /// Initial state of the BLoC is loading the data. Will switch to [MarkerDataNotLoaded]
  /// on failure and [MarkerDataLoaded] on success.
  @override
  MarkerState get initialState => MarkerDataLoading();

  /// On constructing this BLoC, it listens to a stream of the phone's position, and
  /// then fires a [RefreshMarkerData] event when it receives new data.
  MarkerBloc() {
    _geolocator.getCurrentPosition().then((position) {
      this.add(RefreshMarkerData(position));
    });
    _subscription = _locationStream.listen((position) {
      this.add(RefreshMarkerData(position));
    });
  }

  /// On receiving an event, pushes a new state, depending on event type.
  @override
  Stream<MarkerState> mapEventToState(MarkerEvent event) async* {
      yield* _mapRefreshMarkerDataToState(state, event);
  }

  /// Uses input from the [RefreshMarkerData] event to stream [MapData].
  Stream<MarkerState> _mapRefreshMarkerDataToState(
      MarkerState state, RefreshMarkerData event) async* {
    Loading().isNow(true);
    try {
      final position = event.position;
      await TournamentClient().refreshMarkerData(position);
      final markerData = TournamentModel().tournaments;
      Loading().isNow(false);
      yield MarkerDataLoaded(
          markerData,
          initialPosition: CameraPosition(
            target: LatLng(
              position.latitude, position.longitude
            ),
            zoom: 10.0,
          ));
    } catch(_) {
      Loading().isNow(false);
      yield MarkerDataNotLoaded();
    }
  }

  /// Gotta have one of these so we can dispose of the subscription if necessary.
  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
