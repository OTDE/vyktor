import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../blocs/blocs.dart';

class TournamentLaunchButton extends StatelessWidget {
  final String label;
  final String url;

  TournamentLaunchButton({Key key, this.label, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: RaisedButton(
          child: Text(
            label,
            style: Theme.of(context).primaryTextTheme.button,
          ),
          color: Theme.of(context).colorScheme.surface,
          textColor: Theme.of(context).colorScheme.onSurface,
          onPressed: () async {
            _onPressed(context);
          },
        ));
  }

  Future<void> _onPressed(BuildContext context) async {
      BlocProvider.of<PanelSelectorBloc>(context).add(HidePanel());
      await Future.delayed(Duration(milliseconds: 300));
      try {
        _launchURL(url);
      } catch (_) {
        _handleMalformedURL(context);
      }
  }

  /// Launches a [url], or throws an exception trying.
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _handleMalformedURL(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('URL error'),
            content: Text('URL is malformed or nonexistent'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
