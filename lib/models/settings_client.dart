import 'dart:async';

import 'models.dart';

class SettingsClient {

  static const SettingsClient _settingsClient = SettingsClient._internal();

  factory SettingsClient() => _settingsClient;

  const SettingsClient._internal();

  static int _daysFromNow(int numOfDays) =>
      (DateTime.now().add(Duration(days: numOfDays))).millisecondsSinceEpoch;

  static var _radius = Preference<double>(key: 'radius', defaultValue: 50.0);
  static var _afterDate = Preference<int>(key: 'afterDate', defaultValue: _daysFromNow(0));
  static var _beforeDate = Preference(key: 'beforeDate', defaultValue: _daysFromNow(60));
  static var _exploreModeEnabled = Preference<bool>(key: 'exploreModeEnabled', defaultValue: false);

  static var _settings = [_radius, _afterDate, _beforeDate, _exploreModeEnabled];

  Future<bool> init() async {
    var didInitializeSettings = true;
    for (Preference setting in _settings) {
      didInitializeSettings &= await setting.setValue(setting.defaultValue);
    }
    return didInitializeSettings;
  }

  Future<double> get radius async => await _radius.value;
  Future<bool> setRadius(double value) async => await _radius.setValue(value);

  Future<int> get afterDate async => await _afterDate.value;
  Future<bool> setAfterDate(int value) async => await _afterDate.setValue(value);

  Future<int> get beforeDate async => await _beforeDate.value;
  Future<bool> setBeforeDate(int value) async => await _beforeDate.setValue(value);

  Future<bool> get exploreModeEnabled async => await _exploreModeEnabled.value;
  Future<bool> setExploreModeEnabled(bool value) async => await _exploreModeEnabled.setValue(value);

}




