import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Settings {

  static const Settings _settings = Settings._internal();

  factory Settings() => _settings;

  const Settings._internal();

  // Settings keys
  static const String _radius = 'distanceFromCenter';
  static const String _afterDate = 'earliestTournamentDate';
  static const String _beforeDate = 'latestTournamentDate';
  static const String _explore = 'exploreEnabled';

  // Default values for the settings.
  static const int _defaultRadius = 50;
  static int _defaultAfterDate = _daysFromNow(0);
  static int _defaultBeforeDate = _daysFromNow(60);

  // Getters and setters for the settings. Self-explanatory.

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

    return preferences.getInt(_afterDate) ?? _defaultAfterDate;
  }

  Future<bool> setStartAfterDate(int date) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setInt(_afterDate, date);
  }

  Future<int> getStartBeforeDate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getInt(_beforeDate) ?? _defaultBeforeDate;
  }

  Future<bool> setStartBeforeDate(int date) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setInt(_beforeDate, date);
  }

  Future<bool> getExploreMode() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getBool(_explore) ?? false;
  }

  Future<bool> setExploreMode(bool isEnabled) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setBool(_explore, isEnabled);
  }

  Future<void> clear() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.clear();
  }

  Future<void> clearStartAfterDate() async {
    await setStartAfterDate(_defaultAfterDate);
  }

  Future<void> clearStartBeforeDate() async {
    await setStartBeforeDate(_defaultBeforeDate);
  }

}
