import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/product.dart';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/modal/Shop.dart';
import 'package:errandia/modal/category.dart';
import 'package:errandia/modal/subcategory.dart';
import 'package:errandia/modal/subcatgeory.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/Widgets/blockButton.dart';

class EditServiceView extends StatefulWidget {
  final Map<String, dynamic>? data;

  const EditServiceView({super.key, required this.data});

  @override
  State<EditServiceView> createState() => EditServiceViewState();
}

class EditServiceViewState extends State<EditServiceView> {
  late add_product_cotroller product_controller;
  late profile_controller profileController;
  late imagePickercontroller imageController;
  late imagePickercontroller imageController2;
  late ScrollController _scrollController;

  List<String> selectedFilters = [];
  List<int> selectedFilters_ = [];
  bool isLoading = false;
  bool isLoadingData = false;
  Shop? selectedShop;
  var category;
  String productName = '';

  Map<String, dynamic> updatedData = {};

  late Map<String, dynamic> _localServiceData;

  @override
  void initState() {
    super.initState();
    product_controller = Get.put(add_product_cotroller());
    imageController = Get.put(imagePickercontroller());
    imageController2 = Get.put(imagePickercontroller());
    profileController = Get.put(profile_controller());
    _scrollController = ScrollController();
    _localServiceData = widget.data!;

    setState(() {
      isLoadingData = true;
      productName = capitalizeAll(_localServiceData['name']) ?? 'Edit Service';
    });

    product_controller.loadCategories();
    product_controller.loadShops().then((_) {
      product_controller.product_name_controller.text = _localServiceData['name'] ?? '';
      product_controller.shop_Id_controller.text = _localServiceData['shop']['id'].toString();
      product_controller.unit_price_controller.text = _localServiceData['unit_price'].toString();
      product_controller.product_desc_controller.text = _localServiceData['description'] ?? '';
      product_controller.product_tags_controller.text = _localServiceData['tags'] ?? '';
      product_controller.category_controller.text = _localServiceData['category']['name'];
      product_controller.quantity_controller.text = _localServiceData['quantity'].toString();

      imageController.image_path.value = _localServiceData['featured_image'] ?? '';

      Shop? shop = product_controller.shopList.firstWhereOrNull(
              (s) => s.id == _localServiceData['shop']['id'] as int
      );

      print("shop to edit: ${_localServiceData['shop']['id']}");
      setState(() {
        selectedShop = shop;
        category = _localServiceData['category']['id'] as int;
        isLoadingData = false;
      });
    });
  }

  void updateService(BuildContext context) {
    var name = product_controller.product_name_controller.text.toString();
    var shopId = selectedShop?.id.toString();
    var unitPrice = product_controller.unit_price_controller.text;
    var productDescription = product_controller.product_desc_controller.text.toString();
    var tags = product_controller.product_tags_controller.text.toString();
    var qty = product_controller.quantity_controller.text.toString();

    if(name == '') {
      alertDialogBox(context, "Error", "Product name is required");
    } else if (shopId == null) {
      alertDialogBox(context, "Error", "Shop is required");
    } else if (unitPrice == '') {
      alertDialogBox(context, "Error", "Unit price is required");
    } else if (productDescription == '') {
      alertDialogBox(context, "Error", "Product description is required");
    } else if (category == null) {
      alertDialogBox(context, "Error", "Category is required");
    } else {
      var value = {
        "name": name,
        "shop_id": shopId,
        "unit_price": unitPrice,
        "description": productDescription,
        "tags": tags ?? "",
        "category_id": category.toString(),
        "quantity": qty,
      };

      setState(() {
        isLoading = true;
      });

      PopupBox popup;
      var response;

      try {
        print("product data: $value");

        if (imageController.image_path.toString() == '') {
          ProductAPI.updateProductOrService(value, context, _localServiceData['slug']).then((response_) {
            response = jsonDecode(response_);
            print("product response: $response");
            if (response['status'] == "success") {
              popup = PopupBox(
                title: "Success",
                description: response['data']['message'],
                type: PopupType.success,
              );
              var data = response['data']['data']['item'];
              print("updated data: $data");
              setState(() {
                updatedData.addAll(data);
                productName = capitalizeAll(updatedData['name']);
                isLoading = false;
              });
              profileController.reloadMyServices();
            } else {
              popup = PopupBox(
                title: "Error",
                description: response['data']['data']['error'],
                type: PopupType.error,
              );
              setState(() {
                isLoading = false;
              });
            }
            popup.showPopup(context);
          });
        } else {
          ProductAPI.updateProductOrServiceWithImage(value, context, imageController.image_path.toString(), _localServiceData?['slug']).then((response_) {
            response = jsonDecode(response_);
            print("product response img: $response");
            if (response['status'] == "success") {
              popup = PopupBox(
                title: "Success",
                description: response['data']['message'],
                type: PopupType.success,
              );
              var data = response['data']['data']['item'];
              print("updated data: $data");
              setState(() {
                updatedData.addAll(data);
                productName = capitalizeAll(updatedData['name']);
                isLoading = false;
              });
              profileController.reloadMyServices();
            } else {
              popup = PopupBox(
                title: "Error",
                description: response['data']['data']['error'],
                type: PopupType.error,
              );
              setState(() {
                isLoading = false;
              });
            }
            popup.showPopup(context);
          });
        }

      } catch (e) {
        print("error creating product: $e");
        popup = PopupBox(
          title: "Error",
          description: "Error creating product",
          type: PopupType.error,
        );
        setState(() {
          isLoading = false;
        });
        popup.showPopup(context);
      }


    }
  }

