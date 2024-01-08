import 'package:flutter/material.dart';
import 'package:get/get.dart';

class friends_model{

  String ?title;
  String ? phone_number;
  String ? image_url;
  RxBool  isSelected;

  friends_model({this.image_url,required this.isSelected  , this.phone_number , this.title});

}