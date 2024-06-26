import 'dart:convert';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/APi/business.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_controller extends GetxController {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  RxInt index = 0.obs;
  RxBool atbusiness = true.obs;
  RxBool loggedIn = false.obs;
  var isLoggedIn = false.obs;
  var currentIndex = 0.obs;


  var featuredBusinessData = List<dynamic>.empty(growable: true).obs;
  var recentlyPostedItemsData = List<dynamic>.empty(growable: true).obs;

  final RxInt selectedIndex = 0.obs; // Observes the selected navigation index
  // final RxBool loggedIn = false.obs; // Observes the user's login status
  // final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  // Add methods for handling navigation, login/logout, and any business logic required

  RxBool isRPILoading = false.obs;
  RxBool isFBLLoading = false.obs;
  RxBool isRPIError = false.obs;
  RxBool isFBLError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedBusinessesData();
    fetchRecentlyPostedItemsData();
  }

  void fetchRecentlyPostedItemsData() async {
    try {
      isRPILoading.value = true;

      var data = await api().getErrands(1);
      print("response recently posted: $data");

      if (data != null) {
        recentlyPostedItemsData.addAll(data['items']);
        isRPILoading.value = false;
        isRPIError.value = false;
      } else {
        // Handle error
        printError(info: 'Failed to load recently posted items');
        isRPILoading.value = false;
        isRPIError.value = false;
      }
    } catch (e) {
      // Handle exception
      printError(info: e.toString());
      isRPILoading.value = false;
      isRPIError.value = true;
    }
  }

  void fetchFeaturedBusinessesData() async {
    try {
      isFBLLoading.value = true;

      var businesses = await BusinessAPI.businesses(1);
      print("response featured: $businesses");

      if (businesses != null && businesses.isNotEmpty) {
        isFBLLoading.value = false;
        isFBLError.value = false;
        featuredBusinessData.addAll(businesses);
        print("featured: ${businesses.isNotEmpty}");
      } else {
        // Handle error
        printError(info: 'Failed to load featured businesses');
        isFBLLoading.value = false;
        isFBLError.value = false;
      }
    } catch (e) {
      // Handle exception
      print('error FBL: $e');
      printError(info: e.toString());
      isFBLLoading.value = false;
      isFBLError.value = true;
    }
  }

  // Reload function for recently posted items
  void reloadRecentlyPostedItems() {
    recentlyPostedItemsData.clear();
    isRPILoading.value = true;
    isRPIError.value = false;
    fetchRecentlyPostedItemsData();
  }

  // Reload function for featured businesses
  void reloadFeaturedBusinessesData() {
    featuredBusinessData.clear();
    isFBLLoading.value = true;
    fetchFeaturedBusinessesData();
  }

  void openDrawer() {
    scaffoldkey.currentState!.openEndDrawer();
  }

  void closeDrawer() {
    scaffoldkey.currentState!.closeEndDrawer();
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  void loadIsLoggedIn() async {
    var isLoggedIn = await checkLogin();
    loggedIn.value = isLoggedIn != null && isLoggedIn.isNotEmpty;

    print('INIT: Is logged in: $isLoggedIn');
  }

  Future<String?> checkLogin() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedpref.getString('token');
    print('Is logged in: $isLoggedIn');
    return isLoggedIn;
  }

  Future<bool> isUserLoggedIn() async {
    // Implement logic to check if user is logged in
    var sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('token') != null;
  }

  void checkLoginStatus() async {
    // Logic to check login status
    isLoggedIn.value = await isUserLoggedIn();
  }

}
