import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// TODO: document more robustly once fully integrated.
///
/// Basic shared preferences helper. Will be fairly straightforward to
/// plug in, since the existence of the shared preferences inside the phone
/// acts like a sort of pseudo-bloc with ez in and out points.
class Settings {

  final String _radius = 'distanceFromCenter';
  final String _earlyDate = 'earliestTournamentDate';
  final String _lateDate = 'latestTournamentDate';

  /// Default values for the settings.
  final double _defaultRadius = 50.0;
  final int _defaultEarlyDate = _daysFromNow(0);
  final int _defaultLateDate = _daysFromNow(60);

  static int _daysFromNow(int numOfDays) =>
      (DateTime.now().add(Duration(days: numOfDays))).millisecondsSinceEpoch;

  Future<double> getRadiusInMiles() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getDouble(_radius) ?? _defaultRadius;
  }

  Future<bool> setRadiusInMiles(double radius) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setDouble(_radius, radius);
  }

  Future<int> getEarlyDate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getInt(_earlyDate) ?? _defaultEarlyDate;
  }

  Future<bool> setEarlyDate(int date) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setInt(_earlyDate, date);
  }

  Future<int> getLateDate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getInt(_lateDate) ?? _defaultLateDate;
  }

  Future<bool> setLateDate(int date) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.setInt(_lateDate, date);
  }
}
