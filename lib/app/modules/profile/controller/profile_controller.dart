import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class profile_controller extends GetxController {

  RxInt tabControllerindex= 0.obs;
  RxBool isFullNameValid = false.obs;
  RxBool isEmailValid = false.obs;
  RxBool isPhoneValid = false.obs;
  RxBool isWhatsappValid = false.obs;

  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  List<errandia_widget> product_list = [
    errandia_widget(
      cost: 'XAF 1000',
      imagePath: 'assets/images/er2.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: 'XAF 1000',
      imagePath: 'assets/images/ui_23_item.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: 'XAF 1000',
      imagePath: 'assets/images/ui_23_item.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: 'XAF 1000',
      imagePath: 'assets/images/er2.png',
      name: 'hello',
      location: 'Akwa, Douala',
    ),

  ];
  List<errandia_widget> service_list = [
    errandia_widget(
      cost: 'XAF 5000',
      imagePath: 'assets/images/service-image.png',
      name: 'Low Cut',
      location: 'Molyko, Buea',
    ),
    errandia_widget(
      cost: 'XAF 5000',
      imagePath: 'assets/images/boy2.png',
      name: 'Hair Dye',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: 'XAF 1000',
      imagePath: 'assets/images/boy3.png',
      name: 'Low cut',
      location: 'Molyko, Buea',
    ),
    errandia_widget(
      cost: 'XAF 1000',
      imagePath: 'assets/images/boy4.png',
      name: 'hair dye',
      location: 'Akwa, Douala',
    ),

  ];

  List<errandia_widget> Buiseness_list = [
    errandia_widget(
      cost: 'XAF 1000',
      imagePath: 'assets/images/er2.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: 'XAF 1000',
      imagePath: 'assets/images/ui_23_item.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: 'XAF 1000',
      imagePath: 'assets/images/er2.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),

  ];
}
