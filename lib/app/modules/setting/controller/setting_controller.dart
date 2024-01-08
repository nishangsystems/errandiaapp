import 'package:errandia/app/modules/setting/model/friends_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class setting_controller extends GetxController{

  RxString language= 'English'.obs;
  RxString groupValue= 'English'.obs;
}

class notification_controller extends GetxController {
  RxList<bool> buttons = <bool>[
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ].obs;
}

class invite_friends_controller extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt selected = 0.obs;
  
  
  RxList<friends_model> list = <friends_model>[
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Kaia West',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Kaia West',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Kaia West',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Eudora Nola',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Kaia West',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Nola Nola',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Eudora West',
    ),
  
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Kaia West',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Kaia West',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Kaia West',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Eudora Nola',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Kaia West',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Nola Nola',
    ),
    friends_model(
      image_url: '',
      isSelected: false.obs,
      phone_number: '48978439843',
      title: 'Eudora West',
    ),

  ].obs;

  void selectAll() {
    if (selected.value == list.length) {
      selected.value = 0;
      for (int i = 0; i < list.length; i++) list[i].isSelected.value= false;
    } else {
      selected.value = list.length;
      for (int i = 0; i < list.length; i++) list[i].isSelected.value = true;
    }
  }

  void select_deselect(int index) {
    if (list[index].isSelected == true) {
      list[index].isSelected.value = false;
      selected.value--;
    } else {
      list[index].isSelected.value = true;
      selected.value++;
    }
  }

  late TabController tabController;
  RxInt tabnum=0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
    tabnum.value= tabController.index;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    tabController.dispose();
    super.onClose();
  }
}
