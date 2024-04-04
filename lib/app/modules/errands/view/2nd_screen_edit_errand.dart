import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:errandia/modal/subcategory.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../APi/apidomain & api.dart';
import '../../../AlertDialogBox/alertBoxContent.dart';
import '../../global/Widgets/blockButton.dart';
import 'errand_view.dart';

add_product_cotroller product_controller = Get.put(add_product_cotroller());

class EditErrand2 extends StatefulWidget {
  final data;

  const EditErrand2(
      {super.key,
      this.data});

  @override
  State<EditErrand2> createState() => _EditErrand2();
}

class _EditErrand2 extends State<EditErrand2> {
  late add_product_cotroller product_controller;
  late ScrollController _scrollController;
  late imagePickercontroller imageController2;
  late errand_controller errandController;
  late home_controller homeController;

  var selectedOption;

  bool ischip1 = false;
  List<bool> ischip2 = [];
  List<int?> selectedFilters = [];
  List<int> selectedFilterss = [];
  List<int> selectedFilters_ = [];
  bool ischip3 = false;
  var like;

  late PopupBox popup;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  dynamic remoteFiles;

  var updatedData;

  @override
  void initState() {
    super.initState();
    product_controller = Get.put(add_product_cotroller());
    _scrollController = ScrollController();
    imageController2 = Get.put(imagePickercontroller());
    errandController = Get.put(errand_controller());
    homeController = Get.put(home_controller());

    product_controller.loadCategories();

    // ischip2 = List.filled(
    //   subCetegoryData.Items.length,
    //   false,
    // );

    // add all images to imageList
    if (widget.data!['images'] != null) {
      for (var image in widget.data!['images']) {
        print("image *8 ***: ${getImagePath(image['image_path'])}");
        imageController2.imageList.add(image);
        imageController2.uploadStatusList.add(UploadStatus.success);
      }
    }

    // add all selected categories to selectedFilters
    if (widget.data!['categories'] != null) {
      for (var category in widget.data!['categories']) {
        if (category.runtimeType != int) {
          selectedFilters.add(category['id']);
        } else {
          selectedFilters.add(category);
        }
      }
    }
    print("selectedFilters: $selectedFilters");
  }

