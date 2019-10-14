import 'package:flutter/material.dart';
import 'package:vyktor/widgets/map_display.dart';
import 'package:vyktor/widgets/menu.dart';
import 'package:vyktor/panels/panels.dart';
import 'package:vyktor/services/singletons/tab_selector.dart';

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
          key: UniqueKey(),
          child: SelectedTournament(),
          panel: SelectedPanel.tournament,
        ),
        PanelAnimator(
          key: UniqueKey(),
          child: MapSettingsPanel(),
          panel: SelectedPanel.mapSettings,
        ),
        PanelAnimator(
          key: UniqueKey(),
          child: SearchSettingsPanel(),
          panel: SelectedPanel.searchSettings,
        ),
        PanelAnimator(
          key: UniqueKey(),
          child: InfoPanel(),
          panel: SelectedPanel.info,
        )
      ],
    ));
  }
}
