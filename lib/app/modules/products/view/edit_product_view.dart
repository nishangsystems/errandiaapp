import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/product.dart';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/modal/Shop.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../utils/helper.dart';
import '../../global/Widgets/blockButton.dart';

class EditProductView extends StatefulWidget {
  final Map<String, dynamic>? data;
  const EditProductView({super.key, this.data});

  @override
  State<EditProductView> createState() => EditProductViewState();
}

class EditProductViewState extends State<EditProductView> {
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

  @override
  void initState() {
    super.initState();
    product_controller = Get.put(add_product_cotroller());
    imageController = Get.put(imagePickercontroller());
    imageController2 = Get.put(imagePickercontroller());
    profileController = Get.put(profile_controller());
    _scrollController = ScrollController();

    setState(() {
      isLoadingData = true;
      productName = capitalizeAll(widget.data!['name']) ?? 'Edit Product';
    });

    product_controller.loadCategories();
    product_controller.loadShops().then((_) {
      product_controller.product_name_controller.text = widget.data!['name'] ?? '';
      product_controller.shop_Id_controller.text = widget.data!['shop']['id'].toString();
      product_controller.unit_price_controller.text = widget.data!['unit_price'].toString();
      product_controller.product_desc_controller.text = widget.data!['description'] ?? '';
      product_controller.product_tags_controller.text = widget.data!['tags'] ?? '';
      product_controller.category_controller.text = widget.data!['category']['name'];
      product_controller.quantity_controller.text = widget.data!['quantity'].toString() == 'null' ? '' : widget.data!['quantity'].toString();

      imageController.image_path.value = widget.data!['featured_image'] ?? '';

      // add all images to imageList
      if (widget.data!['images'] != null) {
        for (var image in widget.data!['images']) {
          print("image *8 ***: ${getImagePath(image['url'])}");
          imageController2.imageList.add(image);
          imageController2.uploadStatusList.add(UploadStatus.success);
        }
      }

      Shop? shop = product_controller.shopList.firstWhereOrNull(
              (s) => s.id == widget.data!['shop']['id'] as int
      );

      print("shop to edit: ${widget.data!['shop']['id']}");
      setState(() {
        selectedShop = shop;
        category = widget.data!['category']['id'] as int;
        isLoadingData = false;
      });
    });


  }

