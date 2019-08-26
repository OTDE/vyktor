import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:vyktor/blocs/delegate.dart';
import 'package:vyktor/blocs/map/map_data_barrel.dart';

import 'map_page.dart';
import 'permissions_page.dart';

/// The homepage of the app.
///
/// More of a hub for getting things set up than anything else.
/// Once location permissions are given, the user probably won't
/// see the opening screen ever again.
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

/// The state of the [HomePage].
///
/// On [initState], checks the phone's permissions,
/// and computes if the app [_hasLocationPermissions].
class HomePageState extends State<HomePage> {
  /// An indicator of if the app is allowed to track the phone's location.
  bool _hasLocationPermissions = false;

  @override
  initState() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location)
        .then((PermissionStatus status) {
      setState(() {
        _hasLocationPermissions = status == PermissionStatus.granted;
      });
    });
    super.initState();
  }

  /// Callback function to send to the [PermissionsPage] child widget.
  permissionsCallback() async {
    setState(() {
      _hasLocationPermissions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  /// Builds the [body] of the [Scaffold] widget.
  ///
  /// The widget returned depends on if the app [_hasLocationPermissions].
  /// If it does, the child is a [MapPage] receiving information from a
  /// [MapDataBloc] through a [BlocProvider]. Otherwise, the child is a
  /// [PermissionsPage] with a [permissionsCallback] for receiving information.
  Widget _buildBody() {
    if (_hasLocationPermissions) {
      BlocSupervisor.delegate = MapBlocDelegate();
      return BlocProvider(
        builder: (context) => MapDataBloc(),
        child: MapPage(),
      );
    }
    return PermissionsPage(enableLocation: permissionsCallback);
  }
}
