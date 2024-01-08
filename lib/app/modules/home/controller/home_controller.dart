import 'package:flutter/material.dart';
import 'package:get/get.dart';

class home_controller extends GetxController{
  var scaffoldkey= GlobalKey<ScaffoldState>();
  RxInt index= 0.obs;
  RxBool atbusiness=true.obs;
  

  void openDrawer(){
    scaffoldkey.currentState!.openEndDrawer();
  }

  void closeDrawer(){
    scaffoldkey.currentState!.closeEndDrawer();
  }
}