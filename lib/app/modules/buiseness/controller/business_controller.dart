import 'package:errandia/app/modules/buiseness/view/manage_business_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../view/business_item.dart';

class business_controller extends GetxController {

  RxBool headmainSwitch= false.obs;
  var sorting_value= "sort descending".obs;
  List<business_item> businessList = [
    business_item(
      imagepath: 'assets/images/featured_buiseness_icon/mechanic.png',
      location: 'Akwa , Douala',
      name: 'Centrale Auto Driver',
      type_of_business: 'Cars & Bikes',
      BusinessBranch_location: ['Alka L1', 'L2',' L3',],
    ),
    business_item(
      imagepath: 'assets/images/featured_buiseness_icon/nishang.png',
      location: 'Akwa , Douala',
      name: 'Nishang',
      type_of_business: 'Electronics & IT',
      BusinessBranch_location: ['Alka L1', 'L2',' L3',],
    ),
    business_item(
      imagepath: 'assets/images/featured_buiseness_icon/plumbing.png',
      BusinessBranch_location: ['Alka L1', 'L2',' L3',],
      location: 'Akwa , Douala',
      name: 'Centrale Auto',
      type_of_business: 'Cars & Bikes',
    ),
    business_item(
      imagepath: 'assets/images/featured_buiseness_icon/barber.png',
      BusinessBranch_location: ['Alka L1', 'L2',' L3',],
      location: 'Akwa , Douala',
      name: 'Barber Shop',
      type_of_business: 'Hair Cut',
    ),
    business_item(
      imagepath: 'assets/images/featured_buiseness_icon/mechanic.png',
      BusinessBranch_location: ['Alka L1', 'L2',' L3',],
      location: 'Akwa , Douala',
      name: 'Centrale Auto ',
      type_of_business: 'Cars & Bikes',
    ),
    business_item(
      imagepath: 'assets/images/featured_buiseness_icon/nishang.png',
      BusinessBranch_location: ['Alka L1', 'L2',' L3',],
      location: 'Akwa , Douala',
      name: 'Nishang',
      type_of_business: 'Electronics & IT',
    ),
    business_item(
      imagepath: 'assets/images/featured_buiseness_icon/plumbing.png',
      BusinessBranch_location: ['Alka L1', 'L2',' L3',],
      location: 'Akwa , Douala',
      name: 'Centrale Auto',
      type_of_business: 'Cars & Bikes',
    ),


    
  ];



  void set_sorting_value(var value)
  {
      sorting_value.value=value;
  }


 Future< void> mylaunchUrl(String url)async
  {
    final Uri uri= Uri(scheme: "https", host:  url);
    if(!await launchUrl(uri, mode: LaunchMode.externalApplication))
    {
      throw 'can not launch url';
    }
  }
}



class manage_business_tabController extends GetxController with GetSingleTickerProviderStateMixin{

  
   List<Widget> myTabs = [
    allBusiness(),
    Published(),
    Trashed(),
  ];


  late TabController tabController;
  @override
  void onInit() {
    // TODO: implement onInit
    tabController= TabController(length: myTabs.length, vsync: this);
    super.onInit();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  

}