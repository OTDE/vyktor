import 'package:graphql/client.dart';
import 'package:vyktor/services/graphql_client.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vyktor/blocs/map/map_data_barrel.dart';

const String APPLE_MAPS_URL_PREFIX = 'http://maps.apple.com/?daddr=';
const String GOOGLE_MAPS_URL_PREFIX = 'https://google.com/maps/dir/?api=1&destination=';

class MapDataProvider {

  MapData mostRecentState;
  Tournament selectedTournament;

  Future<void> refresh(Position currentPosition) async => await _buildMapState(currentPosition);

  void setSelectedTournament(MarkerId tournamentId) => selectedTournament = mostRecentState.getTournament(tournamentId.toString());

  Future<void> _buildMapState(Position position) async => mostRecentState = await _refreshMapData(position);

  Future<MapData> _refreshMapData(Position position) async => getGraphQLClient().query(queryOptions(position)).then(_toMapData);

  MapData _toMapData(QueryResult queryResult) {
    if (queryResult.hasErrors) {
      throw Exception();
    }

    final tournamentList = queryResult.data["tournaments"]["nodes"] as List<dynamic>;
    List<Tournament> tournaments = tournamentList.map((tournament) =>
        Tournament.fromJson(tournament)).toList();
    return MapData(tournaments);
  }

}

class MapData {

  List<Tournament> tournaments;
  MapData([this.tournaments]);

  Tournament getTournament(String id) => tournaments.singleWhere((tournament) => tournament.id == id as int);

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

