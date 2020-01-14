import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql/client.dart';

import '../services.dart';
import '../../models/tournament_model.dart';
import '../../models/tournament.dart';


class TournamentClient {

  static final String tournamentLocationQuery = r'''
   query TournamentsByLocation($coordinates: String!, $radius: String!, $after: Timestamp!, $before: Timestamp!) {
      tournaments(query: {
        filter: {
          afterDate: $after
          beforeDate: $before
          location: {
            distanceFrom: $coordinates,
            distance: $radius
          }
          regOpen: true
          upcoming: true
        }
      }) {
        nodes {
          id
          lat
          lng
          name
          slug
          startAt
          timezone
          venueAddress
          participants(query: {}) {
            pageInfo {
              total
            }
          }
          images(type:"profile") {
            url
          }
        }
      }
    },
  ''';

  factory TournamentClient() => _client;

  static final _client =  TournamentClient._internal();

  TournamentClient._internal();

  static final HttpLink _httpLink = HttpLink(uri: 'https://api.smash.gg/gql/alpha');

  static final AuthLink _authLink = AuthLink(
    getToken: () async => 'Bearer ${await KeyStorage().getValue('smashgg_api_key')}'
  );

  static final Link _link = _authLink.concat(_httpLink);

  GraphQLClient _graphQLClient;

  getGraphQLClient() {
    _graphQLClient ??= GraphQLClient(
      link: _link,
      cache: InMemoryCache(),
    );
    return _graphQLClient;
  }


  Future<void> refreshMarkerData(Position currentPosition) async {
    TournamentModel().tournamentMap = await fetchMarkerData(currentPosition);
  }


  Future<Map<int, Tournament>> fetchMarkerData(Position currentPosition) async {
      var result = await getGraphQLClient().query(await queryOptions(currentPosition));
      var data = _toTournamentMap(result);
      return data;
  }

  static Map<int, Tournament> _toTournamentMap(queryResult) {
    if(queryResult.hasErrors) {
      throw BadRequestException(queryResult.errors.toString());
    }
    final tournamentData = queryResult.data["tournaments"]["nodes"] as List<dynamic>;
    final tournamentList = (tournamentData?.map((tournament) => Tournament.fromJson(tournament)) ?? []).toList();
    final ids = tournamentList.map((tournament) => tournament.id);
    return Map.fromIterables(ids, tournamentList);
  }

  Future<QueryOptions> queryOptions(Position position) async {
    var lat = position.latitude;
    var lng = position.longitude;
    var radius = await Settings().getRadiusInMiles();
    var afterDate = await Settings().getStartAfterDate().then(_toSecondsSinceEpoch);
    var beforeDate = await Settings().getStartBeforeDate().then(_toSecondsSinceEpoch);
    return QueryOptions(
      documentNode: gql(tournamentLocationQuery),
      variables: <String, dynamic> {
        "coordinates": "$lat,$lng",
        "radius": "${radius}mi",
        "after": afterDate,
        "before": beforeDate
      },
    );
  }

  int _toSecondsSinceEpoch(int fromSettings) => (fromSettings / 1000).round();
}

