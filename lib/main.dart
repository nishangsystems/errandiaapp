import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:errandia/app/APi/firebase_api.dart';
import 'package:errandia/app/modules/errands/view/errand_view.dart';
import 'package:errandia/app/modules/errands/view/errand_view_no_bar.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/app/modules/notifications/notifications_view.dart';
import 'package:errandia/app/modules/profile/view/profile_view.dart';
import 'package:errandia/app/modules/splashScreen/splash_screen.dart';
import 'package:errandia/app/modules/subscription/view/manage_subscription_view.dart';
import 'package:errandia/common/initialize_device.dart';
import 'package:errandia/languages/language.dart';
import 'package:errandia/routes.dart';
import 'package:errandia/utils/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

late FirebaseMessaging messaging;
late SharedPreferences _prefs;
AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  channel!.id,
  channel!.name,
  icon: '@mipmap/ic_launcher',
  sound: const RawResourceAndroidNotificationSound('alert'),
  largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
  channelShowBadge: true,
  autoCancel: true,
  styleInformation: DefaultStyleInformation(true, true),
  setAsGroupSummary: true,
  importance: Importance.max,
  priority: Priority.high,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print('Handling a background data ${message.data}');
  print('Handling a background title ${message.notification?.title}');
  print('Handling a background body ${message.notification?.body}');

  flutterLocalNotificationsPlugin!.show(
    Random().nextInt(1000),
    message.notification?.title,
    message.notification?.body,
    NotificationDetails(
      android: androidPlatformChannelSpecifics,
    ),
  );
}

void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification payload: ${notificationResponse}');

  if (notificationResponse.payload != null) {
    onSelectNotification(notificationResponse.payload);
  }
}

Future<dynamic> onSelectNotification(payload) async {
  Map<String, dynamic> action = jsonDecode(payload);
  _handleMessage(action);
}

Future<void> setupInteractedMessage() async {
  await FirebaseMessaging.instance
      .getInitialMessage()
      .then((value) => _handleMessage(value != null ? value.data : Map()));
}

void _handleMessage(Map<String, dynamic> data) {
  if (data['page'] == "subscription") {
    Get.to(() => const subscription_view());
  }

  if (data['page'] == 'received_errands') {
    Get.to(() => const errand_view());
  }

  if (data['page'] == 'notification') {
    Get.to(() => NotificationDetailView(
        notifId: data['details']['id'],
        title: data['details']['title'],
        date: data['details']['created_at'],
        message: data['details']['message'])
    );
  }
}

void _showNotifications(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    String action = jsonEncode(message.data);

    flutterLocalNotificationsPlugin!.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      payload: action,
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await InitializeDevice().initialize();
  await GetStorage.init();
  await ErrandiaApp._initializePrefs();

  await getActiveSubscription();

  messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  //If subscribe based sent notification then use this token
  // final fcmToken = await messaging.getToken();
  // print(fcmToken);

  // await messaging.subscribeToTopic('flutter_notification');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
      'errandia_channel_id',
      'Errandia Channel',
      sound: RawResourceAndroidNotificationSound('alert'),
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
      showBadge: true,
      playSound: true);

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const android =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const iOS = DarwinInitializationSettings();
  const initSettings = InitializationSettings(android: android, iOS: iOS);

  await flutterLocalNotificationsPlugin!.initialize(initSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

  await messaging
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen(_showNotifications);

  FirebaseMessaging.onMessageOpenedApp.listen((message) => _handleMessage(message.data));

  runApp(const ErrandiaApp());
}

class ErrandiaApp extends StatelessWidget {
  const ErrandiaApp({super.key});

  static Future<void> _initializePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    var fcmToken = _prefs.getString('firebaseToken');
    print("fcmToken: $fcmToken");
  }

  // return loaded prefs
  static SharedPreferences get prefs => _prefs;

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
