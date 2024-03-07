import 'package:errandia/app/modules/auth/Sign%20in/view/verify_otp.dart';
import 'package:errandia/app/modules/following/view/following_view.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/app/modules/products/view/products_send_enquiry.dart';
import 'package:errandia/app/modules/profile/view/edit_profile_view.dart';
import 'package:errandia/app/modules/profile/view/profile_view.dart';
import 'package:errandia/app/modules/setting/view/about.dart';
import 'package:errandia/app/modules/setting/view/helpcenter_view.dart';
import 'package:errandia/app/modules/setting/view/invite_friends_view.dart';
import 'package:errandia/app/modules/setting/view/notification_setting_view.dart';
import 'package:errandia/app/modules/setting/view/policies&rules.dart';
import 'package:errandia/app/modules/setting/view/review_view.dart';
import 'package:errandia/app/modules/setting/view/setting_view.dart';
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
  Firebase.initializeApp();
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
