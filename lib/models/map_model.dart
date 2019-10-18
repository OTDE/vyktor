import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql/client.dart';

import '../services/services.dart';

/// A class for providing [MapData] to the MapDataBloc.
///
/// Stores the [mostRecentState] of the [MapData], which
/// is refreshed via the BLoC instance's invocation of [refresh].
/// A [Tournament] becomes the [selectedTournament] via the
/// BLoC's invocation of [setSelectedTournament].
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
  /// Throws an [InternetException] on any kind of error caused by the query method.
  Future<MapData> _refreshMapData(Position currentPosition) async {
      return getGraphQLClient()
          .query(await queryOptions(currentPosition))
          .then((result) async {
            try {
              return await compute(_toMapData, result);
            } catch(_) {
              return MapData(hasErrors: true);
            }
      }).catchError((_) {
        return MapData(hasErrors: true);
      });
  }

  /// Parses the [queryResult] into [MapData].
  ///
  /// Throws a [BadRequestException] if the result returns with errors.
  /// Assumes the JSON received will have a list of tournaments
  /// and throws the rest of the information away. Allows for null values
  /// in case there are, like, zero tournaments in the search.
  static MapData _toMapData(QueryResult queryResult) {
    if (queryResult.hasErrors) {
      throw BadRequestException(queryResult.errors.toString());
    }

    final tournamentList =
        queryResult.data["tournaments"]["nodes"] as List<dynamic>;
    List<Tournament> tournaments = tournamentList
        ?.map((tournament) => Tournament.fromJson(tournament))
        ?.toList();
    return MapData(tournaments: tournaments);
  }

  /// Sets the [selectedTournament] based on the [tournamentId].
  ///
  /// This function is designed to be called by a BLoC through
  /// the [Marker] associated with this [MarkerId] via an
  /// [onTap] VoidCallback function.
  ///
  /// Returns null when no tournament is selected.
  void setSelectedTournament(MarkerId tournamentId) =>
      selectedTournament = mostRecentState.getTournament(tournamentId?.value);
}

/// A class for holding the results of a smash.gg query in a neatly-parsed bundle.
///
/// Contains a list of all the [tournaments] that the BLoC
/// will display through a set of [Marker]s on the [GoogleMap] widget
/// on the map page.
class MapData {
  /// The tournaments that will be fed to the BLoC.
  List<Tournament> tournaments;
  bool hasErrors;

  /// Allows for null results.
  MapData({this.tournaments, this.hasErrors = false}) {
    tournaments ??= [];
  }

  /// Retrieves a [Tournament] based on the value of its associated [MarkerId] value.
  ///
  /// Returns null if no tournament is selected.
  ///
  /// Since the [id] is created on smash.gg's end, I sort of
  /// have to take their word for it that this is unique, but
  /// I truly doubt there will ever be duplicates here. Don't
  /// eliminate it as a possibility if a bug shows up, though.
  Tournament getTournament(String id) {
    if (id != null) {
      return tournaments
          .singleWhere((tournament) => tournament.id == int.parse(id));
    }
    return null;
  }

  bool isEmpty() => tournaments.isEmpty;
}

/// Generated code for storing information from a [QueryResult].
///
/// Maps to and from JSON. Don't modify outside EXTREMELY specific circumstances
/// (renaming the "Image" class generated by quicktype.io to avoid name collisions)
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
  List<Avatar> images;

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
        images: new List<Avatar>.from(
            json["images"].map((x) => Avatar.fromJson(x))),
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

class Avatar {
  String url;

  Avatar({
    this.url,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => new Avatar(
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
