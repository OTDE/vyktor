import 'package:flutter/material.dart';

import 'filter_selector.dart';

/// The panel dedicating to holding information search settings.
/// TODO: refactor into smaller components.
class SearchSettingsPanel extends StatefulWidget {
  @override
  _SearchSettingsPanelState createState() => _SearchSettingsPanelState();
}

class _SearchSettingsPanelState extends State<SearchSettingsPanel> {



  @override
  Widget build(BuildContext context) {

    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Search settings',
              style: Theme.of(context).primaryTextTheme.display1,
            ),
            SizedBox(height: 10.0),
            Divider(
              color: Theme.of(context).colorScheme.primaryVariant,
              thickness: 3.0,
            ),
            SizedBox(height: 10.0),
            FilterSelector(),
            Spacer(flex: 20),
          ],
        );
  }



}
