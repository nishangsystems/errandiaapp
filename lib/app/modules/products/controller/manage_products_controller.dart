import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/manage_products_view.dart';

class manage_product_controller extends GetxController {
  RxString allProducts_sort_group_value = 'sort descending'.obs;
}

class manage_product_tabController extends GetxController
    with GetSingleTickerProviderStateMixin {
 

  late TabController tabController;
  @override
  void onInit() {
    // TODO: implement onInit
    tabController = TabController(length:4, vsync: this);
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  
}
