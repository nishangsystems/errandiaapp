
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;

  late final SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _firebaseMessaging.getToken().then((token) {
      print('Firebase Token: $token');

      // send token to server

      // save token to shared preferences
      _prefs.setString('firebaseToken', token!);
    });
  }
}