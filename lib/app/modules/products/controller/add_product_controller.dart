import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/APi/business.dart';
import 'package:errandia/modal/Shop.dart';
import 'package:errandia/modal/category.dart';
import 'package:errandia/modal/subcategory.dart';
import 'package:errandia/modal/subcatgeory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class add_product_cotroller extends GetxController{
  TextEditingController product_name_controller= TextEditingController();
  TextEditingController shop_Id_controller= TextEditingController();
  TextEditingController category_controller= TextEditingController();
  TextEditingController product_desc_controller= TextEditingController();
  TextEditingController product_tags_controller= TextEditingController();
  TextEditingController unit_price_controller= TextEditingController();
  TextEditingController quantity_controller= TextEditingController();

  // List<Shop> shops = [];
  var shopList = List<Shop>.empty(growable: true).obs;
  var categoryList = List<dynamic>.empty(growable: true).obs;

  RxBool isLoadingShops = false.obs;
  RxBool isLoadingCategories = false.obs;

  @override
  void onInit() {
    super.onInit();
    // loadShops();
  }

  // Future<void> loadShops() async {
  //   var response = await BusinessAPI.userShops_(1);
  //   print("response my shops: ${response['items']}");
  //
  //   if (response != null && response['items'].isNotEmpty) {
  //     List<Shop> fetchedShops = (response['items'] as List).map((shopData) {
  //       return Shop.fromJson(shopData); // Assuming Shop has a fromJson method
  //     }).toList();
  //     shopList.addAll(fetchedShops);
  //     print("shopList: ${shopList}");
  //   }
  // }
  Future<void> loadShops() async {
    int currentPage = 1;
    bool hasMore = true;
    List<Shop> allShops = [];
    isLoadingShops.value = true;

    while (hasMore) {
      var response = await BusinessAPI.userShops_(currentPage);
      if (response != null && response['items'] != null && response['items'].isNotEmpty) {
        List<Shop> fetchedShops = (response['items'] as List).map((shopData) {
          return Shop.fromJson(shopData); // Assuming Shop has a fromJson method
        }).toList();

        allShops.addAll(fetchedShops);

        // Check if we've reached the last page
        int totalShops = response['total'];
        int perPage = response['per_page'];
        int totalLoadedShops = currentPage * perPage;

        hasMore = totalLoadedShops < totalShops;
        currentPage++;
      } else {
        hasMore = false; // Stop if there are no items or if it's the last page
      }
    }

    // Once done, update your observable list
    shopList.addAll(allShops);
    Future.delayed(const Duration(seconds: 5), () {
      isLoadingShops.value = false;
    });
    print("All shops loaded: ${shopList.length}");
  }

  void loadCategories() async {
    isLoadingCategories.value = true;
    await api().getSubCategories().then((data) {
      print("categories data: $data");
      if (data != null && data.isNotEmpty) {
        categoryList.addAll(data);
      }
      subCategories.Items = List<SubCategory>.from(data.map((sub) => SubCategory.fromJson(sub)));
      print("categoryList: $categoryList");
      isLoadingCategories.value = false;
    }).catchError((error) {
      print("Error loading categories: $error");
      isLoadingCategories.value = false;
    });

  }

  void resetFields() {
    product_name_controller.clear();
    shop_Id_controller.clear();
    category_controller.clear();
    product_desc_controller.clear();
    product_tags_controller.clear();
    unit_price_controller.clear();
    quantity_controller.clear();
  }

  void reloadShops() {
    shopList.clear();
    loadShops();
  }

  void reloadCategories() {
    categoryList.clear();
    loadCategories();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }
}