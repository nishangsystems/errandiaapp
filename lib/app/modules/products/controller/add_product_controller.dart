import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/APi/business.dart';
import 'package:errandia/modal/Shop.dart';
import 'package:errandia/modal/category.dart';
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

  @override
  void onInit() {
    super.onInit();
    // loadShops();
  }

  Future<void> loadShops() async {
    var response = await BusinessAPI.userShops_(1);
    print("response my shops: ${response['items']}");

    if (response != null && response['items'].isNotEmpty) {
      List<Shop> fetchedShops = (response['items'] as List).map((shopData) {
        return Shop.fromJson(shopData); // Assuming Shop has a fromJson method
      }).toList();
      shopList.addAll(fetchedShops);
      print("shopList: ${shopList}");
    }
  }

  void loadCategories() async {
    var data = await api().getCategories();
    print("categories data: $data");
    if (data != null && data.isNotEmpty) {
      categoryList.addAll(data);
    }
    categor.Items = List.from(data)
        .map<Caegory>((category) => Caegory.fromJson(category))
        .toList();
    print("categoryList: $categoryList");
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