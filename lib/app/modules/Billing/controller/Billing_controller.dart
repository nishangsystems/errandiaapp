import 'package:errandia/app/modules/Billing/model/Billing_model.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:get/get.dart';

class Billing_controller extends GetxController{

  RxList<billing_model> billing_list=<billing_model>[
    billing_model(
      Date: '11 Apr 2023',
      Price: 6000,
      company_name: 'MTN Mobile Money',
      phone: '907895894' ,
      status: 'Successful',
      title: 'Subscription Renewal',
      image_url: 'assets/images/icon-payment-mtnMomo.png',
      color: appcolor().greenColor
    ),
     billing_model(
      Date: '1 May 2023',
      Price: 400,
      company_name: 'MTN Mobile Money',
      phone: '907895894' ,
      status: 'Failed',
      title: 'SMS plan Extended',
      image_url: 'assets/images/icon-payment-mtnMomoorange-money.png',
      color: appcolor().redColor
    ),
     billing_model(
      Date: '11 Apr 2023',
      Price: 6000,
      company_name: 'MTN Mobile Money',
      phone: '907895894' ,
      status: 'Successful',
      title: 'Subscription Renewal',
      image_url: 'assets/images/icon-payment-mtnMomo.png',
      color: appcolor().greenColor
    ),
     billing_model(
      Date: '1 May 2023',
      Price: 400,
      company_name: 'MTN Mobile Money',
      phone: '907895894' ,
      status: 'Failed',
      title: 'SMS plan Extended',
      image_url: 'assets/images/icon-payment-mtnMomoorange-money.png',
      color: appcolor().redColor
    ),

  ].obs;

}