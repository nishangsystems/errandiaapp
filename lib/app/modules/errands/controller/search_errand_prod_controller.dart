import 'dart:convert';

import 'package:errandia/app/APi/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchErrandProdController extends GetxController {
  RxBool isLoading = false.obs;

  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;

  var itemList = List<dynamic>.empty(growable: true).obs;
  var productsList = List<dynamic>.empty(growable: true).obs;
  var servicesList = List<dynamic>.empty(growable: true).obs;

  void searchItem(String q) async {
    if (isLoading.isTrue || (itemList.isNotEmpty && itemList.length >= total.value)) {
      return;
    }

    try {
      isLoading.value = true;
      var response = await SearchAPI.searchItem(q, currentPage.value);
      print("Response: $response");

      var data = jsonDecode(response);

      print("Search Data: ${data['data']['data']['items']}");

      if (data['status'] == 'success') {
        total.value = data['data']['data']['total'];
        itemList.assignAll(data['data']['data']['items']);

        // filter out only products where is_service equals 0
        productsList.assignAll(itemList.where((element) => element['service'] == false).toList());
        print("Products: $productsList");
        currentPage.value++;
      } else {
        print("Error: ${data['data']['message']}");
        Get.snackbar('Error', data['data']['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    }  finally {
      isLoading.value = false;
    }
  }


  // filter out only products where is_service equals 0
  // List<dynamic> get products => itemList.where((element) => element['is_service'] == 0).toList();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
