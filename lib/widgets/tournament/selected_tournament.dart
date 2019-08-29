import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vyktor/blocs/blocs.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectedTournament extends StatefulWidget {
  @override
  _SelectedTournamentState createState() => _SelectedTournamentState();
}

class _SelectedTournamentState extends State<SelectedTournament> {
  final bool isIOS = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapDataBloc, MapDataState>(builder: (context, state) {
      if (state is MapDataLoaded) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.rectangle,
          ),
          position: DecorationPosition.background,
          child: Container(
              width: 300,
              height: 300,
              margin: EdgeInsets.all(20.0).add(EdgeInsets.fromLTRB(1, 0, 0, 0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment:
                            Alignment.topLeft,
                        height: 120,
                        width: 120,
                        child: SizedBox(
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                                border: Border.all(
                                    color: Theme.of(context).accentColor,
                                    width: 5.0),
                              ),
                              child: Center(
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image:
                                      state.selectedTournament.images[0].url ??
                                          'https://picsum.photos/80',
                                  width: 80,
                                  height: 80,
                                ),
                              )),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Spacer(flex: 3),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                              alignment:
                              Alignment.topLeft,
                              child: RaisedButton(
                                child: Text(
                                  'Directions',
                                  style: Theme.of(context).primaryTextTheme.button,
                                ),
                                color: Theme.of(context).colorScheme.surface,
                                textColor: Theme.of(context).colorScheme.onSurface,
                                onPressed: () async {
                                  try {
                                    _launchURL(_buildDirectionsURL(
                                        state.selectedTournament.venueAddress));
                                  } catch (_) {
                                    //TODO: dialog w/ 'not valid maps url' or somesuch
                                  }
                                },
                              )),
                          Align(
                              alignment:
                              Alignment.topLeft,
                              child: RaisedButton(
                                child: Text(
                                  'Sign up',
                                  style: Theme.of(context).primaryTextTheme.button,
                                ),
                                color: Theme.of(context).colorScheme.surface,
                                textColor: Theme.of(context).colorScheme.onSurface,
                                onPressed: () async {
                                  try {
                                    _launchURL(_buildSmashggURL(
                                        state.selectedTournament.slug));
                                  } catch (_) {
                                    //TODO: dialog w/ 'cannot launch url' or somesuch
                                  }
                                },
                              ))
                        ],
                      ),
                      Spacer(flex: 10),
                    ],
                  ),
                  Text(
                    state.selectedTournament.name,
                    style: Theme.of(context).primaryTextTheme.headline,
                  ),
                  Spacer(flex: 1),
                  Text(
                    _formatAddress(state.selectedTournament.venueAddress),
                    style: Theme.of(context).primaryTextTheme.subhead,
                  ),
                  Spacer(flex: 4)
                ],
              )),
        );
      }
      return Placeholder();
    });
  }

  /// Launches a [url]
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _formatAddress(String address) {
    var addressWords = address.split(', ');
    return '${addressWords[0]}\n${addressWords[1]}, ${addressWords[2]}';
  }

  String _buildSmashggURL(String slug) => 'http://smash.gg/' + slug;

  String _buildDirectionsURL(String address) {
    if (isIOS) {
      address.replaceAll(' ', '+');
      return 'https://maps.apple.com/?daddr=$address';
    } else {
      address.replaceAll(', ', '+2C');
      address.replaceAll(' ', '+');
      return 'https://www.google.com/maps/dir/?api=1&destination=$address';
    }
  }
}
