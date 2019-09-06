import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../blocs/delegate.dart';
import '../blocs/blocs.dart';
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
  _HomePageState createState() => _HomePageState();
}

/// On [initState], checks the phone's permissions, and computes if the app [_hasLocationPermissions].
class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_hasLocationPermissions) {
      BlocSupervisor.delegate = BasicBlocDelegate();
      return MultiBlocProvider(
        providers: [
          BlocProvider<MapBloc>(
            builder: (context) => MapBloc(),
          ),
          BlocProvider<AnimatorBloc>(
            builder: (context) => AnimatorBloc(),
          ),
        ],
        child: MapPage(),
      );
    }
    return PermissionsPage(onLocationEnabled: loadMapPage);
  }

  loadMapPage() async {
    setState(() {
      _hasLocationPermissions = true;
    });
  }
}
