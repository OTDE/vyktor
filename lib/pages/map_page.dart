import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vyktor/blocs/map/map_data_barrel.dart';
import 'package:vyktor/widgets/map_widget.dart';

/// The page containing the map.
///
/// (and, honestly, most of the other stuff too.)
/// TODO: separate out the map, formatting, and setting widgets.
class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

/// The state of the [MapPage].
///
/// Uses a [_controller], which currently isn't being used,
/// since the map is listening to state changes in the BLoC.
/// [_geolocator] allows the [FloatingActionButton] to get
/// the phone's current location. The map also keeps track
/// of the [_lastRecordedPosition], so that marker updates
/// don't force the map to reload at the user location,
/// instead of wherever the map's camera previously was.
class MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    return BlocBuilder<MapDataBloc, MapDataState>(builder: (context, state) {
      return SafeArea(
          child: Stack(
        children: <Widget>[
          VyktorMap(),
        ],
      ));
    });
  }
}
