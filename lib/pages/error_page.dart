import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../blocs/blocs.dart';
import '../services/services.dart';

class ErrorPage extends StatelessWidget {
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
              child: Image.asset('assets/images/in-app/mobile_logo_error.png'),
            ),
            Spacer(flex: 2),
            Text(
              'Couldn\'t load map data.\nTry again.',
              style: Theme.of(context).primaryTextTheme.headline,
              textAlign: TextAlign.center,
            ),
            Spacer(flex: 2),
            RaisedButton(
              child: Text(
                'Refresh',
                style: Theme.of(context).primaryTextTheme.button,
              ),
              color: Theme.of(context).colorScheme.surface,
              textColor: Theme.of(context).colorScheme.onSurface,
              onPressed: () async {
                Loading().isNow(true);
                var currentPosition =
                await Geolocator().getCurrentPosition();
                BlocProvider.of<MarkerBloc>(context).add((RefreshMarkerData(currentPosition)));
              },
            ),
            Spacer(flex: 20),
          ],
        ),
      ),
    );
  }
}
