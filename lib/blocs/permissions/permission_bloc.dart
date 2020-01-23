import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permissions.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionStatus> {
  @override
  PermissionStatus get initialState => PermissionStatus.denied;

  static final _permissionHandler = PermissionHandler();

  @override
  Stream<PermissionStatus> mapEventToState(PermissionEvent event) async* {
    if (event is RequestLocationPermissions) {
      yield* _mapRequestLocationPermissionsToState(event);
    } else {
      yield PermissionStatus.denied;
    }
  }

  Stream<PermissionStatus> _mapRequestLocationPermissionsToState(RequestLocationPermissions event) async* {
    final permissions = await _permissionHandler.requestPermissions([PermissionGroup.locationWhenInUse]);
    yield permissions[PermissionGroup.locationWhenInUse];
  }
}