import 'dart:convert';

import 'package:errandia/app/APi/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchErrandProdController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSearchError = false.obs;

  RxBool isProductLoading = false.obs;
  RxBool isProductSearchError = false.obs;

  RxBool isServiceLoading = false.obs;
  RxBool isServiceSearchError = false.obs;

  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;
  RxInt productCurrentPage = 1.obs;
  RxInt productTotal = 0.obs;
  RxInt serviceCurrentPage = 1.obs;
  RxInt serviceTotal = 0.obs;

  var itemList = List<dynamic>.empty(growable: true).obs;
  var serviceItemList = List<dynamic>.empty(growable: true).obs;
  var productItemList = List<dynamic>.empty(growable: true).obs;
  var productsList = List<dynamic>.empty(growable: true).obs;
  var servicesList = List<dynamic>.empty(growable: true).obs;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController drawerSearchCtl = TextEditingController();

  RxString regionCode = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  void searchItem(String q) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString("previousQuery", q);

    if (isLoading.isTrue || (itemList.isNotEmpty && itemList.length >= total.value)) {
      return;
    }

    try {
      isLoading.value = true;
      var response = await SearchAPI.searchItem(q, currentPage.value, region: regionCode.value);
      print("Response: $response");

      var data = jsonDecode(response);

      print("Search Data: ${data['data']['data']['items']}");

      if (data['status'] == 'success') {
        total.value = data['data']['data']['total'];
        itemList.assignAll(data['data']['data']['items']);

        // // filter out only products where is_service equals 0
        // productsList.assignAll(itemList.where((element) => element['is_service'] == 0).toList());
        // print("Products: $productsList");
        //
        // // filter out only services where is_service equals 1
        // servicesList.assignAll(itemList.where((element) => element['is_service'] == 1).toList());
        // print("Services: $servicesList");
        currentPage.value++;

        isSearchError.value = false;
      } else {
        print("Error: ${data['data']['message']}");
        isSearchError.value = true;
        Get.snackbar('Error', data['data']['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch(e) {
      print("Error: $e");
      isSearchError.value = true;
      Get.snackbar('Error', 'An error occurred, please try again later',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchItemServices(String q) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString("previousQuery", q);

    if (isServiceLoading.isTrue || (serviceItemList.isNotEmpty && serviceItemList.length >= serviceTotal.value)) {
      return;
    }

    try {
      isServiceLoading.value = true;
      var response = await SearchAPI.searchItem(q, serviceCurrentPage.value, service: '1', region: regionCode.value);
      print("Service Response: $response");

      var data = jsonDecode(response);

      print("Search Data: ${data['data']['data']['items']}");

      if (data['status'] == 'success') {
        serviceTotal.value = data['data']['data']['total'];
        serviceItemList.assignAll(data['data']['data']['items']);

        print("Services: $serviceItemList");
        serviceCurrentPage.value++;

        isServiceSearchError.value = false;
      } else {
        print("Error: ${data['data']['message']}");
        isServiceSearchError.value = true;
        Get.snackbar('Error', data['data']['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch(e) {
      print("Error: $e");
      isServiceSearchError.value = true;
      Get.snackbar('Error', 'An error occurred, please try again later',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isServiceLoading.value = false;
    }
  }

  void searchItemProducts(String q) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString("previousQuery", q);

    if (isProductLoading.isTrue || (productItemList.isNotEmpty && productItemList.length >= productTotal.value)) {
      return;
    }

    try {
      isProductLoading.value = true;
      var response = await SearchAPI.searchItem(q, productCurrentPage.value, service: '0', region: regionCode.value);
      print("Response: $response");

      var data = jsonDecode(response);

      print("Search Data: ${data['data']['data']['items']}");

      if (data['status'] == 'success') {
        productTotal.value = data['data']['data']['total'];
        productItemList.assignAll(data['data']['data']['items']);

        print("Products: $productItemList");
        productCurrentPage.value++;

        isProductSearchError.value = false;
      } else {
        print("Error: ${data['data']['message']}");
        isProductSearchError.value = true;
        Get.snackbar('Error', data['data']['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch(e) {
      print("Error: $e");
      isProductSearchError.value = true;
      Get.snackbar('Error', 'An error occurred, please try again later',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProductLoading.value = false;
    }
  }

  void searchFilter(regionCode) async {
    final SharedPreferences prefs = await _prefs;

    if (isLoading.isTrue || (itemList.isNotEmpty && itemList.length >= total.value)) {
      return;
    }

    try {
      isLoading.value = true;
      var response = await SearchAPI.searchItem(regionCode, currentPage.value, region: regionCode);
      print("Filter Response: $response");

      var data = jsonDecode(response);

      print("Search Data: ${data['data']['data']['items']}");

      if (data['status'] == 'success') {
        total.value = data['data']['data']['total'];
        itemList.assignAll(data['data']['data']['items']);

        currentPage.value++;

        isSearchError.value = false;
      } else {
        print("Error: ${data['data']['message']}");
        isSearchError.value = true;
        Get.snackbar('Error', data['data']['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } catch(e) {
      print("Error: $e");
      isSearchError.value = true;
      Get.snackbar('Error', 'An error occurred, please try again later',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void reloadAll() async {
    final SharedPreferences prefs = await _prefs;

    itemList.clear();
    productsList.clear();
    servicesList.clear();
    currentPage.value = 1;
    total.value = 0;
    // searchItem with previous query
    var q = prefs.getString("previousQuery");
    if (q != null) {
      searchItem(q);
    }
  }

  void reloadServices() async {
    final SharedPreferences prefs = await _prefs;

    serviceItemList.clear();
    servicesList.clear();
    serviceCurrentPage.value = 1;
    productTotal.value = 0;
    // searchItem with previous query
    var q = prefs.getString("previousQuery");
    if (q != null) {
      searchItemServices(q);
    }
  }

  void reloadProducts() async {
    final SharedPreferences prefs = await _prefs;

    productItemList.clear();
    productsList.clear();
    productCurrentPage.value = 1;
    productTotal.value = 0;
    // searchItem with previous query
    var q = prefs.getString("previousQuery");
    if (q != null) {
      searchItemProducts(q);
    }
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
