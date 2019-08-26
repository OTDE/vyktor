import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Page that displays when location is disabled for this app.
///
/// When location is enabled, calls the [enableLocation] callback function.
class PermissionsPage extends StatefulWidget {
  /// The callback function [PermissionsPage] calls on receipt of location permission.
  final Function enableLocation;

  PermissionsPage({Key key, @required this.enableLocation}) : super(key: key);

  @override
  State<PermissionsPage> createState() => PermissionsPageState();
}

/// State of the permissions page.
///
/// Uses [_permissions] to get the status
/// of location permissions for this app.
class PermissionsPageState extends State<PermissionsPage> {
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
            Text(
              'vyktor',
              style: Theme.of(context).primaryTextTheme.display3,
            ),
            Spacer(flex: 2),
            Text(
              'Welcome to Vyktor\'s closed alpha!',
              style: Theme.of(context).primaryTextTheme.headline,
            ),
            Spacer(flex: 1),
            Text(
              'First, allow location tracking.',
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
  /// If [result] is enabled, invokes the [enableLocation]
  /// callback function to the parent widget.
  _getPermissions() async {
    _permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
    var result = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (result == PermissionStatus.granted) widget.enableLocation();
  }

}
