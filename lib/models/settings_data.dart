import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// TODO: document more robustly once fully integrated.
///
/// Basic shared preferences helper. Will be fairly straightforward to
/// plug in, since the existence of the shared preferences inside the phone
/// acts like a sort of pseudo-bloc with ez in and out points.
class Settings {

  static final Settings _settings = Settings._internal();

  factory Settings() {
    return _settings;
  }

  Settings._internal();

  final String _radius = 'distanceFromCenter';
  final String _earlyDate = 'earliestTournamentDate';
  final String _lateDate = 'latestTournamentDate';
  final String _explore = 'exploreEnabled';

  /// Default values for the settings.
  final int _defaultRadius = 50;
  final int _defaultEarlyDate = _daysFromNow(0);
  final int _defaultLateDate = _daysFromNow(60);

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

    return preferences.getInt(_earlyDate) ?? _defaultEarlyDate;
  }

  Future<bool> setStartAfterDate(int date) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setInt(_earlyDate, date);
  }

  Future<int> getStartBeforeDate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getInt(_lateDate) ?? _defaultLateDate;
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
