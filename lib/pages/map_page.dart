import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vyktor/widgets/map_widget.dart';
import 'package:vyktor/widgets/menu_widget.dart';
import 'package:vyktor/widgets/tournament/selected_tournament_animator.dart';


/// The page containing the map and menu widgets.
class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

/// The state of the [MapPage].
class MapPageState extends State<MapPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: <Widget>[
            VyktorMap(),
            VyktorMenu(),
            SelectedTournamentAnimator(),
          ],
        ));
  }

}
