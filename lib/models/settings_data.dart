import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Basic shared preferences helper. Will be fairly straightforward to
/// plug in, since the existence of the shared preferences inside the phone
/// acts like a sort of pseudo-bloc with ez in and out points.
class Settings {

  static const Settings _settings = Settings._internal();

  factory Settings() {
    return _settings;
  }

  const Settings._internal();

  static const String _radius = 'distanceFromCenter';
  static const String _earlyDate = 'earliestTournamentDate';
  static const String _lateDate = 'latestTournamentDate';
  static const String _explore = 'exploreEnabled';

  /// Default values for the settings.
  static const int _defaultRadius = 50;
  static int _defaultAfterDate = _daysFromNow(0);
  static int _defaultBeforeDate = _daysFromNow(60);

  static int _daysFromNow(int numOfDays) =>
      (DateTime.now().add(Duration(days: numOfDays))).millisecondsSinceEpoch;

  Future<int> getRadiusInMiles() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getInt(_radius) ?? _defaultRadius;
  }

  Future<bool> setRadiusInMiles(int radius) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setInt(_radius, radius);
  }

  Future<int> getStartAfterDate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getInt(_earlyDate) ?? _defaultAfterDate;
  }

  Future<bool> setStartAfterDate(int date) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setInt(_earlyDate, date);
  }

  Future<int> getStartBeforeDate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getInt(_lateDate) ?? _defaultBeforeDate;
  }

  Future<bool> setStartBeforeDate(int date) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setInt(_lateDate, date);
  }

  Future<bool> getExploreMode() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getBool(_explore) ?? false;
  }

  Future<bool> setExploreMode(bool isEnabled) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setBool(_explore, isEnabled);
  }
}
