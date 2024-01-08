
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

GetSnackBar customsnackbar(Widget snackbarWidget) {
  return GetSnackBar(
    borderRadius: 10,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 10,
    ),
    padding: EdgeInsets.only(left: 20, right: 10 , top: 10,bottom: 10,),
    backgroundColor: appcolor().darkBlueColor,
    messageText: Container(
      child:snackbarWidget,
    ),
  );
}
