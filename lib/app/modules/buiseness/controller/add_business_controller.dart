import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/modal/Town.dart';
import 'package:errandia/modal/category.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../utils/helper.dart';
class add_business_controller extends GetxController{


  TextEditingController company_name_controller= TextEditingController();
  TextEditingController Business_category_controller= TextEditingController();
  TextEditingController Business_information_controller= TextEditingController();
  TextEditingController website_address_controller= TextEditingController();
  TextEditingController country_controller= TextEditingController();
  TextEditingController region_controller= TextEditingController();
  TextEditingController town_controller= TextEditingController();
  TextEditingController address_controller= TextEditingController();
  TextEditingController facebook_controller= TextEditingController();
  TextEditingController instagram_controller= TextEditingController();
  TextEditingController twitter_controller= TextEditingController();
  TextEditingController add_manager_first_name_controller= TextEditingController();
  TextEditingController add_manager_last_name_controller= TextEditingController();
  TextEditingController phone_controller= TextEditingController();
  TextEditingController email_controller= TextEditingController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController whatsapp_controller = TextEditingController();

  RxBool emailValid = false.obs;

  RxList<String> managerList=[
    'Abhishek',
    'Ram',
    'Nishang',
    'Binod',
    'Achal',
  ].obs;
  var group_value= 'Abhishek'.obs;
  var categoryList = List<dynamic>.empty(growable: true).obs;
  var townList = RxList<dynamic>([]);

  RxBool isRegionSelected = false.obs;
  RxBool isTownsLoading = false.obs;
  RxBool isValidWhatsappNumber = false.obs;

  @override
  void onInit() {
    super.onInit();
    whatsapp_controller.addListener(updateWhatsappNumberValidity);
  }


  void updateWhatsappNumberValidity() {
    isValidWhatsappNumber.value =
        whatsapp_controller.text.isNotEmpty && RegExp(phonePattern).hasMatch(whatsapp_controller.text);
  }

  void add_Manager(String manager)
  {
    managerList.add(manager);
    managerList.refresh();
    print('added');
    print(managerList.length.toString());
    add_manager_first_name_controller.clear();
    add_manager_last_name_controller.clear();
    // add_manager_first_name_controller.dispose();
    // add_manager_last_name_controller.dispose();
  }

  void loadCategories() async {
    var data = await api().getCategories();
    print("categories data: $data");
    if (data != null && data.isNotEmpty) {
      categoryList.addAll(data);
    }
    categor.Items = List.from(data)
        .map<Category>((category) => Category.fromJson(category))
        .toList();
    print("categoryList: $categoryList");
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

  void resetFields() {
    company_name_controller.clear();
    Business_category_controller.clear();
    Business_information_controller.clear();
    website_address_controller.clear();
    country_controller.clear();
    region_controller.clear();
    town_controller.clear();
    address_controller.clear();
    facebook_controller.clear();
    instagram_controller.clear();
    twitter_controller.clear();
    add_manager_first_name_controller.clear();
    add_manager_last_name_controller.clear();
    phone_controller.clear();
    email_controller.clear();
    description_controller.clear();
    whatsapp_controller.clear();

  }

  void remove_Manager (String manager)
  {
    managerList.remove(manager);
    managerList.refresh();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}