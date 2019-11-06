import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/blocs.dart';
import '../../../../services/services.dart';
import 'radius_display.dart';

class RadiusSettings extends StatefulWidget {
  @override
  _RadiusSettingsState createState() => _RadiusSettingsState();
}

class _RadiusSettingsState extends State<RadiusSettings> {
  int _radius = 50;
  bool _loading = false;
  StreamSubscription<bool> _loadingListener;

  @override
  void initState() {
    Settings().getRadiusInMiles().then((value) {
      setState(() {
        _radius = value;
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              RadiusDisplay(radius: _radius),
              SizedBox(height: 10.0),
              IgnorePointer(
                ignoring: _loading,
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
                    await Settings().setRadiusInMiles(radius.truncate());
                    Loading().isNow(true);
                    mapBloc.dispatch(RefreshMarkerData());
                  },
                ),
              ),
            ],
        );
  }
}
