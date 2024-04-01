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

  var errandList = List<dynamic>.empty(growable: true).obs;
  var myErrandList = List<dynamic>.empty(growable: true).obs;
  var townList = RxList<dynamic>([]);

  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;

  RxInt myCurrentPage = 1.obs;
  RxInt myTotal = 0.obs;

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