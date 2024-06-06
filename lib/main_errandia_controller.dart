import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/common/initialize_device.dart';
import 'package:errandia/utils/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class MainErrandiaController extends GetxService {
  late errand_tab_controller tabController;

  Future<MainErrandiaController> init() async {
    tabController = Get.put(errand_tab_controller());

    await Firebase.initializeApp();
    await InitializeDevice().initialize();
    await getActiveSubscription();
    await clearPreferencesOnFirstRun();

    return this;
  }
}
