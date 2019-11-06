import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../blocs/blocs.dart';
import '../../../../services/services.dart';

class ExploreModeSwitch extends StatefulWidget {
  @override
  _ExploreModeSwitchState createState() => _ExploreModeSwitchState();
}

class _ExploreModeSwitchState extends State<ExploreModeSwitch> {

  bool _isExploreModeEnabled = false;
  bool _loading = false;
  StreamSubscription<bool> _loadingListener;

  @override
  void initState() {
    Settings().getExploreMode().then((isEnabled) {
      setState(() {
        _isExploreModeEnabled = isEnabled;
      });
    });
    _loadingListener = Loading().isLoading.stream.listen((bool loading) {
      setState(() {
        _loading = loading;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _loadingListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return IgnorePointer(
          ignoring: _loading,
          child: Switch(
            value: _isExploreModeEnabled,
            onChanged: (isEnabled) async {
              if (isEnabled) {
                setState(() {
                  _isExploreModeEnabled = isEnabled;
                });
                mapBloc.dispatch(DisableLocationListening());
              } else {
                Loading().isNow(true);
                setState(() {
                  _isExploreModeEnabled = isEnabled;
                });
                mapBloc.dispatch(EnableLocationListening());
                var currentPosition = await Geolocator().getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.medium,
                );
                mapBloc.dispatch(RefreshMarkerData(currentPosition));
              }
              await Settings().setExploreMode(isEnabled);
            },
          ),
        );
  }

}
