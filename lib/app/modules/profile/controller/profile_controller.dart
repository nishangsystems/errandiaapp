import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class profile_controller extends GetxController {

  RxInt tabControllerindex= 0.obs;

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
      imagePath: 'assets/images/boy1.png',
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
