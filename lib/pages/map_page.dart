import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vyktor/widgets/map_widget.dart';
import 'package:vyktor/widgets/menu_widget.dart';
import 'package:vyktor/widgets/panel_animator.dart';
import 'package:vyktor/widgets/panels/tournament.dart';
import 'package:vyktor/widgets/panels/map_settings.dart';
import 'package:vyktor/widgets/panels/search_settings.dart';
import 'package:vyktor/widgets/panels/info.dart';
import 'package:vyktor/blocs/blocs.dart';


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
            PanelAnimator(
              child: SelectedTournament(),
              panel: SelectedPanel.tournament,
            ),
            PanelAnimator(
              child: MapSettingsPanel(),
              panel: SelectedPanel.mapSettings,
            ),
            PanelAnimator(
              child: SearchSettingsPanel(),
              panel: SelectedPanel.searchSettings,
            ),
            PanelAnimator(
              child: InfoPanel(),
              panel: SelectedPanel.info,
            )
          ],
        ));
  }

}