  @override
  Widget build(BuildContext context) {
    print('Edit Service: $_localServiceData');

    return WillPopScope(
      onWillPop: () async {
        Get.back(result: updatedData.isNotEmpty ? updatedData : null);
        return updatedData.isNotEmpty;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          titleSpacing: 8,
          title: Text(productName),
          titleTextStyle: TextStyle(
              color: appcolor().mediumGreyColor,
              fontWeight: FontWeight.w500,
              fontSize: 20),
          automaticallyImplyLeading: false,
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.back(result: updatedData.isNotEmpty ? updatedData : null);
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: appcolor().mediumGreyColor,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  updateService(context);
                },
                child: const Text(
                  'Update',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ))
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Wrap(
                children: [
                  // company name
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: TextFormField(
                      controller: product_controller.product_name_controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          FontAwesomeIcons.buildingUser,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Service Name *',
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  // service categories
                  ListTile(
                    leading: Container(
                        padding: const EdgeInsets.only(left: 12, right: 0),
                        child: const Icon(
                          FontAwesomeIcons.store,
                          color: Colors.black,
                        )
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.only(left: 0, right: 12),
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.black,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Obx(
                          () {
                            if (product_controller.isLoadingShops.value) {
                              return Text('Loading Shops...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              );
                            } else {
                              return DropdownButtonFormField<Shop>(
                                value: selectedShop,
                                iconSize: 0.0,
                                isDense: true,
                                isExpanded: true,
                                padding: const EdgeInsets.only(bottom: 8),
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Select a Shop *',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                onChanged: (Shop? newValue) {
                                  setState(() {
                                    selectedShop = newValue;
                                  });
                                  print("selected shop: ${selectedShop?.name}");
                                },
                                items: product_controller.shopList.map<DropdownMenuItem<Shop>>((Shop shop) {
                                  return DropdownMenuItem<Shop>(
                                    value: shop,
                                    child: Text(capitalizeAll(shop.name),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          }
                    ),
                  ),

                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  // Service categories
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.only(left: 12, right: 0),
                      child: const Icon(
                        Icons.category,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.only(left: 0, right: 12),
                      child: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.black,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Obx(
                            () {
                          if (product_controller.isLoadingCategories.value) {
                            return Text('Loading Categories...',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            );
                          } else if (product_controller.categoryList.isEmpty) {
                            return Text('No Categories found',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            );
                          } else {
                            return DropdownButtonFormField<dynamic>(
                              value: category,
                              iconSize: 0.0,
                              isDense: true,
                              isExpanded: true,
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Select a Category *',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  category = newValue as int;
                                });
                                print("selected category: $category");
                              },
                              items: product_controller.categoryList.map<DropdownMenuItem<dynamic>>((dynamic category) {
                                return DropdownMenuItem<dynamic>(
                                  value: category['id'],
                                  child: Text(capitalizeAll(category['name']),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }
                    ),
                  ),

                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  // unit price
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: TextFormField(
                      controller: product_controller.unit_price_controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          color: Colors.black,
                          FontAwesomeIcons.dollarSign,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Unit Price *',
                        suffix: Text('XAF'),
                        suffixIcon: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  // Business info
                  Container(
                    height: Get.height * 0.2,
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: TextFormField(
                      controller: product_controller.product_desc_controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          color: Colors.black,
                          FontAwesomeIcons.info,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Service Description *',
                        suffixIcon: Icon(
                          color: Colors.black,
                          Icons.edit,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  // cover image
                  Obx(
                        () => Container(
                      height: imageController.image_path.isEmpty
                          ? null
                          : Get.height * 0.40,
                      child: imageController.image_path.isEmpty
                          ? InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 20,
                                ),
                                scrollable: true,
                                content: SizedBox(
                                  // height: Get.height * 0.7,
                                  width: Get.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cover Image',
                                        style: TextStyle(
                                          color: appcolor().mainColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.05,
                                      ),
                                      Column(
                                        children: [
                                          blockButton(
                                            title: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.image,
                                                  color: appcolor().mainColor,
                                                  size: 22,
                                                ),
                                                Text(
                                                  '  Image Gallery',
                                                  style: TextStyle(
                                                      color:
                                                      appcolor().mainColor),
                                                ),
                                              ],
                                            ),
                                            ontap: () {
                                              imageController.getImageFromGallery();
                                              Get.back();
                                            },
                                            color: appcolor().greyColor,
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.015,
                                          ),
                                          blockButton(
                                            title: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.camera,
                                                  color: appcolor().mainColor,
                                                  size: 22,
                                                ),
                                                Text(
                                                  '  Take Photo',
                                                  style: TextStyle(
                                                    color: appcolor().mainColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ontap: () async {
                                              Get.back();

                                              var path = await imageController
                                                  .getimagefromCamera();

                                              print("image path: $path");

                                              if (path != null) {
                                                File? file = File(path);

                                                print("original file size: ${file.lengthSync()}");

                                                try {
                                                  file = (await compressFile(file: file));
                                                  print("Compressed file size: ${file.lengthSync()}");
                                                } catch (e) {
                                                  print("Error compressing file: $e");
                                                }
                                                imageController.image_path.value = file!.path;

                                                imageController.update();

                                                print("compressed file path: ${file.path}");

                                              }
                                            },
                                            color: const Color(0xfffafafa),
                                          ),
                                        ],
                                      )
                                    ],
                                  ).paddingSymmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: const Row(
                            children: [
                              Icon(Icons.image),
                              Text('  Cover Image'),
                              Spacer(),
                              Icon(
                                Icons.edit,
                              )
                            ],
                          ),
                        ),
                      )
                          : SizedBox(
                        height: Get.height * 0.38,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.image),
                                const Text(
                                  '   Cover Image *',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.edit,
                                  ),
                                )
                              ],
                            ).paddingSymmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                            Divider(
                              color: appcolor().greyColor,
                              thickness: 1,
                              height: 1,
                              indent: 0,
                            ),
                            Stack(
                              children: [
                                Obx(
                                        () {
                                      return imageController.image_path.isEmpty ? Container()
                                          : imageController.image_path.contains("uploads/")
                                          ? Image.network(
                                        getImagePath(
                                          imageController.image_path.toString(),
                                        ),
                                        height: Get.height * 0.32,
                                        width: Get.width * 0.9,
                                        fit: BoxFit.fill,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Container();
                                        },
                                      ).paddingSymmetric(horizontal: 30) : imageController.image_path.contains("default") ?
                                      Container()
                                          : Image(
                                        image: FileImage(
                                          File(
                                            imageController.image_path.toString(),
                                          ),
                                        ),
                                        height: Get.height * 0.32,
                                        width: Get.width * 0.9,
                                        fit: BoxFit.fill,
                                      ).paddingSymmetric(horizontal: 30);
                                    }
                                ),
                                SizedBox(
                                  height: Get.height * 0.32,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          imageController.getImageFromGallery();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 60,
                                          color: Colors.lightGreen,
                                          child: const Center(
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          imageController.reset();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 60,
                                          color: appcolor().greyColor,
                                          child: const Center(
                                            child: Text(
                                              'Remove',
                                              style: TextStyle(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  // service tags
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: TextFormField(
                      controller: product_controller.product_tags_controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          FontAwesomeIcons.tags,
                          color: Color.fromARGB(255, 108, 105, 105),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Service Tags (optional)',
                        suffixIcon: Icon(
                          color: Colors.black,
                          Icons.edit,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  const Text(
                    'Enter words related to service separated by comma',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ).paddingSymmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  SizedBox(
                    height: Get.height * 0.1,
                  ),
                ],
              ),
            ),

            if (isLoadingData)
              const Opacity(
                opacity: 0.6,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black87,
                ),
              ),

            if (isLoadingData)
              Center(
                child: buildLoadingWidget(),
              ),

            if (isLoading)
              const Opacity(
                opacity: 0.6,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black87,
                ),
              ),
            if (isLoading)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'We\'re updating your service details,',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
          ]
        ),
      ),
    );
  }
}
