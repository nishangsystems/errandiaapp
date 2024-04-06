import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_results.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:errandia/modal/subcategory.dart';
import 'package:errandia/modal/subcatgeory.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
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

class nd_screen extends StatefulWidget {
  final title;
  final description;
  final region;
  final town;
  final street;

  nd_screen(
      {super.key,
      this.title,
      this.description,
      this.region,
      this.town,
      this.street});

  @override
  State<nd_screen> createState() => _nd_screenState();
}

class _nd_screenState extends State<nd_screen> {
  late add_product_cotroller product_controller;
  late errand_controller errandController;
  late imagePickercontroller imageController;
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

  @override
  void initState() {
    super.initState();
    product_controller = Get.put(add_product_cotroller());
    errandController = Get.put(errand_controller());
    imageController = Get.put(imagePickercontroller());
    homeController = Get.put(home_controller());
    product_controller.loadCategories();
    ischip2 = List.filled(
      subCetegoryData.Items.length,
      false,
    );
  }

  void runErrand(Map<String, dynamic> data) async {
    await ErrandsAPI.runErrand(data['data']['item']['id'].toString()).then((response_) {
      if (response_ != null) {
        var response = jsonDecode(response_);
        print("rerun errand response: $response");

        // Check if the widget is still in the tree
        if (response["status"] == 'success') {
          errandController.reloadMyErrands();
          homeController.reloadRecentlyPostedItems();

          // Navigator.of(dialogContext).pop(); // Close the dialog
          getErrandResultsInBackground(data['data']['item']['id'].toString(), response['data']);
          // Show success popup
          Get.snackbar("Info", response['message'],
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,)
          );
        } else {
          // Navigator.of(dialogContext).pop(); // Close the dialog
          Get.back();
          Get.back();
          Get.snackbar("Error", response['message'],
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,)
          );
          print("rerun errand error: ${response}");
        }

        // popup.showPopup(context); // Show the popup
      }
    });
  }

  void runErrandInBackground(Map<String, dynamic> response) async {
    const config = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Errandia',
      notificationText: 'Your errand is running in the background',
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
        name: 'ic_launcher',
        defType: 'mipmap',
      ),
      enableWifiLock: true,
      showBadge: true,
    );

    var hasPermissions = await FlutterBackground.hasPermissions;
    
    if (!hasPermissions) {
      var requestPermissions;
      // await FlutterBackground.requestPermissions;
      print("PERMISSIONS NOT PROVIDED");
    }
    
    hasPermissions = await FlutterBackground.initialize(androidConfig: config);

    if (hasPermissions) {
      if (hasPermissions) {
        final backgroundExecution = await FlutterBackground.enableBackgroundExecution();

        if (backgroundExecution) {
         runErrand(response);
        }
      }
    }
  }

  // open errand results page after 5 seconds in the background
  void getErrandResultsInBackground(String errandId, Map<String, dynamic> data) async {
    const config = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Errandia',
      notificationText: 'Your errand is running in the background',
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
        name: 'ic_launcher',
        defType: 'mipmap',
      ),
      enableWifiLock: true,
      showBadge: true,
    );

    var hasPermissions = await FlutterBackground.hasPermissions;

    if (!hasPermissions) {
      var requestPermissions;
      // await FlutterBackground.requestPermissions;
      print("PERMISSIONS NOT PROVIDED");
    }

    hasPermissions = await FlutterBackground.initialize(androidConfig: config);

    if (hasPermissions) {
      if (hasPermissions) {
        final backgroundExecution = await FlutterBackground.enableBackgroundExecution();

        if (backgroundExecution) {
          Future.delayed(const Duration(seconds: 5), () {
            Get.to(() => ErrandResults(data: data, errandId: errandId));
          });
        }
      }
    }
  }

  void createErrand(BuildContext context) async {
    print("categories listing: ${listToString(selectedFilters)}");
    print("imageList: ${imageController.imageList}");
    if (widget.title == null || widget.title == "") {
      alertDialogBox(context, "Error", 'Product/Service Name is required');
    } else {
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
        'title': widget.title.toString(),
        'description': widget.description.toString(),
        'categories': listToString(selectedFilters).toString(),
        'region_id': widget.region.toString() ?? "",
        'town_id': widget.town.toString() ?? "",
      };

      print("value: $value");

      await ErrandsAPI.createErrand(value, imageController.imageList).then((response_) async {
        print("reponse: $response_");
        var response = jsonDecode(response_);
        if (response['status'] == 'success') {
          if (kDebugMode) {
            print("Errand created successfully");
          }
          errandController.reloadMyErrands();
          homeController.reloadRecentlyPostedItems();
          setState(() {
            isLoading = false;
            imageController.imageList.clear();
            imageController.imagePaths.clear();
            selectedFilters.clear();
          });

          runErrandInBackground(response);

          popup = PopupBox(
            title: 'Success',
            description: response['message'],
            type: PopupType.success,
            callback: () {
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //     builder: (context) => errand_view(),
              //   ),
              //   (route) => false,
              // );
              Get.back();
              Get.back();
              // print("response: $response");

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
  void dispose() {
    super.dispose();
    FlutterBackground.disableBackgroundExecution();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 8,
        title: Text(
          'New Errand'.tr,
          style: TextStyle(
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
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xff113d6b),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Text(
                    '2- Upload Photos'.tr,
                    style: TextStyle(
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

                Obx(
                  () => Container(
                    height: imageController.imageList.isEmpty ? null : null,
                    child: imageController.imageList.isEmpty
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
                                    content: Container(
                                      // height: Get.height * 0.7,
                                      width: Get.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                      color:
                                                          appcolor().mainColor,
                                                      size: 22,
                                                    ),
                                                    Text(
                                                      '  Image Gallery',
                                                      style: TextStyle(
                                                          color: appcolor()
                                                              .mainColor),
                                                    ),
                                                  ],
                                                ),
                                                ontap: () {
                                                  Get.back();
                                                  imageController
                                                      .getmultipleImage();
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
                                                      color:
                                                          appcolor().mainColor,
                                                      size: 22,
                                                    ),
                                                    Text(
                                                      '  Take Photo',
                                                      style: TextStyle(
                                                        color: appcolor()
                                                            .mainColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ontap: () {
                                                  Get.back();
                                                  imageController
                                                      .getMultipleimagefromCamera();
                                                },
                                                color: Color(0xfffafafa),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            height: Get.height * 0.24,
                            child: Center(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: imageController.imageList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        height: Get.height * 0.15,
                                        width: Get.width * 0.40,
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        child: Image(
                                          image: FileImage(
                                            File(
                                              imageController
                                                  .imageList[index].path
                                                  .toString(),
                                            ),
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                imageController.edit(index);
                                              },
                                              child: Container(
                                                height: 35,
                                                width: Get.width * 0.20,
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
                                                imageController.removeat(index);
                                              },
                                              child: Container(
                                                height: 35,
                                                width: Get.width * 0.2,
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
                                  ).paddingSymmetric(horizontal: 5);
                                },
                              ),
                            ),
                          ),
                  ),
                ),

                //  image container
                Obx(
                  () => Container(
                    child: imageController.imageList.isEmpty
                        ? null
                        : InkWell(
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
                                    content: Container(
                                      // height: Get.height * 0.7,
                                      width: Get.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                      color:
                                                          appcolor().mainColor,
                                                      size: 22,
                                                    ),
                                                    Text(
                                                      '  Image Gallery',
                                                      style: TextStyle(
                                                          color: appcolor()
                                                              .mainColor),
                                                    ),
                                                  ],
                                                ),
                                                ontap: () {
                                                  Get.back();
                                                  imageController
                                                      .getmultipleImage();
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
                                                      color:
                                                          appcolor().mainColor,
                                                      size: 22,
                                                    ),
                                                    Text(
                                                      '  Take Photo',
                                                      style: TextStyle(
                                                        color: appcolor()
                                                            .mainColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ontap: () {
                                                  Get.back();
                                                  imageController
                                                      .getimagefromCamera();
                                                },
                                                color: Color(0xfffafafa),
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: appcolor().skyblueColor,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              height: Get.height * 0.08,
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                  ),
                                  Text(
                                    '   Add more images',
                                  ),
                                ],
                              ),
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
                    createErrand(context);
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
                          'RUN ERRAND',
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
                    'We\'re creating your errand...',
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
    );
  }

  Future<void> PanDocumentInfoupload(
    String title,
    description,
    category,
    streetid,
    townid,
    regionid,
  ) async {
    var file = selectedFilterss[0].toString();
    // Create a MultipartRequest
//print(selectedFilterss);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    for (int i = 1; i < selectedFilterss.length; i++) {
      file = file + "," + selectedFilterss[i].toString();
    }
    print(file);
    var uri = Uri.parse(
        '${apiDomain().domain}errands?title=${title}&description=${description}&categories=$file&image_count=${imageController.imageList.length}');
    var request = http.MultipartRequest("POST", uri)
      ..headers['Authorization'] = 'Bearer $token';
    for (int i = 0; i < imageController.imageList.length; i++) {
      for (var image in imageController.imageList) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image_${i + 1}', // Field name for each image
            image.path,
          ),
        );
      }
    }

    // request.fields['title'] =  '$title';
    //   request.fields['description'] =  '$description';
    //   request.fields['categories'] =  '$category';
    //   request.fields['street'] =  '$streetid';
    //   request.fields['town'] =  '$townid';
    //   request.fields['region'] =  '$regionid';
    // Send the request
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        Get.offAll(() => errand_view());
        setState(() {
          isLoading = false;
          imageController.imageList.clear();
        });
        // Handle the API response here
      } else {
        print('Failed to upload images. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
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
  }
}
