
import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/APi/subscription.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/model/subscription_model.dart';
import 'package:errandia/modal/SubscriptionPlans.dart';
import 'package:get/get.dart';

class subscription_controller extends GetxController{

  var subscriptionList = List<dynamic>.empty(growable: true).obs;
  var plansList = List<dynamic>.empty(growable: true).obs;

  RxBool isPlansLoading = false.obs;
  RxBool isSubscriptionsLoading = false.obs;

  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;

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

  @override
  void onInit() {
    super.onInit();
  }

  void loadSubscriptionPlans() async {
    if (isPlansLoading.isTrue || plansList.isNotEmpty) {
      return;
    }

    try {
      isPlansLoading.value = true;
      var response = await SubscriptionAPI.getSubscriptionPlans();
      print("Response: $response");

      var data = response;

      print("Plans Data: $data");

      if (data != null && data.isNotEmpty) {
        plansList.addAll(data['items']);
      }

      isPlansLoading.value = false;
    } catch (e) {
      print("Error: $e");
      isPlansLoading.value = false;
    }
  }

  void loadSubscriptions() async {
    if (isSubscriptionsLoading.isTrue || (subscriptionList.isNotEmpty && subscriptionList.length >= total.value)) {
      return;
    }

    try {
      isSubscriptionsLoading.value = true;
      var response = await SubscriptionAPI.getMySubscriptions(currentPage.value);
      print("Response: $response");

      var data = response;

      print("Subscriptions Data: $data");

      if (data != null && data.isNotEmpty) {
        total.value = data['total'];
        subscriptionList.addAll(data['items']);
        currentPage.value++;
      }

      isSubscriptionsLoading.value = false;
    } catch (e) {
      print("Error: $e");
      isSubscriptionsLoading.value = false;
    }
  }

  void reloadSubscriptions() {
    currentPage.value = 1;
    isSubscriptionsLoading.value = false;
    total.value = 0;
    subscriptionList.clear();
    loadSubscriptions();
  }
}

