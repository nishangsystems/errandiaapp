import 'dart:async';

import 'package:errandia/app/modules/auth/Register/register_ui.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/app/uis/getStartedScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whertogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xff113d6b),
      body: SafeArea(
        child: Center(
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            height: Get.height * 0.35,
          ),
        ),
      ),
    );
  }
  Future whertogo() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedpref.getString('token');
    print(isLoggedIn);
    Timer(Duration(seconds: 2,), () async {
      if (isLoggedIn != null) {
        if(isLoggedIn !=  ''){
          Get.offAll(Home_view());
        }else{
          Get.offAll( get_started_screen(),);
        }
      } else {
        Get.offAll( get_started_screen(),);
      }
    });
  }
}
