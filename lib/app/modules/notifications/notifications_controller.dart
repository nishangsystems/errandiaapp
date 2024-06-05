import 'package:errandia/app/APi/notifications.dart';
import 'package:get/get.dart';

class notifications_controller extends GetxController {
  RxBool isNotificationLoading = false.obs;
  RxBool isNotificationError = false.obs;

  var notificationList = List<dynamic>.empty(growable: true).obs;

  RxBool isDetailLoading = false.obs;
  RxBool isDetailError = false.obs;
  var notificationDetail = <String, dynamic>{}.obs;

  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() async {
    print("fetching notifications");
    if (isNotificationLoading.isTrue ||
        (notificationList.isNotEmpty && notificationList.length >= total.value))
      return;

    isNotificationLoading.value = true;

    try {
      var data = await NotificationsAPI.getNotifications();
      print("response notifications: $data");

      if (data != null && data.isNotEmpty) {
        currentPage.value++;
        notificationList.addAll(data['items']);
        total.value = data['total'];
        isNotificationLoading.value = false;
        isNotificationError.value = false;

        // order by date
        notificationList.sort((a, b) {
          return b['created_at'].compareTo(a['created_at']);
        });
      } else {
        isNotificationLoading.value = false;
        isNotificationError.value = true;
      }
    } catch (e) {
      print("error fetching notifications: $e");
      isNotificationLoading.value = false;
      isNotificationError.value = true;
    }
  }

  Future<void> fetchNotificationDetail(int id) async {
    print("fetching notification detail");
    isDetailLoading.value = true;

    try {
      var data = await NotificationsAPI.getNotificationDetail(id);
      print("response notification detail: $data");

      if (data != null && data.isNotEmpty) {
        notificationDetail.value = data['item'];
        isDetailLoading.value = false;
        isDetailError.value = false;
      } else {
        isDetailLoading.value = false;
        isDetailError.value = true;
      }
    } catch (e) {
      print("error fetching notification detail: $e");
      isDetailLoading.value = false;
      isDetailError.value = true;
    }
  }

  void reloadNotifications() {
    notificationList.clear();
    currentPage.value = 1;
    total.value = 0;
    fetchNotifications();
  }
}
