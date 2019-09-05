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
    final animBloc = BlocProvider.of<AnimatorBloc>(context);
    final mapBloc = BlocProvider.of<MapDataBloc>(context);
    return BlocBuilder<MapDataBloc, MapDataState>(builder: (context, state) {
      if (state is MapDataLoaded) {
        if (state.selectedTournament != null) {
          int numEntrants =
              state.selectedTournament.participants.pageInfo.total;
          return Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
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
                                  image: state.selectedTournament.images
                                              .length !=
                                          0
                                      ? state.selectedTournament.images[0].url
                                      : 'https://picsum.photos/80',
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
                              alignment: Alignment.topLeft,
                              child: RaisedButton(
                                child: Text(
                                  'Directions',
                                  style:
                                      Theme.of(context).primaryTextTheme.button,
                                ),
                                color: Theme.of(context).colorScheme.surface,
                                textColor:
                                    Theme.of(context).colorScheme.onSurface,
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
                              alignment: Alignment.topLeft,
                              child: RaisedButton(
                                child: Text(
                                  'Sign up',
                                  style:
                                      Theme.of(context).primaryTextTheme.button,
                                ),
                                color: Theme.of(context).colorScheme.surface,
                                textColor:
                                    Theme.of(context).colorScheme.onSurface,
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
                  Spacer(flex: 1),
                  Text(
                    state.selectedTournament.name,
                    style: Theme.of(context).primaryTextTheme.headline,
                  ),
                  Spacer(flex: 1),
                  Text(
                    '$numEntrants entrant${(entrants) {
                      return entrants == 1 ? '' : 's';
                    }(numEntrants)}',
                    style: Theme.of(context).primaryTextTheme.display1,
                  ),
                  Spacer(flex: 1),
                  Text(
                    _toFormattedDate(state.selectedTournament.startAt),
                    style: Theme.of(context).primaryTextTheme.caption,
                  ),
                  Spacer(flex: 1),
                  Text(
                    _toFormattedAddress(state.selectedTournament.venueAddress),
                    style: Theme.of(context).primaryTextTheme.subhead,
                  ),
                  Spacer(flex: 15),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryVariant,
                    elevation: 0.0,
                    heroTag: 'cancelTournament',
                    shape: ContinuousRectangleBorder(),
                    mini: true,
                    child: Icon(Icons.arrow_back),
                    onPressed: () async {
                      mapBloc.dispatch(UnlockMap());
                      mapBloc.dispatch(UpdateSelectedTournament());
                      animBloc.dispatch(DeselectAll());
                    }),
              )
            ],
          );
        }
      }
      return Container();
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

  String _toFormattedAddress(String address) {
    var addressWords = address.split(', ');
    return '${addressWords[0]}\n${addressWords[1]}, ${addressWords[2]}';
  }

  String _toFormattedDate(int timestamp) {
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    return '${date.month}/${date.day}/${date.year} — ${date.hour % 12}:'
        '${(int minute) {
      return minute < 10 ? '0$minute' : '$minute';
    }(date.minute)} '
        '${(int hour) {
      return hour > 12 ? 'PM' : 'AM';
    }(date.hour)}';
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