  void updateErrand(BuildContext context) async {
    print("categories listing: ${listToString(selectedFilters)}");
    print("imageList: ${imageController2.imageList}");
    if (widget.data['title'] == null || widget.data['title'] == "") {
      alertDialogBox(context, "Error", 'Product/Service Name is required');
    }  else {
      var file = "";

      for (int i = 1; i < selectedFilters_.length; i++) {
        file = "$file,${selectedFilters_[i]}";
      }
      if (kDebugMode) {
        print("logo to upload: $file");
      }

      setState(() {
        isLoading = true;
      });

      var value = {
        'title': widget.data['title'].toString(),
        'description': widget.data['description'].toString(),
        'categories': listToString(selectedFilters).toString(),
        'region_id': widget.data['region']['id'].toString() ?? "",
        'town_id': widget.data['town']['id'].toString() ?? "",
      };

      print("value: $value");

      await ErrandsAPI.updateErrand(widget.data['id'].toString(), value).then((response_) {
        print("response: $response_");
        var response = jsonDecode(response_);
        if (response['status'] == 'success') {
          if (kDebugMode) {
            print("Errand created successfully: ${response['data']}");
          }
          setState(() {
            isLoading = false;
            updatedData = response['data'];
            // imageController2.imageList.clear();
            // imageController2.imagePaths.clear();
            // selectedFilters.clear();
          });
          homeController.reloadRecentlyPostedItems();
          errandController.reloadMyErrands();
          popup = PopupBox(
            title: 'Success',
            description: response['message'],
            type: PopupType.success,
            callback: () {
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //     builder: (context) => errand_view_with_no_bar(),
              //   ),
              //   (route) => false,
              // );
              Get.back();
              Get.back();
            },
          );
          popup.showPopup(context);
        } else {
          setState(() {
            isLoading = false;
          });
          alertDialogBox(context, "Error", response['message']);
        }
      }).catchError((error) {
        if (kDebugMode) {
          print("Error creating errand: $error");
        }
        setState(() {
          isLoading = false;
        });
        alertDialogBox(context, "Error", "Failed to create errand");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          updatedData = {
            'title': widget.data['title'],
            'description': widget.data['description'],
            'region': widget.data['region'],
            'town': widget.data['town'],
            'images': imageController2.imageList,
            'categories': selectedFilters,
          };
        });
        Get.back(result: updatedData);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          titleSpacing: 8,
          title: Text(
            'Update Errand'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff113d6b),
            ),
          ),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: appcolor().mediumGreyColor,
              fontSize: 18),
          automaticallyImplyLeading: false,
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              setState(() {
                updatedData = {
                  'title': widget.data['title'],
                  'description': widget.data['description'],
                  'region': widget.data['region'],
                  'town': widget.data['town'],
                  'images': imageController2.imageList,
                  'categories': selectedFilters,
                };
              });
              Get.back(result: updatedData);
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xff113d6b),
          ),
          // actions: [
          //   TextButton(
          //       onPressed: () {},
          //       child: Text(
          //         'Publish',
          //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          //       ))
          // ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Text(
                      '2- Upload Photos'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
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

                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  // multiple image
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image,
                        ),
                        const Text(
                          '  Upload screenshots of sample(s)of \n   products you are looking for on Errandia',
                          style: TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.edit,
                          color: appcolor().darkBlueColor,
                        ),
                      ],
                    ),
                  ),

                  // errand image gallery
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
                                            ontap: () async {
                                              Get.back();
                                              await imageController2.addErrandImageFromGallery(widget.data!['id'].toString()).then((_) {
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
                                            ontap: () async  {
                                              Get.back();
                                              await imageController2
                                                  .addErrandImageFromCamera(widget.data!['id'].toString()).then((_) {
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
                                          child:  imageController2.imageList[index] is Map && imageController2.imageList[index].containsKey('image_path')
                                              ? FadeInImage.assetNetwork(
                                            placeholder: 'assets/images/errandia_logo.png',
                                            image: getImagePathWithSize(
                                              imageController2.imageList[index]['image_path'], width: 200, height: 200
                                            ),
                                            fit: BoxFit.fill,
                                            imageErrorBuilder: (BuildContext context,
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
                                                  imageController2.deleteErrandImage(widget.data!['id'].toString(), index);
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
                      child: imageController2.imageList.isEmpty
                          ? null
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Add more images button
                          InkWell(
                            onTap: () async {
                              // await imageController.addImageFromGallery(widget.data?['slug']).then((_) {
                              //   print("image list: ${imageController.imageList}");
                              //   // Scroll to the end of the list after the state update
                              //   WidgetsBinding.instance.addPostFrameCallback((_) {
                              //     if (_scrollController.hasClients) {
                              //       _scrollController.animateTo(
                              //         _scrollController.position.maxScrollExtent,
                              //         duration: const Duration(milliseconds: 300),
                              //         curve: Curves.easeOut,
                              //       );
                              //     }
                              //   });
                              // });

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
                                                ontap: () async {
                                                  Get.back();
                                                  await imageController2.addErrandImageFromGallery(widget.data!['id'].toString()).then((_) {
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
                                                ontap: () async  {
                                                  Get.back();
                                                  await imageController2
                                                      .addErrandImageFromCamera(widget.data!['id'].toString()).then((_) {
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
                              // showDialog(
                              //     context: context,
                              //     builder: (BuildContext dialogContext) {
                              //       return  CustomAlertDialog(
                              //         title: "Delete all images",
                              //         message: "Are you sure you want to delete all images of this product?",
                              //         dialogType: MyDialogType.error,
                              //         onConfirm: () {
                              //           Get.back();
                              //           print("deleting all images");
                              //           imageController2.deleteAllErrandImages(widget.data!['id'].toString()).then((response) {
                              //             print("***deleted all images response ****: $response");
                              //           });
                              //         },
                              //         onCancel: () {
                              //           Get.back();
                              //         },
                              //       );
                              //     }
                              // ).then((_) {
                              //   print("**** 8888 **8 deleted all images *****888***88888");
                              // });
                              // imageController.deleteAllImages(widget.data?['slug']).then((response) {
                              //   print("delete all images response: $response");
                              // });
                              Get.snackbar("Info", "Still working on this feature", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.yellow[200], colorText: Colors.black);
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: const ListTile(
                      title: Text('Categories '),
                      leading: Icon(
                        FontAwesomeIcons.tags,
                        color: Color.fromARGB(255, 108, 105, 105),
                      ),
                      trailing: Icon(
                        color: Colors.black,
                        Icons.edit,
                      ),
                    ),

                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     border: InputBorder.none,
                    //     prefixIcon: Icon(
                    //       FontAwesomeIcons.tags,
                    //       color: Color.fromARGB(255, 108, 105, 105),
                    //     ),
                    //     hintStyle: TextStyle(
                    //       color: Colors.black,
                    //     ),
                    //     hintText: 'Categories ',
                    //     suffixIcon: Icon(
                    //       color: Colors.black,
                    //       Icons.edit,
                    //     ),
                    //   ),
                    // ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    // height: Get.height * 0.2,
                    child: Obx(() {
                      if (product_controller.isLoadingCategories.isTrue) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (product_controller.categoryList.isEmpty) {
                        return const Center(
                          child: Text('No Categories found'),
                        );
                      } else {
                        return Column(
                          children: [
                            MultiSelectDialogField(
                              checkColor: Colors.white,
                              searchable: true,
                              items: subCategories.Items.map((item) =>
                                  MultiSelectItem(
                                      item.id, item.name.toString())).toList(),
                              title: const Text("Select Categories"),
                              selectedColor: appcolor().mainColor,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              initialValue: selectedFilters,
                              onConfirm: (selectedList) {
                                // Update your selectedFilters list with the selected categories
                                print("selectedList: $selectedList");

                                setState(() {
                                  selectedFilters = selectedList.cast<int>();
                                });
                              },
                            )
                          ],
                        );
                      }
                    }),
                  ),
                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      // setState(() {
                      //   isLoading = true;
                      // });
                      // uploadImage(widget.title, widget.description, selectedFilters, widget.street, widget.town, widget.region);
                      //  PanDocumentInfoupload(widget.title, widget.description, selectedFilters, widget.street, widget.town, widget.region);
                      updateErrand(context);
                      // Get.snackbar("Info", "😔 Still working on this feature", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.yellow[200], colorText: Colors.black);
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Container(
                        height: Get.height * 0.09,
                        width: Get.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffe0e6ec),
                        ),
                        child: const Center(
                          child: Text(
                            'SAVE',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                      'We\'re updating your errand...',
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

//   Future<void> PanDocumentInfoupload(
//     String title,
//     description,
//     category,
//     streetid,
//     townid,
//     regionid,
//   ) async {
//     var file = selectedFilterss[0].toString();
//     // Create a MultipartRequest
// //print(selectedFilterss);
//
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = prefs.getString('token');
//     for (int i = 1; i < selectedFilterss.length; i++) {
//       file = file + "," + selectedFilterss[i].toString();
//     }
//     print(file);
//     var uri = Uri.parse(
//         '${apiDomain().domain}errands?title=${title}&description=${description}&categories=$file&image_count=${imageController.imageList.length}');
//     var request = http.MultipartRequest("POST", uri)
//       ..headers['Authorization'] = 'Bearer $token';
//     for (int i = 0; i < imageController.imageList.length; i++) {
//       for (var image in imageController.imageList) {
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'image_${i + 1}', // Field name for each image
//             image.path,
//           ),
//         );
//       }
//     }

    // request.fields['title'] =  '$title';
    //   request.fields['description'] =  '$description';
    //   request.fields['categories'] =  '$category';
    //   request.fields['street'] =  '$streetid';
    //   request.fields['town'] =  '$townid';
    //   request.fields['region'] =  '$regionid';
    // Send the request
    // try {
    //   var response = await request.send();
    //   if (response.statusCode == 200) {
    //     Get.offAll(() => errand_view());
    //     setState(() {
    //       isLoading = false;
    //       imageController.imageList.clear();
    //     });
    //     // Handle the API response here
    //   } else {
    //     print('Failed to upload images. Status code: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   print('Error uploading images: $e');
    // }
    //
    // try {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var token = prefs.getString('token');
    //   var uri = Uri.parse('${apiDomain().domain}errands'); // Replace with your server's endpoint
    //
    //   var request = http.MultipartRequest("POST", uri)
    //     ..headers['Authorization'] = 'Bearer $token';
    //   // Add images to the request
    //
    //   if (imageController.imageList != null) {
    //     request.files.add(await http.MultipartFile.fromPath('image_count', imageController.imageList));
    //   }
    //
    //   request.fields['title'] =  '$title';
    //   request.fields['description'] =  '$description';
    //   request.fields['categories'] =  '$category';
    //   request.fields['street'] =  '$streetid';
    //   request.fields['town'] =  '$townid';
    //   request.fields['region'] =  '$regionid';
    //
    //
    //   var response = await request.send();
    //   if (response.statusCode == 200) {
    //     final res = await http.Response.fromStream(response);
    //     var rest = jsonDecode(res.body);
    //     if (rest['status'] == true) {
    //       setState(() {
    //
    //       });
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${rest['message']}')));
    //     } else {
    //       alertBoxdialogBox(context, 'Alert', '${rest['message']}');
    //     }
    //   }else {
    //     print("Failed to upload images. Status code: ${response.statusCode}");
    //   }
    // } catch (e) {
    //   print("Error: $e");
    // }
  // }
}
