import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql/client.dart';
import 'package:vyktor/services/graphql_client.dart';
import 'dart:convert';

const String APPLE_MAPS_URL_PREFIX = 'http://maps.apple.com/?daddr=';
const String GOOGLE_MAPS_URL_PREFIX = 'https://google.com/maps/dir/?api=1&destination=';

class MapDataProvider {

  static const String _tournamentLocationQuery = r'''
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

  Future<MapData> getCurrentMapData() {
    return getGraphQLClient().query(_queryOptions()).then(_toMapData);
  }


  QueryOptions _queryOptions() {
    return QueryOptions(
      document: _tournamentLocationQuery,
      variables: <String, dynamic> {
        "coordinates": "33.7454725,-117.86765300000002",
        "radius": "50mi"
      },
    );
  }


  MapData _toMapData(QueryResult queryResult) {
    if (queryResult.hasErrors) {
      throw Exception();
    }
    print(queryResult);
    final tournamentList = queryResult.data["tournaments"]["nodes"] as List<Map<String, dynamic>>;
    List<Tournament> tournaments = tournamentList.map((tournament) => Tournament.fromJson(tournament)).toList();

    return MapData(tournaments);
  }
}

class MapData {
  List<Tournament> _tournaments;
  Map<int, Marker> _markers;

  MapData([this._tournaments]);

  void toMarkers() {

  }
}

class Tournament {
  int id;
  String name;
  String slug;
  String venueAddress;
  int startAt;
  double lat;
  double lng;
  List<Image> images;

  Tournament({
    this.id,
    this.name,
    this.slug,
    this.venueAddress,
    this.startAt,
    this.lat,
    this.lng,
    this.images,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) => new Tournament(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    venueAddress: json["venueAddress"],
    startAt: json["startAt"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    images: new List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "venueAddress": venueAddress,
    "startAt": startAt,
    "lat": lat,
    "lng": lng,
    "images": new List<dynamic>.from(images.map((x) => x.toJson())),
  };
}

class Image {
  String url;

  Image({
    this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) => new Image(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}

