import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/app/modules/services/view/service_details_view.dart';
import 'package:get/get.dart';

class Routes {
  static List<GetPage> routes = [
    GetPage(name: '/', page: () => Home_view()),
    GetPage(
        name: '/business_view',
        page: () => errandia_business_view(businessData: Get.arguments),
        transition: Transition.fadeIn
    ),
    GetPage(
      name: '/product_view',
      page: () => Product_view(item: Get.arguments),
      transition: Transition.fadeIn
    ),
    GetPage(
      name: '/service_view',
      page: () => ServiceDetailsView(service: Get.arguments),
      transition: Transition.fadeIn
    )
  ];
}
