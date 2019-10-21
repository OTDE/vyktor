import 'package:flutter/material.dart';

import '../components/components.dart';
import '../panels/panels.dart';

/// The page with all the "stuff": map/menu widgets and all the panels.
class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: <Widget>[
        VyktorMap(),
        VyktorMenu(),
        AnimatedPanels(),
      ],
    ));
  }

}
