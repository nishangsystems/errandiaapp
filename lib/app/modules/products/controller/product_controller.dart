
import 'dart:convert';

import 'package:errandia/app/APi/product.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxBool isProductLoading = false.obs;
  RxBool isServiceLoading = false.obs;

  var productList = List<dynamic>.empty(growable: true).obs;
  var serviceList = List<dynamic>.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
    // loadOtherProducts();
  }

  void loadOtherProducts(String slug) async {
    // try {
      print("fetching other products for: $slug");
      // if (isProductLoading.isTrue) return;

      isProductLoading.value = true;
      var data = await ProductAPI.getRelatedProductsOrServices(slug, false);
      print("response other products: ${data}");

      // decode
      var products = jsonDecode(data);

      print("decoded products: ${products['data']}");
      if (products != null) {
        productList.addAll(products['data']['data']['items']);
        isProductLoading.value = false;
      } else {
        // Handle error
        printError(info: 'Failed to load other products');
        isProductLoading.value = false;
      }
    // } catch (e) {
    //   // Handle exception
    //   printError(info: e.toString());
    //   isProductLoading.value = false;
    // }
  }

  void loadOtherServices(String slug) async {
    print("fetching other services");

    isServiceLoading.value = true;
    var data = await ProductAPI.getRelatedProductsOrServices(slug, true);
    print("response other services: $data");

    var services = jsonDecode(data);

    print("decoded services: ${services['data']}");

    if (data != null) {
      serviceList.addAll(services['data']['data']['items']);
      isServiceLoading.value = false;
    } else {
      // Handle error
      printError(info: 'Failed to load other services');
      isServiceLoading.value = false;
    }
  }

  void reload() {
    productList.clear();
    serviceList.clear();
    isProductLoading.value = false;
    isServiceLoading.value = false;
  }

}