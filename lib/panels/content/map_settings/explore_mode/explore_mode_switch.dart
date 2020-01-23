import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/blocs.dart';

class ExploreModeSwitch extends StatefulWidget {
  @override
  _ExploreModeSwitchState createState() => _ExploreModeSwitchState();
}

class _ExploreModeSwitchState extends State<ExploreModeSwitch> {
  @override
  Widget build(BuildContext context) {
    final settings = BlocProvider.of<SettingsBloc>(context) as SettingsLoaded;
    return Switch(
      value: settings.exploreModeEnabled,
      onChanged: (isEnabled) async {
        BlocProvider.of<SettingsBloc>(context)
            .add(SetExploreModeEnabled(isEnabled));
        if (!isEnabled) {
          BlocProvider.of<MarkerBloc>(context).add(RefreshMarkerData());
        }
      },
    );
  }
}
