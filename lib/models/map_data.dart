import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql/client.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MapData {
  Map<Marker, TournamentInfo> tournaments;
}

class TournamentInfo {

  String slug;
  String name;
  String address;
  String imageURL;

}