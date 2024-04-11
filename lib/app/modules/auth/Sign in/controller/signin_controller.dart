import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class signIn_controller extends GetxController{

  RxBool isLogin= true.obs;
  RxBool isPhone = false.obs;

  FocusNode fieldFocus = FocusNode();
}