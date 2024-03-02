import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class errand_controller extends GetxController{

  RxBool isErrandLoading = false.obs;
  RxBool isErrandError = false.obs;

  var errandList = List<dynamic>.empty(growable: true).obs;

  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchErrands();
  }

  void fetchErrands() async {
    print("fetching errands");
    if (isErrandLoading.isTrue || (
    errandList.isNotEmpty && errandList.length >= total.value)) return;

    isErrandLoading.value = true;

    try {
      var data = await api().getErrands(currentPage.value);
      print("response errands: $data");

      if (data != null && data.isNotEmpty) {
        currentPage.value++;
        errandList.addAll(data['items']);
        total.value = data['total'];
        isErrandLoading.value = false;
        isErrandError.value = false;

        print("errandList: $errandList");
      }

      update();
    } catch (e) {
      // Handle exception
      printError(info: e.toString());
      isErrandLoading.value = false;
      isErrandError.value = true;
    }
  }

  void reloadErrands() {
    errandList.clear();
    currentPage.value = 1;
    total.value = 0;
    fetchErrands();
    update();
  }
  
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