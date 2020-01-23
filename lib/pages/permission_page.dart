import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';

/// Page that displays when location is disabled for this app.
///
/// When location is enabled, calls the [onLocationEnabled] callback function.
class PermissionPage extends StatelessWidget {
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
              child: Image.asset(
                  'assets/images/in-app/mobile_logo_transparent.png'),
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
              onPressed: () {
                BlocProvider.of<PermissionBloc>(context)
                    .add(RequestLocationPermissions());
              },
            ),
            Spacer(flex: 20),
          ],
        ),
      ),
    );
  }
}
