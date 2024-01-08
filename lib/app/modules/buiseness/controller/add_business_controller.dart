import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
  
  
  RxList<String> managerList=[
    'Abhishek',
    'Ram',
    'Nishang',
    'Binod',
    'Achal',
  ].obs;
  var group_value= 'Abhishek'.obs;
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
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}