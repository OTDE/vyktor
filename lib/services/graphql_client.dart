
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

GraphQLClient _client;

GraphQLClient getGraphQLClient() {
  _client ??= GraphQLClient(
    link: _link,
    cache: InMemoryCache(),
  );

  return _client;
}