
import 'package:errandia/app/APi/business.dart';
import 'package:get/get.dart';

class ErrandiaBusinessViewController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;
  var itemList = List<dynamic>.empty(growable: true).obs;
  RxBool isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchBusinessBranches();
  }

  void loadBusinessBranches(shopSlug) async {
    print("fetching business branches for $shopSlug");
    if (isLoading.isTrue || (itemList.isNotEmpty && itemList.length >= total.value)) return;

    try {
      isLoading.value = true;
      print("current page: ${currentPage.value}");

      var data = await BusinessAPI.businessBranches(shopSlug, currentPage.value);
      print("response: $data");

      if (data != null && data.isNotEmpty) {
        currentPage.value++;
        isLoading.value = false;
        // parse total to an integer
        total.value = data['total'];
        // print("total_: ${total.value}");
        itemList.addAll(data['items']);

        print("itemList: $itemList");
      }
    } catch (e) {
      isError.value = true;
      isLoading.value = false;
      print("error loading businesses: $e");
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

}