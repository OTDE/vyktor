import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vyktor/components/components.dart';

import '../../../blocs/blocs.dart';
import '../../../services/services.dart';
import 'tournament_panel.dart';

class SelectedTournament extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TournamentBloc, TournamentState>(
      builder: (context, state) {
        if (state is TournamentSelected) {
          final entrantCount = state.tournament.participants.pageInfo.total;
          return Column(
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
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                            border: Border.all(
                                color: Theme.of(context).accentColor,
                                width: 5.0),
                          ),
                          child: Center(
                            child: TournamentPicture(),
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
                        url: _buildDirectionsURL(state.tournament.venueAddress,
                            state.tournament.lat, state.tournament.lng),
                      ),
                      TournamentLaunchButton(
                        key: ObjectKey('Sign up'),
                        label: 'Sign up',
                        url: _buildSmashggURL(state.tournament.slug),
                      )
                    ],
                  ),
                  Spacer(flex: 10),
                ],
              ),
              Spacer(flex: 1),
              Text(
                state.tournament.name,
                style: Theme.of(context).primaryTextTheme.headline,
              ),
              Spacer(flex: 1),
              Text(
                '$entrantCount entrant${(entrants) {
                  return entrants == 1 ? '' : 's';
                }(entrantCount)}',
                style: Theme.of(context).primaryTextTheme.display1,
              ),
              Spacer(flex: 1),
              Text(
                _toFormattedDate(state.tournament.startAt),
                style: Theme.of(context).primaryTextTheme.caption,
              ),
              Spacer(flex: 1),
              Text(
                _toFormattedAddress(state.tournament.venueAddress),
                style: Theme.of(context).primaryTextTheme.subhead,
              ),
              Spacer(flex: 15),
            ],
          );
        } else {
          return Container(
            child: state is TournamentLoading ? LoadingIcon() : null,
          );
        }
      },
    );
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
