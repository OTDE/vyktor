import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart' show rootBundle;

class Storage {

  final _secureStorage = FlutterSecureStorage();

  static final Storage _storage = Storage._internal();

  Storage._internal();

  factory Storage() => _storage;

  Future<void> init() async {
    final Map<String, String> apiKeys = await readApiKeys('api.keys');
    apiKeys.forEach((key, value) {
      _secureStorage.write(key: key, value: value);
    });
  }

  Future<Map<String, String>> readApiKeys(String filePath) async {
    return rootBundle.loadStructuredData(filePath, (String data) async {
      final List<String> lines = const LineSplitter().convert(data);

      final keysMap = <String, String>{};

      for (final line in lines) {
        final List<String> apiValues = line.split('=');
        keysMap.putIfAbsent(apiValues[0], () => apiValues[1]);
      }

      return keysMap;
    });
  }

  Future<String> getValue(String key) async => _secureStorage.read(key: key);

}