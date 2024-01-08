
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/model/subscription_model.dart';
import 'package:get/get.dart';

class subscription_controller extends GetxController{

  RxList<subscription_model> list= <subscription_model> [
    subscription_model(
      title: 'Yearly',
      Date: '2 Jul 2023',
      cost: '5000',
      color: appcolor().greenColor
    ),
     subscription_model(
      title: 'Yearly',
      Date: '9 Jul 2023',
      cost: '5000',
      color: appcolor().redColor
    ),
     subscription_model(
      title: 'Yearly',
      Date: '1 Jul 2023',
      cost: '1000',
      color: appcolor().greenColor
    ),
     subscription_model(
      title: 'Yearly',
      Date: '10 Jul 2023',
      cost: '4000',
      color: appcolor().redColor
    ),
     subscription_model(
      title: 'Yearly',
      Date: '2 Jul 2023',
      cost: '6000',
      color: appcolor().greenColor
    ),
     subscription_model(
      title: 'Yearly',
      Date: '2 Jul 2023',
      cost: '5000',
      color: appcolor().redColor
    ),
    
  ].obs;
}

