import 'package:flutter/material.dart';


class sms_plan_model {
  bool? weekPlan = false;
  bool? dailyPlan = false;
  bool? monthlyPlan = false;
  bool? currentPlan = false;
  bool? extend = false;
  double? amount;
  String? text;
  int? msgcount;
  Color? color;
  int ? setsms;
  
  
  sms_plan_model({
    this.amount,
    this.color,
    this.currentPlan,
    this.dailyPlan,
    this.extend,
    this.monthlyPlan,
    this.msgcount,
    this.text,
    this.weekPlan,
    this.setsms,
  });
}
