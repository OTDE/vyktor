
import 'dart:io';
import 'smashgg_api_token.dart';
import 'package:graphql/client.dart';

final HttpLink _httpLink = HttpLink(
  uri: 'https://api.smash.gg/gql/alpha',
);

final AuthLink _authLink = AuthLink(
  getToken: () async => 'Bearer $SMASHGG_API_TOKEN',
);

final Link _link = _authLink.concat(_httpLink);

const String tournamentLocationQuery = r'''
   query TournamentsByLocation($coordinates: String!, $radius: String!) {
      tournaments(query: {
        filter: {
          location: {
            distanceFrom: $coordinates,
            distance: $radius
          }
          regOpen: true
        }
      }) {
        nodes {
          id
          name
          slug
          venueAddress
          lat
          lng
          images(type:"profile"){
            url
          }
        }
      }
    },
  ''';

QueryOptions queryOptions() {
  return QueryOptions(
    document: tournamentLocationQuery,
    variables: <String, dynamic> {
      "coordinates": "33.7454725,-117.86765300000002",
      "radius": "50mi"
    },
  );
}

GraphQLClient _client;

GraphQLClient getGraphQLClient() {
  _client ??= GraphQLClient(
    link: _link,
    cache: InMemoryCache(),
  );
  return _client;
}