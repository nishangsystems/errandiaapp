import 'package:errandia/app/modules/manage_review/model/manage_review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class manage_review_controller extends GetxController {
  RxList<manage_review_model> review_list = <manage_review_model>[
    manage_review_model(
      title: 'Sierra Deckow MD',
      tag: 'Universal laptop Charger',
      Date: '1 Apr 2023',
      description:
          'Odit qui molestiae dolorem molestiae corrupti. Commodi ut et explicabo',
      image_url: 'assets/images/home-featuredBusiness-img-3.png',
      rating: 4.5,
    ),
    manage_review_model(
      title: 'Harley Zieme',
      tag: 'Universal laptop Charger',
      Date: '2 Mar 2023',
      description:
          'Odit qui molestiae dolorem molestiae corrupti. Commodi ut et explicabo',
      image_url: 'assets/images/following-imgThumb-3.png',
      rating: 4.5,
    ),
    manage_review_model(
      title: 'Sierra Deckow MD',
      tag: 'Universal laptop Charger',
      Date: '1 Apr 2023',
      description:
          'Odit qui molestiae dolorem molestiae corrupti. Commodi ut et explicabo',
      image_url: 'assets/images/home-featuredBusiness-img-3.png',
      rating: 4.5,
    ),
    manage_review_model(
      title: 'Harley Zieme',
      tag: 'Universal laptop Charger',
      Date: '2 Mar 2023',
      description:
          'Odit qui molestiae dolorem molestiae corrupti. Commodi ut et explicabo',
      image_url: 'assets/images/following-imgThumb-3.png',
      rating: 4.5,
    ),
  ].obs;
}

class manage_review_tab_controller extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tab_controller;
  @override
  void onInit() {
    tab_controller = TabController(length: 3, vsync: this);
    super.onInit();
  }

  @override
  void dispose() {
    tab_controller.dispose();
    super.dispose();
  }
}