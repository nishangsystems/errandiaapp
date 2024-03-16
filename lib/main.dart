import 'package:errandia/app/APi/firebase_api.dart';
import 'package:errandia/app/modules/splashScreen/splash_screen.dart';
import 'package:errandia/languages/language.dart';
import 'package:errandia/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAPI().initialize();
  await GetStorage.init();

  runApp(const ErrandiaApp());
}

class ErrandiaApp extends StatelessWidget {
  const ErrandiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/errandia_logo.png'), context);

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
