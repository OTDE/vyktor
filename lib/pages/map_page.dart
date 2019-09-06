import 'package:flutter/material.dart';
import 'package:vyktor/widgets/map_widget.dart';
import 'package:vyktor/widgets/menu_widget.dart';
import 'package:vyktor/panels/panels.dart';
import 'package:vyktor/blocs/blocs.dart';

/// The page with all the "stuff": map/menu widgets and all the panels.
class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

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
