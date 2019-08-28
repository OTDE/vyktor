import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql/client.dart';

import 'package:vyktor/services/graphql_client.dart';

/// A class for providing [MapData] to the MapDataBloc.
///
/// Stores the [mostRecentState] of the [MapData], which
/// is refreshed via the BLoC instance's invocation of [refresh].
/// A [Tournament] becomes the [selectedTournament] via the
/// BLoC instance's invocation of [setSelectedTournament].
class MapDataProvider {
  /// The results of the most recent query to the smash.gg API.
  MapData mostRecentState;

  /// The tournament currently selected on the user's screen.
  Tournament selectedTournament;

  /// The method exposed to the BLoC in order to update the [mostRecentState].
  Future<void> refresh(Position currentPosition) async =>
      await _buildMapState(currentPosition);

  /// Updates the [mostRecentState] based on the [currentPosition].
  Future<void> _buildMapState(Position currentPosition) async =>
      mostRecentState = await _refreshMapData(currentPosition);

  /// Sends a GraphQL query to the smash.gg API.
  ///
  /// The [QueryOptions] object is built based on the [currentPosition].
  /// Once the query is successful, the resulting JSON is parsed [_toMapData].
  Future<MapData> _refreshMapData(Position currentPosition) async =>
      getGraphQLClient().query(await queryOptions(currentPosition)).then(_toMapData);

  /// Parses the [queryResult] into [MapData].
  ///
  /// Throws an [Exception] if the result returns with errors.
  /// Assumes the JSON received will have a list of tournaments
  /// and throws the rest of the information away.
  /// TODO: possibly investigate query complexity in requests?
  MapData _toMapData(QueryResult queryResult) {
    if (queryResult.hasErrors) {
      throw Exception();
    }

    final tournamentList =
        queryResult.data["tournaments"]["nodes"] as List<dynamic>;
    List<Tournament> tournaments = tournamentList
        .map((tournament) => Tournament.fromJson(tournament))
        .toList();
    return MapData(tournaments);
  }

  /// Sets the [selectedTournament] based on the [tournamentId].
  ///
  /// This function is designed to be called by a BLoC through
  /// the [Marker] associated with this [MarkerId] via an
  /// [onTap] VoidCallback function.
  ///
  /// This function is always called after the [MapData] is updated,
  /// so -to my knowledge- this function should never return null.
  /// Go check the BLoC's mapEventToState functions if something seems kooky.
  void setSelectedTournament(MarkerId tournamentId) =>
      selectedTournament = mostRecentState.getTournament(tournamentId.value);
}

/// A class for holding the results of a smash.gg query in a neatly-parsed bundle.
///
/// Contains a list of all the [tournaments] that the BLoC
/// will display through a set of [Marker]s on the [GoogleMap] widget
/// on the map page.
class MapData {
  /// The tournaments that will be fed to the BLoC.
  List<Tournament> tournaments;

  MapData([this.tournaments]);

  /// Retrieves a [Tournament] based on the value of its associated [MarkerId] value.
  ///
  /// Since the [id] is created on smash.gg's end, I sort of
  /// have to take their word for it that this is unique, but
  /// I truly doubt there will ever be duplicates here. Don't
  /// eliminate it as a possibility if a bug shows up, though.
  Tournament getTournament(String id) =>
      tournaments.singleWhere((tournament) => tournament.id == int.parse(id));
}

/// Generated code for storing information from a [QueryResult].
///
/// Maps to and from JSON.
///
/// This class was build to field a specific kind of request, and may be
/// regenerated or modified in the future, because its form is largely
/// dependent on the kind of GraphQL requests this app will need to make.
/// I started by getting a generous number of fields in anticipation of
/// future requirements, but some may leave, and some already need to be
/// added. [Image] should avoid name collisions, hopefully, but we'll find
/// that out when I get to making the frontend
/// for our little slide-image-bar-thing.
///
/// Update: IT'S TIME 4 CHANGE BABY
class Tournament {
  int id;
  double lat;
  double lng;
  String name;
  String slug;
  int startAt;
  String timezone;
  String venueAddress;
  Participants participants;
  List<Image> images;

  Tournament({
    this.id,
    this.lat,
    this.lng,
    this.name,
    this.slug,
    this.startAt,
    this.timezone,
    this.venueAddress,
    this.participants,
    this.images,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) => new Tournament(
    id: json["id"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    name: json["name"],
    slug: json["slug"],
    startAt: json["startAt"],
    timezone: json["timezone"],
    venueAddress: json["venueAddress"],
    participants: Participants.fromJson(json["participants"]),
    images: new List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lat": lat,
    "lng": lng,
    "name": name,
    "slug": slug,
    "startAt": startAt,
    "timezone": timezone,
    "venueAddress": venueAddress,
    "participants": participants.toJson(),
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

class Participants {
  PageInfo pageInfo;

  Participants({
    this.pageInfo,
  });

  factory Participants.fromJson(Map<String, dynamic> json) => new Participants(
    pageInfo: PageInfo.fromJson(json["pageInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "pageInfo": pageInfo.toJson(),
  };
}

class PageInfo {
  int total;

  PageInfo({
    this.total,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) => new PageInfo(
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
  };
}
