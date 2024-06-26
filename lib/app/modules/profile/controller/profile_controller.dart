import 'dart:convert';

import 'package:errandia/app/APi/business.dart';
import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile_controller extends GetxController {
  final TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();

  RxInt tabControllerindex = 0.obs;
  RxBool isFullNameValid = false.obs;
  RxBool isEmailValid = false.obs;
  RxBool isPhoneValid = false.obs;
  RxBool isWhatsappValid = false.obs;

  RxBool isLoading = false.obs;
  RxBool isProductLoading = false.obs;
  RxBool isServiceLoading = false.obs;

  RxInt currentPage = 1.obs;
  RxInt productCurrentPage = 1.obs;
  RxInt serviceCurrentPage = 1.obs;

  RxInt total = 0.obs;
  RxInt productTotal = 0.obs;
  RxInt serviceTotal = 0.obs;

  var itemList = List<dynamic>.empty(growable: true).obs;
  var productItemList = List<dynamic>.empty(growable: true).obs;
  var serviceItemList = List<dynamic>.empty(growable: true).obs;

  RxBool isError = false.obs;
  RxBool isProductError = false.obs;
  RxBool isServiceError = false.obs;

  RxMap<String, dynamic> userData = RxMap<String, dynamic>();

  RxBool isValidWhatsappNumber = false.obs;

  @override
  void onInit() {
    super.onInit();
    whatsappController.addListener(updateWhatsappNumberValidity);
    getUser();
    loadMyBusinesses();
    loadMyProducts();
    loadMyServices();
  }

  void updateWhatsappNumberValidity() {
    isValidWhatsappNumber.value =
        whatsappController.text.isNotEmpty && RegExp(phonePattern).hasMatch(whatsappController.text);
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user');
    // user image
    String? userProfileImg = prefs.getString('userProfileImg');
    if (userDataString != null) {
      print("user data: $userDataString");
      userData.value = jsonDecode(userDataString);
      print("prof img: ${userData.value}");
    }
    print("user profile image: ${userData['photo']}");
  }

  void loadMyBusinesses() async {
    print("fetching my businesses");
    if (isLoading.isTrue ||
        (itemList.isNotEmpty && itemList.length >= total.value)) return;

    isLoading.value = true;

    try {
      print("current page: ${currentPage.value}");

      var data = await BusinessAPI.userShops_(currentPage.value);
      print("my shops response: $data");

      if (data != null && data.isNotEmpty) {
        currentPage.value++;
        isLoading.value = false;
        // parse total to an integer
        total.value = data['total'];
        // print("total_: ${total.value}");
        itemList.addAll(data['items']);
        // itemList.sort((a, b) => a['name'].compareTo(b['name']));
        print("my itemList: $itemList");
      }
      update();
    } catch (e) {
      isError.value = true;
      isLoading.value = false;
      print("error loading businesses: $e");
    }
  }

  void loadMyProducts() async {
    print("fetching my products");
    if (isProductLoading.isTrue ||
        (productItemList.isNotEmpty &&
            productItemList.length >= productTotal.value)) return;

    try {
      isProductLoading.value = true;
      print("current page: ${productCurrentPage.value}");

      var data = await BusinessAPI.userProducts(productCurrentPage.value);
      print("my products response: $data");

      if (data != null && data.isNotEmpty) {
        productCurrentPage.value++;
        isProductLoading.value = false;
        // parse total to an integer
        productTotal.value = data['total'];
        // print("total_: ${total.value}");
        productItemList.addAll(data['items']);
        print("productItemList: $productItemList");
      }
      // update();
    } catch (e) {
      isProductError.value = true;
      isProductLoading.value = false;
      print("error loading products: $e");
    } finally {
      update();
    }
  }

  void loadMyServices() async {
    print("fetching my services");
    if (isServiceLoading.isTrue ||
        (serviceItemList.isNotEmpty &&
            serviceItemList.length >= serviceTotal.value)) return;

    try {
      isServiceLoading.value = true;
      print("current page: ${serviceCurrentPage.value}");

      var data = await BusinessAPI.userServices(serviceCurrentPage.value);
      print("my services response: $data");

      if (data != null && data.isNotEmpty) {
        serviceCurrentPage.value++;
        isServiceLoading.value = false;
        // parse total to an integer
        serviceTotal.value = data['total'];
        // print("total_: ${total.value}");
        serviceItemList.addAll(data['items']);
        print("serviceItemList: $serviceItemList");
      }
      update();
    } catch (e) {
      isServiceError.value = true;
      isServiceLoading.value = false;
      print("error loading services: $e");
    }
  }

  void reloadMyBusinesses() {
    currentPage.value = 1;
    isError.value = false;
    itemList.clear();
    loadMyBusinesses();
    update();
  }

  void reloadMyProducts() {
    productCurrentPage.value = 1;
    isProductError.value = false;
    productItemList.clear();
    loadMyProducts();
    update();
  }

  void reloadMyServices() {
    serviceCurrentPage.value = 1;
    isServiceError.value = false;
    serviceItemList.clear();
    loadMyServices();
    update();
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  List<errandia_widget> product_list = [
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/er2.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/ui_23_item.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/ui_23_item.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/er2.png',
      name: 'hello',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/ui_23_item.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/er2.png',
      name: 'hello',
      location: 'Akwa, Douala',
    ),
  ];
  List<errandia_widget> service_list = [
    errandia_widget(
      cost: '5000',
      imagePath: 'assets/images/service-image.png',
      name: 'Low Cut',
      location: 'Molyko, Buea',
    ),
    errandia_widget(
      cost: '5000',
      imagePath: 'assets/images/boy2.png',
      name: 'Hair Dye',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/boy3.png',
      name: 'Low cut',
      location: 'Molyko, Buea',
    ),
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/boy4.png',
      name: 'hair dye',
      location: 'Akwa, Douala',
    ),
  ];

  List<errandia_widget> Buiseness_list = [
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/er2.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/ui_23_item.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
    errandia_widget(
      cost: '1000',
      imagePath: 'assets/images/er2.png',
      name: 'wax',
      location: 'Akwa, Douala',
    ),
  ];
}
