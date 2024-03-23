import 'package:device_uuid/device_uuid.dart';
import 'package:flutter/services.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';


class InitializeDevice {
  String _uuid = "";

  final _deviceUuidPlugin = DeviceUuid();

  late final SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    String uuid;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      uuid = await _deviceUuidPlugin.getUUID() ?? 'Unknown uuid version';

      print("uuid: $uuid");

      _prefs.setString('deviceUuid', uuid);

    } on PlatformException {
      uuid = 'Failed to get uuid version.';
    }

    _uuid = uuid;

  }
}
