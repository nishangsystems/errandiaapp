import 'dart:math';
import 'dart:async';

import 'package:errandia/app/APi/firebase_api.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/app/modules/profile/view/profile_view.dart';
import 'package:errandia/app/modules/splashScreen/splash_screen.dart';
import 'package:errandia/common/initialize_device.dart';
import 'package:errandia/languages/language.dart';
import 'package:errandia/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final StreamController<String?> selectNotificationStream =
StreamController<String?>.broadcast();

void _configureSelectNotificationSubject() {
  selectNotificationStream.stream.listen((String? payload) async {
   Get.to(() => Profile_view());
  });
}

void _handleMessage(RemoteMessage message) {
  print("notif message: $message");
  // Extract notification data
  final String title = message.notification?.title ?? '';
  final String body = message.notification?.body ?? '';
  final String? dataPayload = message.data['message']; // Optional data

  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails('errandia_channel_id', 'Errandia Channel',
      channelDescription: 'Errandia Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      sound: RawResourceAndroidNotificationSound('alert'),
      ticker: 'ticker');

  // Display a notification
  flutterLocalNotificationsPlugin.show(
    Random().nextInt(1000), // Notification ID
    title,
    body,
    const NotificationDetails(
      android: androidNotificationDetails,
    ),
  );

  // Handle data payload (if any)
  if (dataPayload != null) {
    print('Data payload: $dataPayload');
    // Get.to(() => Home_view());
  }
}

void _onBackgroundMessage(RemoteMessage message) async {
  // Handle FCM message received when app is in the background
  // await Firebase.initializeApp(); // Initialize Firebase if not already done
  print("notif message: $message");
  // Extract notification data
  final String title = message.notification?.title ?? '';
  final String body = message.notification?.body ?? '';
  final String? dataPayload = message.data['message']; // Optional data

  // Schedule a notification to be shown when the app comes to the foreground
  // (Adjust delay and scheduling approach as needed)
  await Future.delayed(const Duration(seconds: 5)); // Simulate some processing

  flutterLocalNotificationsPlugin.show(
    Random().nextInt(1000), // Notification ID
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'errandia_channel_id', // Replace with your channel ID
        "Errandia Channel", // Replace with your channel name
        icon: '@mipmap/ic_launcher', // Replace with your launcher icon resource name
        sound: RawResourceAndroidNotificationSound('alert'), // Replace with your sound resource name
        // ... other Android notification details (optional)
      ),
      // ... other platform-specific details
    ),
  );

  // Handle data payload (if any)
  if (dataPayload != null) {
    // Handle data based on your needs (e.g., update UI when app opens)
    // ...
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((_) {
    // Request permission for notifications if desired
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Handle background messages
    // FirebaseMessaging.onBackgroundMessage.listen(_onBackgroundMessage);
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message); // Handle the received background message
      }
      RemoteMessage message_ = const RemoteMessage(
        data: {
          'title': "Hello"

        },
        notification: RemoteNotification(
          title: "Hello",
          body: "Welcome back to Errandia 😊",
        ),
      );
      // _onBackgroundMessage(
      //    message_
      // );
      _handleMessage(message_);
    });

    // _configureSelectNotificationSubject();
    // Handle foreground and terminated messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle FCM message received when app is in foreground or terminated
      _handleMessage(message);
    });


    FirebaseMessaging.onMessage.listen((message) {
      print('onMessage: $message');
    });
  });
  await InitializeDevice().initialize();
  await GetStorage.init();

  runApp(const ErrandiaApp());
}

class ErrandiaApp extends StatelessWidget {
  const ErrandiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/errandia_logo.png'), context);
    precacheImage(const AssetImage('assets/images/errandia_logo_1.jpeg'), context);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // print('Author=> Abhishek Gupta');
    print('Errandia App is Online 👍');
    return GetMaterialApp(
      translations: Languages(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('fr', 'CA'),
      debugShowCheckedModeBanner: false,
      getPages: Routes.routes,
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: TextTheme(),
        primaryColor: Color(0xff113d6b),
        primaryTextTheme: TextTheme(),
      ),
      home: splash_screen(),

    );
  }
}
