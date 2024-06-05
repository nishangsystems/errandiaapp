import 'package:errandia/common/network_controller.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    // Get.put<notifications_controller>(notifications_controller(), permanent: true);
  }
}