  void updateProduct(BuildContext context) {
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
        "tags": tags,
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
          ProductAPI.updateProductOrService(value, context, widget.data?['slug']).then((response_) {
            response = jsonDecode(response_);
            print("product response: $response");
            if (response['status'] == "success") {
              popup = PopupBox(
                title: "Success",
                description: response['data']['message'],
                type: PopupType.success,
              );
              setState(() {
                updatedData = response['data']['data']['item'];
                productName = capitalizeAll(updatedData['name']);
                isLoading = false;
              });
              profileController.reloadMyProducts();
            } else {
              popup = PopupBox(
                title: "Error",
                description: response['data']['message'],
                type: PopupType.error,
              );
              setState(() {
                isLoading = false;
              });
            }
            popup.showPopup(context);
          });
        } else {
          ProductAPI.updateProductOrServiceWithImage(value, context, imageController.image_path.toString(), widget.data?['slug']).then((response_) {
            response = jsonDecode(response_);
            print("product response img: $response");
            if (response['status'] == "success") {
              popup = PopupBox(
                title: "Success",
                description: response['data']['message'],
                type: PopupType.success,
              );
              print("updated data: ${response['data']['data']['item']}");
              setState(() {
                updatedData = response['data']['data']['item'];
                productName = capitalizeAll(updatedData['name']);
                isLoading = false;
              });
              profileController.reloadMyProducts();
            } else {
              popup = PopupBox(
                title: "Error",
                description: response['data']['message'],
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
    print('Edit Product: ${widget.data?['slug']}');

    return WillPopScope(
      onWillPop: () async {
        Get.back(result: updatedData.isNotEmpty ? updatedData : null);
        return updatedData.isNotEmpty;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          titleSpacing: 8,
          title: Text(productName),
          titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20),
          automaticallyImplyLeading: false,
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.back(result: updatedData.isNotEmpty ? updatedData : null);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          iconTheme: const IconThemeData(
            color:Colors.white,
            size: 30,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  updateProduct(context);
                },
                child: const Text(
                  'Publish',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        FontAwesomeIcons.buildingUser,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintText: 'Product Name *',
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
                          }
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

                        },
                  ),
                ),

                Divider(
                  color: appcolor().greyColor,
                  thickness: 1,
                  height: 1,
                  indent: 0,
                ),

                // Product categories
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

                // product quantity
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: TextFormField(
                    controller: product_controller.quantity_controller,
                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        color: Colors.black,
                        FontAwesomeIcons.cubes,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintText: 'Quantity (optional)',
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
                      hintText: 'Product Description *',
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
                                          imageController2.image_path.toString(),
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


                Container(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.image,
                      ),
                      Text(
                        '   Product Image Gallery',
                      ),
                      Spacer(),
                      Icon(Icons.edit),
                    ],
                  ),
                ),

                // product image gallery
                Obx(
                      () => SizedBox(
                    height: imageController2.imageList.isEmpty ? null : null,
                    child: imageController2.imageList.isEmpty
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
                                      'Select Images',
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
                                            Get.back();
                                            imageController2.addImageFromGallery(widget.data?['slug']);
                                            print('image list: ${imageController2.imageList}');
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
                                          ontap: ()   {
                                            Get.back();
                                            imageController2
                                                .addImageFromCamera(widget.data?['slug']);


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
                          child: Column(
                            children: [
                              Container(
                                color: appcolor().greyColor,
                                height: Get.height * 0.22,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // SizedBox(height: Get.height*0.05,),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.images,
                                            size: 60,
                                            color: appcolor().mediumGreyColor,
                                          ),
                                          Text(
                                            '     Browse Images',
                                            style: TextStyle(
                                              color: appcolor().bluetextcolor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: Get.height * 0.05,
                                    // ),
                                    Text(
                                      'Other variations of the main product image',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: appcolor().mediumGreyColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    )
                        : Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: Get.height * 0.24,
                      child: Center(
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: imageController2.imageList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            UploadStatus? uploadStatus;
                            if (index < imageController2.uploadStatusList.length) {
                              uploadStatus = imageController2.uploadStatusList[index];
                            }

                            return Stack(
                              children: [
                                Column(
                                children: [
                                  Container(
                                    height: Get.height * 0.15,
                                    width: Get.width * 0.40,
                                    decoration:
                                    BoxDecoration(border: Border.all()),
                                    child:  imageController2.imageList[index] is Map && imageController2.imageList[index].containsKey('url')
                                        ? Image.network(
                                      getImagePath(
                                        imageController2.imageList[index]['url'],
                                      ),
                                      fit: BoxFit.fill,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return Container();
                                      },
                                    )
                                        : Image(
                                      image: FileImage(
                                        File(
                                          imageController2.imageList[index].path
                                              .toString(),
                                        ),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          imageController2.replace(index, widget.data?['slug']);
                                        },
                                        child: Container(
                                          height: 35,
                                          width: Get.width * 0.20,
                                          color: uploadStatus == UploadStatus.uploading
                                              ? Colors.grey
                                              : Colors.lightGreen,
                                          child: Center(
                                            child: uploadStatus == UploadStatus.uploading
                                                ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                                : const Text(
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
                                          // imageController.removeat(index);
                                          if (uploadStatus != UploadStatus.pending) {
                                            imageController2.deleteOneImage(widget.data?['slug'], index);
                                          }
                                        },
                                        child: Container(
                                          height: 35,
                                          width: Get.width * 0.2,
                                          color: uploadStatus == UploadStatus.pending
                                              ? Colors.grey
                                              : appcolor().greyColor,
                                          child: Center(
                                            child: uploadStatus == UploadStatus.pending
                                                ? const Text(
                                              'Uploading...',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            )
                                                : const Text(
                                              'Remove',
                                              style: TextStyle(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ).paddingSymmetric(horizontal: 5),

                                if (uploadStatus == UploadStatus.failed)
                                  Positioned(
                                    top: 0,
                                    left: 5,
                                    child: Container(
                                      height: Get.height * 0.15,
                                      width: Get.width * 0.40,
                                      color: Colors.red.withOpacity(0.5),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Failed',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),

                                              Text(
                                                'Remove & try again',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                if (uploadStatus == UploadStatus.pending)
                                  Positioned(
                                    top: 0,
                                    left: 5,
                                    child: Container(
                                      height: Get.height * 0.15,
                                      width: Get.width * 0.40,
                                      color: appcolor().mainColor.withOpacity(0.5),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(
                                            'Uploading...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ]
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
              () => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: imageController.imageList.isEmpty
                ? null
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add more images button
                InkWell(
                  onTap: () async {
                    await imageController.addImageFromGallery(widget.data?['slug']).then((_) {
                      print("image list: ${imageController.imageList}");
                      // Scroll to the end of the list after the state update
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                    });
                  },
                  child: Container(
                    width: Get.width * 0.52,
                    decoration: BoxDecoration(
                      color: appcolor().skyblueColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: Get.height * 0.08,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image),
                        Text('   Add more images'),
                      ],
                    ),
                  ),
                ),
                // Delete all images button
                InkWell(
                  onTap: () {
                    // Call a method to clear the image list
                   showDialog(
                       context: context,
                       builder: (BuildContext dialogContext) {
                         return  CustomAlertDialog(
                           title: "Delete all images",
                           message: "Are you sure you want to delete all images of this product?",
                           dialogType: MyDialogType.error,
                           onConfirm: () {
                             Get.back();
                             print("deleting all images");
                             imageController.deleteAllImages(widget.data?['slug']).then((response) {
                               print("***deleted all images response ****: $response");
                             });
                           },
                           onCancel: () {
                             Get.back();
                           },
                         );
                       }
                   ).then((_) {
                      print("**** 8888 **8 deleted all images *****888***88888");
                   });
                    // imageController.deleteAllImages(widget.data?['slug']).then((response) {
                    //   print("delete all images response: $response");
                    // });
                  },
                  child: Container(
                    width: Get.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white, // Consider a different color for delete action
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: appcolor().redColor,
                          width: 1.5
                      )
                    ),
                    height: Get.height * 0.08,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: Colors.red[300],),
                        Text('   Delete all',
                          style: TextStyle(
                            color: Colors.red[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
                Divider(
                  color: appcolor().greyColor,
                  thickness: 1,
                  height: 1,
                  indent: 0,
                ),

                // product tags
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
                      hintText: 'Product Tags (optional)',
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
                  'Enter words related to product separated by comma',
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
                      'We\'re updating your product details,',
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
          ],
        ),
      ),
    );
  }
}
