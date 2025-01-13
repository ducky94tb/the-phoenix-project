import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class AppConfig {
  AppConfig._();

  dynamic _config;

  dynamic get config => _config;
  static final AppConfig instance = AppConfig._();

  Future<void> init(BuildContext context) async {
    _config = await loadJsonData();
  }

  void activateRemoteConfig(RemoteConfigUpdate? event) {}

  Future<Map<String, dynamic>> loadJsonData() async {
    // Load the JSON string from the assets
    String jsonString = await rootBundle.loadString('assets/app-config.json');

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    return jsonData;
  }
}
