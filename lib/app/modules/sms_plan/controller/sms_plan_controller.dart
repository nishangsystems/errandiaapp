import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/sms_plan/model/sms_plan_model.dart';
import 'package:get/get.dart';

class sms_plan_controller extends GetxController{

  RxList<sms_plan_model> list = <sms_plan_model> [
    sms_plan_model(
      amount: 1600,
      color: appcolor().greenColor,
      currentPlan: true,
      extend: false,
      dailyPlan: true,
      msgcount: 50,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),

    sms_plan_model(
      amount: 1500,
      color: appcolor().bluetextcolor,
      currentPlan: false,
      extend: false,
      // dailyPlan: true,
      monthlyPlan: true,
      msgcount:100,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),
    sms_plan_model(
      amount: 1200,
      color: appcolor().bluetextcolor,
      currentPlan: false,
      extend: false,
      // dailyPlan: true,
      // monthlyPlan: true,
      weekPlan: true,
      msgcount:100,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),
    sms_plan_model(
      amount: 1500,
      color: appcolor().bluetextcolor,
      currentPlan: false,
      extend: false,
      // dailyPlan: true,
      monthlyPlan: false,
      dailyPlan: true,
      msgcount:100,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),
    sms_plan_model(
      amount: 1500,
      color: appcolor().bluetextcolor,
      currentPlan: false,
      extend: false,
      // dailyPlan: true,
      monthlyPlan: false,
      dailyPlan: true,
      msgcount:100,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),
    sms_plan_model(
      amount: 1500,
      color: appcolor().bluetextcolor,
      currentPlan: false,
      extend: false,
      // dailyPlan: true,
      monthlyPlan: true,
      msgcount:100,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),
    sms_plan_model(
      amount: 1500,
      color: appcolor().bluetextcolor,
      currentPlan: false,
      extend: false,
      // dailyPlan: true,
      monthlyPlan: false,
      dailyPlan: true,
      msgcount:100,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),
    sms_plan_model(
      amount: 1500,
      color: appcolor().bluetextcolor,
      currentPlan: false,
      extend: false,
      // dailyPlan: true,
      monthlyPlan: true,
      msgcount:100,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),
    sms_plan_model(
      amount: 1500,
      color: appcolor().bluetextcolor,
      currentPlan: false,
      extend: false,
      // dailyPlan: true,
      monthlyPlan: false,
      dailyPlan: true,
      msgcount:100,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),
    sms_plan_model(
      amount: 1500,
      color: appcolor().bluetextcolor,
      currentPlan: false,
      extend: false,
      // dailyPlan: true,
      monthlyPlan: true,
      msgcount:100,
      text: 'XAF32 PER SMS',
      setsms: 20,
    ),

  ].obs;

  String getPlan_type(bool ?dailyPlan, bool ?weekPlan, bool ?monthlyPlan)
  {
    if(dailyPlan!=null && dailyPlan==true)return 'D';
    else if(weekPlan!=null && weekPlan==true)return 'W';
    return 'M';
  }
}