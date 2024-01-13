import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_controller extends GetxController {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  RxInt index = 0.obs;
  RxBool atbusiness = true.obs;
  RxBool loggedIn = false.obs;

  void openDrawer() {
    scaffoldkey.currentState!.openEndDrawer();
  }

  void closeDrawer() {
    scaffoldkey.currentState!.closeEndDrawer();
  }

  void loadIsLoggedIn() async {
    var isLoggedIn = await checkLogin();
    loggedIn.value =
        isLoggedIn != null && isLoggedIn.isNotEmpty;

    print('INIT: Is logged in: $isLoggedIn');
  }

  Future<String?> checkLogin() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedpref.getString('token');
    print('Is logged in: $isLoggedIn');
    return isLoggedIn;
  }
}