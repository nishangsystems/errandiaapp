import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/APi/errands.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class errand_controller extends GetxController{

  RxBool isErrandLoading = false.obs;
  RxBool isErrandError = false.obs;

  RxBool isMyErrandLoading = false.obs;
  RxBool isMyErrandError = false.obs;

  RxBool isRegionSelected = false.obs;
  RxBool isTownsLoading = false.obs;

  RxBool isReceivedLoading = false.obs;
  RxBool isReceivedError = false.obs;

  var errandList = List<dynamic>.empty(growable: true).obs;
  var myErrandList = List<dynamic>.empty(growable: true).obs;
  var townList = RxList<dynamic>([]);
  var receivedList = List<dynamic>.empty(growable: true).obs;

  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;

  RxInt myCurrentPage = 1.obs;
  RxInt myTotal = 0.obs;

  RxInt receivedCurrentPage = 1.obs;
  RxInt receivedTotal = 0.obs;

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

  void fetchMyErrands() async {
    print("fetching my errands");
    if (isMyErrandLoading.isTrue || (
    myErrandList.isNotEmpty && myErrandList.length >= myTotal.value)) return;

    isMyErrandLoading.value = true;

    try {
      var data = await ErrandsAPI.getMyErrands(myCurrentPage.value);
      print("response my errands: $data");

      if (data != null && data.isNotEmpty) {
        myCurrentPage.value++;
        myErrandList.addAll(data['items']);
        myTotal.value = data['total'];
        isMyErrandLoading.value = false;
        isMyErrandError.value = false;

        print("myErrandList: $myErrandList");
      }

      update();
    } catch (e) {
      // Handle exception
      printError(info: e.toString());
      isMyErrandLoading.value = false;
      isMyErrandError.value = true;
    }
  }

  void fetchReceivedErrands() async {
    print("fetching received errands");
    if (isReceivedLoading.isTrue || (
    receivedList.isNotEmpty && receivedList.length >= receivedTotal.value)) return;

    isReceivedLoading.value = true;

    try {
      var data = await ErrandsAPI.getErrandsReceived(receivedCurrentPage.value);
      print("response received errands: $data");

      if (data != null && data.isNotEmpty) {
        receivedCurrentPage.value++;
        receivedList.addAll(data['items']);
        receivedTotal.value = data['total'];
        isReceivedLoading.value = false;
        isReceivedError.value = false;

        print("receivedList: $receivedList");
      }

      update();
    } catch (e) {
      // Handle exception
      printError(info: e.toString());
      isReceivedLoading.value = false;
      isReceivedError.value = true;
    }
  }

  void loadTownsData(regionId) async {
    // Towns.Items = [];
    townList.clear();
    print("townList cleared: $townList");

    isTownsLoading.value = true;

    var data = await api().getTownsByRegion(regionId);
    print("towns data: $data");

    isTownsLoading.value = false;

    if (data != null && data.isNotEmpty) {
      final uniqueTowns = data.toSet().toList();
      townList.addAll(uniqueTowns);
      // Towns.Items = List.from(data)
      //     .map<Town>((town) => Town.fromJson(town))
      //     .toList();
    }

    update();
    print("towns: $townList");
  }

  void reloadErrands() {
    errandList.clear();
    currentPage.value = 1;
    total.value = 0;
    fetchErrands();
    update();
  }

  void reloadMyErrands() {
    myErrandList.clear();
    myCurrentPage.value = 1;
    myTotal.value = 0;
    fetchMyErrands();
    update();
  }

  void reloadReceivedErrands() {
    receivedList.clear();
    receivedCurrentPage.value = 1;
    receivedTotal.value = 0;
    isReceivedError.value = false;
    fetchReceivedErrands();
    update();
  }
  
}

class errand_tab_controller extends GetxController with GetSingleTickerProviderStateMixin{

  late TabController tab_controller;
  var tabIndex = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    tab_controller = TabController(length: 2, vsync: this);
    tab_controller.addListener(() {
      tabIndex.value = tab_controller.index; // Update the observable on index change
    });
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tab_controller.dispose();
    super.dispose();
  }
}