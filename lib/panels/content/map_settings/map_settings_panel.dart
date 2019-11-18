import 'package:flutter/material.dart';

import 'radius_settings/radius_settings.dart';
import 'explore_mode/explore_mode.dart';

/// Panel dedicated to handling map settings.
class MapSettingsPanel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Map Settings',
              style: Theme.of(context).primaryTextTheme.display1,
            ),
            SizedBox(height: 10.0),
            RadiusSettings(),
            SizedBox(height: 10.0),
            ExploreMode(),
          ],
        );
  }

}


