
import 'dart:convert';

import 'package:errandia/app/APi/product.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxBool isProductLoading = false.obs;
  RxBool isServiceLoading = false.obs;
  RxBool isAllProductLoading = false.obs;
  RxBool isAllServiceLoading = false.obs;
  RxBool isShopProductsLoading = false.obs;
  RxBool isShopServicesLoading = false.obs;

  var productList = List<dynamic>.empty(growable: true).obs;
  var serviceList = List<dynamic>.empty(growable: true).obs;
  var allProductList = List<dynamic>.empty(growable: true).obs;
  var allServiceList = List<dynamic>.empty(growable: true).obs;
  var shopProductList = List<dynamic>.empty(growable: true).obs;
  var shopServiceList = List<dynamic>.empty(growable: true).obs;

  RxInt currentPage = 1.obs;
  RxInt total = 0.obs;

  RxInt serviceCurrentPage = 1.obs;
  RxInt serviceTotal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // loadOtherProducts();
  }

  void loadShopProducts(String slug) async {
    print("fetching shop products");

    isShopProductsLoading.value = true;
    var data = await ProductAPI.getItemsByShop(slug, false, 1);
    print("response shop products: $data");

    var products = jsonDecode(data);

    print("decoded shop products: ${products['data']['data']}");

    if (data != null) {
      shopProductList.addAll(products['data']['data']['items']);
      isShopProductsLoading.value = false;
    } else {
      // Handle error
      printError(info: 'Failed to load shop products');
      isShopProductsLoading.value = false;
    }
  }

  void loadShopServices(String slug) async {
    print("fetching shop services");

    isShopServicesLoading.value = true;
    var data = await ProductAPI.getItemsByShop(slug, true, 1);
    print("response shop services: $data");

    var services = jsonDecode(data);

    print("decoded shop services: ${services['data']['data']}");

    if (data != null) {
      shopServiceList.addAll(services['data']['data']['items']);
      isShopServicesLoading.value = false;
    } else {
      // Handle error
      printError(info: 'Failed to load shop services');
      isShopServicesLoading.value = false;
    }
  }

  void loadAllProducts() async {
    print("fetching all products");

    if (isAllProductLoading.isTrue && (allProductList.isNotEmpty && allProductList.length >= total.value)) return;

    isAllProductLoading.value = true;

    try {
      var data = await ProductAPI.getAllProductsOrServices(false, currentPage.value);
      print("response all products: $data");

      var products = jsonDecode(data);

      print("decoded all products: ${products['data']['data']}");

      if (data != null) {
        currentPage.value++;
        isAllProductLoading.value = false;
        // parse total to an integer
        total.value = products['data']['data'][0]['total'];
        // print("total_: ${total.value}");
        allProductList.addAll(products['data']['data'][0]['items']);
        print("allProductList: $allProductList");
      }
    } catch (e) {
      // Handle exception
      printError(info: e.toString());
      isAllProductLoading.value = false;
    }
  }

  void loadAllServices() async {
    print("fetching all services");

    if (isAllServiceLoading.isTrue && (allServiceList.isNotEmpty && allServiceList.length >= serviceTotal.value)) return;

    isAllServiceLoading.value = true;

    try {
      var data = await ProductAPI.getAllProductsOrServices(true, serviceCurrentPage.value);
      print("response all services: $data");

      var services = jsonDecode(data);

      print("decoded all services: ${services['data']['data']}");

      if (data != null) {
        serviceCurrentPage.value++;
        isAllServiceLoading.value = false;
        // parse total to an integer
        serviceTotal.value = services['data']['data'][0]['total'];
        // print("total_: ${total.value}");
        allServiceList.addAll(services['data']['data'][0]['items']);
        print("allServiceList: $allServiceList");
      }
    } catch (e) {
      // Handle exception
      printError(info: e.toString());
      isAllServiceLoading.value = false;
    }
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

  void reloadAll() {
    currentPage.value = 1;
    total.value = 0;
    serviceTotal.value = 0;
    serviceCurrentPage.value = 1;
    allProductList.clear();
    allServiceList.clear();
    isAllProductLoading.value = false;
    isAllServiceLoading.value = false;
  }

  void reloadAllServices() {
    serviceCurrentPage.value = 1;
    serviceTotal.value = 0;
    allServiceList.clear();
    isAllServiceLoading.value = false;
  }

}