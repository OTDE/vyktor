
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/blocs.dart';
import 'radius_display.dart';

class RadiusSettings extends StatefulWidget {
  @override
  _RadiusSettingsState createState() => _RadiusSettingsState();
}

class _RadiusSettingsState extends State<RadiusSettings> {

  int _radius;

  @override
  Widget build(BuildContext context) {
    final settings = BlocProvider.of<SettingsBloc>(context).state as SettingsLoaded;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RadiusDisplay(radius: _radius),
        SizedBox(height: 10.0),
        IgnorePointer(
          ignoring: settings.exploreModeEnabled,
          child: Slider(
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).colorScheme.primaryVariant,
            value: _radius.toDouble(),
            min: 5,
            max: 150,
            divisions: 58,
            onChanged: (radius) {
              setState(() {
                _radius = radius.truncate();
              });
            },
            onChangeEnd: (radius) async {
              BlocProvider.of<SettingsBloc>(context).add(SetRadius(radius));
              BlocProvider.of<MarkerBloc>(context).add(RefreshMarkerData());
            },
          ),
        ),
      ],
    );
  }
}
