import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Page that displays when location is disabled for this app.
///
/// When location is enabled, calls the [onLocationEnabled] callback function.
class PermissionsPage extends StatefulWidget {
  /// The callback function [PermissionsPage] calls on receipt of location permission.
  final Function onLocationEnabled;

  PermissionsPage({Key key, @required this.onLocationEnabled}) : super(key: key);

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

/// Uses [_permissions] to get the status of location permissions for this app.
class _PermissionsPageState extends State<PermissionsPage> {
  /// The object used to calculate location [PermissionStatus].
  Map<PermissionGroup, PermissionStatus> _permissions;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 24),
            Container(
              height: 200,
              child: Image.asset('assets/images/in-app/mobile_logo_transparent.png'),
            ),
            Spacer(flex: 2),
            Text(
              'Welcome to open beta!',
              style: Theme.of(context).primaryTextTheme.headline,
            ),
            Spacer(flex: 1),
            Text(
              'Vyktor uses your location to find tournaments.',
              style: Theme.of(context).primaryTextTheme.body1,
            ),
            Spacer(flex: 1),
            Text(
              'Enable location tracking to continue.',
              style: Theme.of(context).primaryTextTheme.body1,
            ),
            Spacer(flex: 3),
            RaisedButton(
              child: Text(
                  'Enable',
                style: Theme.of(context).primaryTextTheme.button,
              ),
              color: Theme.of(context).colorScheme.surface,
              textColor: Theme.of(context).colorScheme.onSurface,
              onPressed: () => _getPermissions(),
            ),
            Spacer(flex: 20),
          ],
        ),
      ),
    );
  }

  /// Requests permissions, then checks [result].
  ///
  /// If [result] is enabled, invokes the [onLocationEnabled]
  /// callback function to the parent widget.
  _getPermissions() async {
    _permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    var result = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (result == PermissionStatus.granted) widget.onLocationEnabled();
  }

}
