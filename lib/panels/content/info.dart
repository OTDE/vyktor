import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blocs/blocs.dart';

/// Panel dedicated to providing additional information about the app.
/// TODO: refactor into smaller components.
class InfoPanel extends StatefulWidget {
  @override
  _InfoPanelState createState() => _InfoPanelState();
}

class _InfoPanelState extends State<InfoPanel> {

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Info & Credits',
              style: Theme.of(context).primaryTextTheme.display1,
            ),
            Divider(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    elevation: 0.0,
                    heroTag: 'otdeTwitter',
                    shape: ContinuousRectangleBorder(),
                    mini: true,
                    child: Icon(Icons.launch),
                    onPressed: () async {
                      BlocProvider.of<PanelSelectorBloc>(context).add(HidePanel());
                      await Future.delayed(Duration(milliseconds: 600));
                      _launchURL('https://mobile.twitter.com/thatdeepends');
                    }),
                Spacer(flex: 1),
                Text(
                  'App: OTDE',
                  style: Theme.of(context).primaryTextTheme.headline,
                ),
                Spacer(flex: 8),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    elevation: 0.0,
                    heroTag: 'otdeTwitter',
                    shape: ContinuousRectangleBorder(),
                    mini: true,
                    child: Icon(Icons.launch),
                    onPressed: () async {
                      BlocProvider.of<PanelSelectorBloc>(context).add(HidePanel());
                      await Future.delayed(Duration(milliseconds: 600));
                      _launchURL('https://mobile.twitter.com/ceegearts');
                    }),
                Spacer(flex: 1),
                Text(
                  'Logo: CeegeArts',
                  style: Theme.of(context).primaryTextTheme.headline,
                ),
                Spacer(flex: 5),
              ],
            ),
            Divider(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            Spacer(flex: 1),
            Text(
              'Tournament data powered by the smash.gg API. Vyktor is not affiliated with smash.gg in any other way.',
              style: Theme.of(context).primaryTextTheme.caption,
            ),
            Spacer(flex: 10),
          ],
        );
  }
  
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
