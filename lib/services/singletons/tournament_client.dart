import 'dart:async';
import 'package:graphql/client.dart';

import '../services.dart';
import '../../models/tournament.dart';
import '../../blocs/blocs.dart';


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

  Future<List<Tournament>> fetchMarkerData({SettingsLoaded settings, LocationLoaded location}) async {
      var options = assembleQueryOptions(settings: settings, location: location);
      var result = await getGraphQLClient().query(options);
      var data = _toTournamentMap(result);
      return data;
  }

  static List<Tournament> _toTournamentMap(queryResult) {
    if(queryResult.hasException) {
      throw BadRequestException(queryResult.errors.toString());
    }
    final tournamentData = queryResult.data["tournaments"]["nodes"] as List<dynamic>;
    return (tournamentData?.map((tournament) => Tournament.fromJson(tournament)) ?? []).toList();
  }

  QueryOptions assembleQueryOptions({SettingsLoaded settings, LocationLoaded location}) {
    var lat = location.position.latitude;
    var lng = location.position.longitude;
    var radius = settings.radius;
    var afterDate = settings.afterDate.millisecondsSinceEpoch ~/ 1000;
    var beforeDate = settings.beforeDate.millisecondsSinceEpoch ~/ 1000;
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
}

