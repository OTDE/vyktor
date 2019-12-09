import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../blocs/delegate.dart';
import '../blocs/blocs.dart';
import '../services/services.dart';
import 'pages.dart';

/// The homepage of the app.
///
/// More of a hub for getting things set up than anything else.
/// Once location permissions are given, the user probably won't
/// see the opening screen ever again.
/// TODO: refactor background to avoid rebuilding container/stack.
class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

/// On [initState], checks the phone's permissions, and computes if the app [_hasLocationPermissions].
class _RootPageState extends State<RootPage> {
  /// An indicator of if the app is allowed to track the phone's location.
  bool _hasLocationPermissions;

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
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
          ),
          AnimatedSwitcher(
            duration: Duration(seconds: 2),
            switchInCurve: Curves.linear,
            switchOutCurve: Curves.easeIn,
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if(_hasLocationPermissions == null) {
      return Container();
    }
    if (_hasLocationPermissions) {
      BlocSupervisor.delegate = BasicBlocDelegate();
      return MultiBlocProvider(
        providers:[
          BlocProvider<MarkerBloc>(
            create: (context) => MarkerBloc(),
          ),
          BlocProvider<TournamentBloc>(
            create: (context) => TournamentBloc(),
          ),
        ],
        child: HomePage(),
      );
    }
    return PermissionsPage(onLocationEnabled: loadMapPage);
  }

  loadMapPage() async {
    Loading().isNow(true);
    setState(() {
      _hasLocationPermissions = true;
    });
  }
}
