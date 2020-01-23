import 'dart:async';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference<T> {
  final String key;
  final T defaultValue;
  Preference({@required this.key, this.defaultValue});

  Future<SharedPreferences> get _preferenceInstance async => await SharedPreferences.getInstance();

  Future<T> get value async {
    final preferences = await _preferenceInstance;
    return preferences.get(key);
  }

  Future<bool> setValue(T value) async {
    final preferences = await _preferenceInstance;
    if (value is int) {
      return preferences.setInt(key, value);
    } else if (value is double) {
      return preferences.setDouble(key, value);
    } else if (value is bool) {
      return preferences.setBool(key, value);
    } else if (value is String) {
      return preferences.setString(key, value);
    } else if (value is List<String>) {
      return preferences.setStringList(key, value);
    }
    throw UnsupportedError('No settings support for value $value');
  }
}