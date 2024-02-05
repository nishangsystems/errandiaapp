
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

GetSnackBar customSnackBar(Widget snackBarWidget) {
  print("showing snackbar");
  return GetSnackBar(
    borderRadius: 10,
    duration: const Duration(seconds: 1000),
    margin: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 10,
    ),
    padding: const EdgeInsets.only(left: 20, right: 10 , top: 10,bottom: 10,),
    backgroundColor: appcolor().darkBlueColor,
    messageText: Container(
      child:snackBarWidget,
    ),
  );
}
