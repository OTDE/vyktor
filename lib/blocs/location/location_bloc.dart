import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:meta/meta.dart';


import 'location.dart';
import'../blocs.dart';


class LocationBloc extends Bloc<LocationEvent, LocationState> {

  @override
  LocationState get initialState => LocationLoading();

  static final _geolocator = Geolocator();
  static final _options = LocationOptions(accuracy: LocationAccuracy.medium, distanceFilter: 1000);
  final Stream<Position>_positionStream = _geolocator.getPositionStream(_options);
  StreamSubscription _positionStreamSubscription;

  final PermissionBloc permissionBloc;
  StreamSubscription _permissionBlocSubscription;

  LocationBloc({@required this.permissionBloc}) {
    _permissionBlocSubscription = permissionBloc.listen((permissionState) {
      if (permissionState == PermissionStatus.granted) {
        this.add(RefreshLocationOnce());
        _positionStreamSubscription = _positionStream.listen((position) {
          this.add(UpdateLocationFromStream(position: position));
        });
      } else {
        this.add(DenyLocationAccess());
      }
    });
  }

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (permissionBloc.state != PermissionStatus.granted) {
      permissionBloc.add(RequestLocationPermissions());
      yield LocationNotLoaded();
    } else if (event is RefreshLocationOnce) {
      yield* _mapRefreshLocationOnceToState(state, event);
    } else if (event is UpdateLocationFromStream) {
      yield* _mapUpdateLocationFromStreamToState(state, event);
    } else if (event is DenyLocationAccess) {
      yield LocationNotLoaded();
    }
  }

  Stream<LocationState> _mapRefreshLocationOnceToState(
      LocationState state, RefreshLocationOnce event
      ) async* {
    final position = await _geolocator.getCurrentPosition();
    yield LocationLoaded(position: position);
  }

  Stream<LocationState> _mapUpdateLocationFromStreamToState(
      LocationState state, UpdateLocationFromStream event
      ) async* {
    yield LocationLoaded(position: event.position);
  }

  @override
  Future<void> close() async {
    _positionStreamSubscription.cancel();
    _permissionBlocSubscription.cancel();
    super.close();
  }

}