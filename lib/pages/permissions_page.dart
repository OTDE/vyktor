import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsPage extends StatefulWidget {
  PermissionsPage({Key key, @required this.enableLocation}) : super(key: key);
  Function enableLocation;

  @override
  State<PermissionsPage> createState() => PermissionsPageState();
}

class PermissionsPageState extends State<PermissionsPage> {


  Map<PermissionGroup, PermissionStatus> _permissions;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'First, allow location tracking.',
              style: TextStyle(
                  color: Theme.of(context).canvasColor,
              ),
            ),
            RaisedButton(
                child: Text('Enable'),
                textColor: Theme.of(context).primaryColor,
                onPressed: () => _getPermissions(),
            ),
          ],
        ),
      ),
    );
  }

  _getPermissions() async {
    _permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
    var result = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    if(result == PermissionStatus.granted)
      widget.enableLocation();
  }


}