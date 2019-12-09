
// Generated class for receiving JSON.
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
