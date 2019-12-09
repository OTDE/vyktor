import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/blocs.dart';
import '../../../../services/services.dart';

class ExploreModeSwitch extends StatefulWidget {
  @override
  _ExploreModeSwitchState createState() => _ExploreModeSwitchState();
}

class _ExploreModeSwitchState extends State<ExploreModeSwitch> {

  bool _isExploreModeEnabled = false;

  @override
  void initState() {
    Settings().getExploreMode().then((isEnabled) {
      setState(() {
        _isExploreModeEnabled = isEnabled;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isExploreModeEnabled,
      onChanged: (isEnabled) async {
        await Settings().setExploreMode(isEnabled);
        if (!isEnabled) {
          Loading().isNow(true);
          BlocProvider.of<MarkerBloc>(context).add(
              RefreshMarkerData(PhoneLocation().location)
          );
        }
        setState(() {
          _isExploreModeEnabled = isEnabled;
        });
      },
    );
  }

}
