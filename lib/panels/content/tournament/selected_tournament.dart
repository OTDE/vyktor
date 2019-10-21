import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../blocs/blocs.dart';
import '../../../services/services.dart';
import 'tournament.dart';

/// The panel dedicated to showing the selected tournament.
class SelectedTournament extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final state =
        BlocProvider.of<MapBloc>(context).currentState as MapDataLoaded;
    final tournament = state.selectedTournament;
    final numEntrants = tournament?.participants?.pageInfo?.total;
    return tournament != null
        ? Stack(
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
                          TournamentLaunchButton(
                            key: ObjectKey('Directions'),
                            label: 'Directions',
                            url: _buildDirectionsURL(
                                state.selectedTournament.venueAddress,
                                state.selectedTournament.lat,
                                state.selectedTournament.lng),
                          ),
                          TournamentLaunchButton(
                            key: ObjectKey('Sign up'),
                            label: 'Sign up',
                            url: _buildSmashggURL(
                                state.selectedTournament.slug),
                          )
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
                      MapLocker().unlock();
                      TabBehavior().setPanel(SelectedPanel.none);
                    }),
              )
            ],
          )
        : Container();
  }


  /// Formats tournament address to make it look nice on the panel.
  ///
  /// Assumes addresses are written like so:
  /// 0239 Example Street, City, State ZIP, Country
  String _toFormattedAddress(String address) {
    if (!address.contains(',\s')) {
      return address;
    }
    var addressWords = address.split(',\s');
    return '${addressWords[0]}\n${addressWords[1]}${() {
      return addressWords.length > 2 ? ', ${addressWords[2]}' : '';
    }()}';
  }

  /// Formats a unix [timestamp] into a formatted date/time string.
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

  /// Builds a URL, given a smash.gg tournament [slug].
  String _buildSmashggURL(String slug) => 'http://smash.gg/$slug';

  /// Builds a directions URL, given an [address], based on platform.
  ///
  /// If the phone is on iOS, uses the coordinates to make a search.
  String _buildDirectionsURL(String address, [double lat, double lng]) {
    if (Platform.isIOS) {
      return 'http://maps.apple.com/?sll=$lat,$lng';
    } else {
      address.replaceAll(' ', '%20');
      address.replaceAll(',', '%2C');
      return 'https://www.google.com/maps/dir/?api=1&destination=$address';
    }
  }


}
