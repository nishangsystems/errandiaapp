import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/ServiceItemModel.dart';

class manage_service_controller extends GetxController {
  RxString manage_service_sort_group_value = 'sort descending'.obs;

  RxList<service_widget_item> all_serviceList = <service_widget_item>[].obs;
  RxList<service_widget_item> publishedList = <service_widget_item>[].obs;
  RxList<service_widget_item> DraftList = <service_widget_item>[].obs;
  RxList<service_widget_item> TrashedList = <service_widget_item>[].obs;

  void addService(String imagepath, int cost, String type, String title) {
    service_widget_item item = service_widget_item(
        cost: cost, title: title, imagepath: imagepath, type: type);
    if (type == 'publish') {
      publishedList.add(item);
    } else if (type == 'draft') {
      DraftList.add(item);
    } else {
      TrashedList.add(item);
    }
  }
  void removeItem(int index, String type)
{
  if (type == 'publish') {
      publishedList.removeAt(index);
    } else if (type == 'draft') {
      DraftList.removeAt(index);
    } else {
      
      TrashedList.removeAt(index);
    }
}
}




class manage_service_tab_controller extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void onInit() {
    // TODO: implement onInit
    tabController = TabController(length: 4, vsync: this);

    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }
}
