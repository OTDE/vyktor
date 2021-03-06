import 'package:flutter/material.dart';

import 'explore_mode_switch.dart';
import 'explore_mode_switch_wrapper.dart';

class ExploreMode extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(
            'Explore mode:',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          Spacer(flex: 1),
          LoadWrapper(child: ExploreModeSwitch()),
        ]),
        Text(
          '(Press and hold on the map)',
          style: Theme.of(context).primaryTextTheme.caption,
        ),
      ],
    );
  }

}
