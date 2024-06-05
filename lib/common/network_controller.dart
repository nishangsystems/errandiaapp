import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      // Get.rawSnackbar(
      //     messageText: const Text(
      //         'You\'re offline! Please connect to the internet.',
      //         style: TextStyle(color: Colors.white, fontSize: 14)),
      //     isDismissible: false,
      //     duration: const Duration(days: 1),
      //     backgroundColor: Colors.red[400]!,
      //     icon: const Icon(
      //       Icons.wifi_off,
      //       color: Colors.white,
      //       size: 35,
      //     ),
      //     margin: EdgeInsets.zero,
      //     snackStyle: SnackStyle.GROUNDED);

      // show a warning popup to the user
      Get.defaultDialog(
        title: 'No Internet Connection',
        middleText: 'You\'re offline! Please connect to the internet.',
        barrierDismissible: false,
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Get.back();
        //     },
        //     child: const Text('OK'),
        //   ),
        // ],
      );
    } else {
      if (Get.isDialogOpen == true) {
        // Get.closeCurrentSnackbar();
        Get.back(closeOverlays: true);
      }
    }
  }
}
