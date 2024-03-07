
import 'package:errandia/app/APi/business.dart';
import 'package:get/get.dart';

class ErrandiaBusinessViewController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;
  var itemList = List<dynamic>.empty(growable: true).obs;
  RxBool isError = false.obs;

  RxBool isBranchesLoading = false.obs;
  RxBool isBranchesError = false.obs;
  var branchesList = List<dynamic>.empty(growable: true).obs;

  Map<String, dynamic> businessData = {};

  @override
  void onInit() {
    super.onInit();
    // businessData = Get.arguments as Map<String, dynamic>;
    // fetchBusinessBranches();
  }

  void loadBusinesses(currentSlug) async {
    print("fetching businesses");

    try {
      isBranchesLoading.value = true;
      var data = await BusinessAPI.businessBranches(currentSlug, 1);
      print("response businesses: $data");

      if (data != null && data.isNotEmpty) {
        branchesList.addAll(data['items']);
        isBranchesLoading.value = false;
        isBranchesError.value = false;
      } else {
        // Handle error
        printError(info: 'Failed to load businesses');
        isBranchesLoading.value = false;
        isBranchesError.value = false;
      }
    } catch (e) {
      isError.value = true;
      isLoading.value = false;
      print("error loading businesses: $e");
    }
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

  void reloadBusinesses() {
    branchesList.clear();
    isBranchesError.value = false;
    isBranchesLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }

}