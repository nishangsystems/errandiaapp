import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:get/get.dart';

class Routes {
  static List<GetPage> routes = [
    GetPage(name: '/', page: () => Home_view()),
    GetPage(
        name: '/business_view',
        page: () => errandia_business_view(businessData: Get.arguments),
        transition: Transition.fadeIn
    ),
  ];
}
