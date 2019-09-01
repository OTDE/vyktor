import 'dart:io';
import 'smashgg_api_token.dart';
import 'package:graphql/client.dart';
import 'package:geolocator/geolocator.dart';

import 'package:vyktor/models/settings_data.dart';

/// This file contains variables and functions related
/// to making GraphQL queries to the smash.gg API.

/// The smash.gg API endpoint
final HttpLink _httpLink = HttpLink(
  uri: 'https://api.smash.gg/gql/alpha',
);

/// The authentication token. (No peeking.)
final AuthLink _authLink = AuthLink(
  getToken: () async => 'Bearer $smashgg_api_token',
);

/// The final link used when making the query.
final Link _link = _authLink.concat(_httpLink);

/// The query made to collect local tournament data.
///
/// In broad terms, this query is saying
/// "Collect a bunch of metadata on tournaments
/// that have registration open and are within
/// [$radius] miles of [$coordinates]."
///
/// TODO: update documentation on query to reflect new parameters.
const String tournamentLocationQuery = r'''
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
          images(type:"profile"){
            url
          }
        }
      }
    },
  ''';

/// The options supplied to the GraphQL query.
///
/// The center of the query is dictated by the [position] given.
Future<QueryOptions> queryOptions(Position position) async {
  var lat = position.latitude;
  var lng = position.longitude;
  var radius = await Settings().getRadiusInMiles();
  var afterDate = await Settings().getStartAfterDate().then(_formatForQuery);
  var beforeDate = await Settings().getStartBeforeDate().then(_formatForQuery);
  return QueryOptions(
    document: tournamentLocationQuery,
    variables: <String, dynamic> {
      "coordinates": "$lat,$lng",
      "radius": "${radius}mi",
      "after": afterDate,
      "before": beforeDate
    },
  );
}

int _formatForQuery(int fromSettings) => (fromSettings / 1000).round();

/// The GraphQL client being used by the app to send queries.
GraphQLClient _client;

/// Singleton method, so the app doesn't create
/// more than one instance of [_client].
GraphQLClient getGraphQLClient() {
  _client ??= GraphQLClient(
    link: _link,
    cache: InMemoryCache(),
  );
  return _client;
}
