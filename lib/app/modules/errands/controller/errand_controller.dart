import 'package:flutter/material.dart';
import 'package:get/get.dart';

class errand_controller extends GetxController{

  
}

class errand_tab_controller extends GetxController with GetSingleTickerProviderStateMixin{

  late TabController tab_controller;
  @override
  void onInit() {
    // TODO: implement onInit
    tab_controller = TabController(length: 3, vsync: this);
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tab_controller.dispose();
    super.dispose();
  }
}