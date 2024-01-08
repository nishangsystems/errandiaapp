import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/enquiry_item_model.dart';

class enquiry_controller extends GetxController{

  // RxBool longpress=false.obs;
  RxInt selectedCounter=0.obs;
  RxList <enquiry_item_model>allenquiry_list=<enquiry_item_model>[

    enquiry_item_model(
      imageurl: 'assets/images/enquiries-productThumb-10.png',
      Description: 'Doloribus fuga quas laboriosam sint facere blanditiis vitae alias',
      desc_title: 'Do you have a Lenovo computer:',
      personName: 'Taryn Brakus',
      time: '2',
      isViewed: false,isSelected: false,
    ),
    enquiry_item_model(
      imageurl: 'assets/images/enquiries-productThumb-10.png',
      Description: 'Doloribus fuga quas laboriosam sint facere blanditiis vitae alias',
      desc_title: 'Do you have a Lenovo computer:',
      personName: 'Stanley Kshlerin',
      time: '2',
      isViewed: true,isSelected: false,
    ),
    enquiry_item_model(
      imageurl: 'assets/images/enquiries-productThumb-10.png',
      Description: 'Doloribus fuga quas laboriosam sint facere blanditiis vitae alias',
      desc_title: 'Do you have a Lenovo computer:',
      personName: 'Taryn Brakus',
      time: '2',
      isViewed: true,
      isSelected: false
    ),
    
    enquiry_item_model(
      imageurl: 'assets/images/enquiries-productThumb-10.png',
      Description: 'Doloribus fuga quas laboriosam sint facere blanditiis vitae alias',
      desc_title: 'Do you have a Lenovo computer:',
      personName: 'Stanley Kshlerin',
      time: '2',
      isViewed: false,isSelected: false,
    ),
    enquiry_item_model(
      imageurl: 'assets/images/enquiries-productThumb-10.png',
      Description: 'Doloribus fuga quas laboriosam sint facere blanditiis vitae alias',
      desc_title: 'Do you have a Lenovo computer:',
      personName: 'Stanley Kshlerin',
      time: '2',
      isViewed: true,isSelected: false,
    ),

  ].obs;


  void cancel(){
    selectedCounter.value=0;
    for(int i=0; i<allenquiry_list.length; i++){
      allenquiry_list[i].isSelected=false;
      
    }
  }
}


class enquiry_tab_controller extends GetxController with GetSingleTickerProviderStateMixin{


  late TabController tabController;
  @override
  void onInit() {
    // TODO: implement onInit
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }
}