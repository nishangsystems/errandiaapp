import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_results.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../modal/Region.dart';
import '../../../../modal/Street.dart';
import '../controller/newErradiaController.dart';
import '2nd_screen_new_errand.dart';

class New_Errand extends StatefulWidget {
  const New_Errand({super.key});

  @override
  State<New_Errand> createState() => _NewErrandState();
}

class _NewErrandState extends State<New_Errand> {
  late errand_controller errandController;
  late new_errandia_controller newErrandController;
  late imagePickercontroller imageController;
  late home_controller homeController;
  late ScrollController _scrollController;

  var value;
  var town_;
  bool isLoading = false;
  bool displayTownInfo = false;
  late PopupBox popup;
  List<int?> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    errandController = Get.put(errand_controller());
    newErrandController = Get.put(new_errandia_controller());
    imageController = Get.put(imagePickercontroller());
    homeController = Get.put(home_controller());
    _scrollController = ScrollController();

    errandController.townList.clear();
  }

  void runErrand(Map<dynamic, dynamic> data) async {
    print("response errand data: $data");
    await ErrandsAPI.runErrand(data['data']['item']['id'].toString())
        .then((response_) {
      if (response_ != null) {
        var response = jsonDecode(response_);
        print("rerun errand response: $response");

        // Check if the widget is still in the tree
        if (response["status"] == 'success') {
          errandController.reloadMyErrands();
          homeController.reloadRecentlyPostedItems();

          print("run errand data $response");
          // Navigator.of(dialogContext).pop(); // Close the dialog

          // Show success popup
          Get.snackbar("Info", response['message'],
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.yellowAccent,
              colorText: Colors.black,
              duration: const Duration(seconds: 5),
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ));
          print("errand Id: ${ data['data']['item']['id'].toString()}");
          getErrandResultsInBackground(
              data['data']['item']['id'].toString(), response['data']);

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
                vertical: 15,
              ));
          print("rerun errand error: ${response}");
        }

        // popup.showPopup(context); // Show the popup
      }
    });
  }

  void runErrandInBackground(Map<dynamic, dynamic> response) async {
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
        final backgroundExecution =
            await FlutterBackground.enableBackgroundExecution();

        if (backgroundExecution) {
          runErrand(response);
        }
      }
    }
  }

  // open errand results page after 5 seconds in the background
  void getErrandResultsInBackground(
      String errandId, Map<dynamic, dynamic> data) async {
    print("errandId: $errandId");
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
        final backgroundExecution =
            await FlutterBackground.enableBackgroundExecution();

        if (backgroundExecution) {
          print("still errandId: $errandId");
          Future.delayed(const Duration(seconds: 10), () {
            print("Navigating to ErrandResults with errandId: $errandId and data: $data");

            Get.to(() => ErrandResults(data: data, errandId: errandId));
          });
        }
      }
    }
  }

  void createErrand() async {
    newErrandController.isLoading.value = true;
    setState(() {
      isLoading = true;
    });
    var value = {
      'title': newErrandController.titleController.text,
      'description': newErrandController.descriptionController.text,
      'region_id': newErrandController.regionCode.value,
      'town_id': newErrandController.town.value,
    };

    print("value: $value");
    // API call to create errand
    await ErrandsAPI.createErrand(value, imageController.imageList)
        .then((response_) async {
      print("reponse: $response_");
      var response = jsonDecode(response_);
      if (response['status'] == 'success') {
        if (kDebugMode) {
          print("Errand created successfully");
        }
        errandController.reloadMyErrands();
        homeController.reloadRecentlyPostedItems();
        newErrandController.isLoading.value = false;
        setState(() {
          isLoading = false;
          imageController.imageList.clear();
          imageController.imagePaths.clear();
          selectedFilters.clear();
        });

        Get.snackbar("Info", response['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ));

        runErrandInBackground(response);
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

    // Reset form after successful creation
    newErrandController.titleController.clear();
    newErrandController.descriptionController.clear();
    newErrandController.regionCode.value = '';
    newErrandController.town.value = '';
    imageController.imageList.clear();
  }

  void uploadImages(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.image,
                            color: appcolor().mainColor,
                            size: 22,
                          ),
                          Text(
                            '  Image Gallery',
                            style: TextStyle(color: appcolor().mainColor),
                          ),
                        ],
                      ),
                      ontap: () async {
                        Get.back();
                        await imageController.getmultipleImage().then((_) {
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
                      color: appcolor().greyColor,
                    ),
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                    blockButton(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                        await imageController
                            .getMultipleimagefromCamera()
                            .then((_) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[700],
        titleSpacing: 8,
        title: const Text(
          'New Errand',
        ),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Kindly provide details of this errand and we\'ll run it for you.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Item'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: newErrandController.titleController,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      isDense: true,
                      hintText: 'E.g. Laptop charger, smart screen TV',

                      // rounded border
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: appcolor().greyColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.black87.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.black87.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Description'),
                  const SizedBox(height: 5),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 3,
                    maxLines: null,
                    controller: newErrandController.descriptionController,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    onChanged: (value) {
                      newErrandController.update();
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        isDense: true,
                        hintText:
                            'E.g. I am looking for a 15 inch smart screen TV with remote, preferably second hand.',
                        // rounded border
                        hintMaxLines: 3,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: appcolor().greyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.black87.withOpacity(0.5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.black87.withOpacity(0.5)),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Region (optional)'),
                  const SizedBox(height: 5),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Obx(() {
                      return DropdownButton<dynamic>(
                        value:  newErrandController.regionCode.value.isNotEmpty
                            ? newErrandController.regionCode.value
                            : null,
                        onChanged: (value) {
                          newErrandController.regionCode.value = value as String;
                          newErrandController.town.value = '';
                          print(
                              "regionCode: ${newErrandController.regionCode.value}");
                          errandController.loadTownsData(
                              int.parse(newErrandController.regionCode.value));
                          setState(() {
                            displayTownInfo = false;
                          });
                          newErrandController.update();
                        },
                        underline: const SizedBox(),
                        isExpanded: true,
                        hint: Text(
                          'Select a preferred region for the errand',
                          style: TextStyle(
                              color: Colors.black87.withOpacity(0.5),
                              fontSize: 15),
                        ),
                        style: const TextStyle(color: Colors.black),
                        dropdownColor: Colors.white,
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.black87.withOpacity(0.5)),
                        items: Regions.Items.map((e) => DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(
                            e.name.toString(),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                        )).toList(),
                      );
                    }),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Town (optional)'),
                  const SizedBox(height: 5),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    child: Obx(() {
                      if (errandController.isTownsLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return GestureDetector(
                          onTap: () {
                            if (newErrandController.regionCode.value.isEmpty) {
                              setState(() {
                                displayTownInfo = true;
                              });
                            } else {
                              setState(() {
                                displayTownInfo = false;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            absorbing: newErrandController.regionCode.value.isEmpty,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                value: newErrandController.town.value.isNotEmpty
                                    ? newErrandController.town.value
                                    : null,
                                onChanged: (value) async {
                                  newErrandController.town.value = value!;
                                  print("townId: ${newErrandController.town.value}");
                                  newErrandController.update();
                                },
                                underline: const SizedBox(),
                                isExpanded: true,
                                style: const TextStyle(color: Colors.black),
                                hint: Text(
                                  'Select a preferred town for the errand',
                                  style: TextStyle(
                                    color: Colors.black87.withOpacity(0.5),
                                    fontSize: 15,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black87.withOpacity(0.5),
                                ),
                                items: errandController.townList.map((e) {
                                  return DropdownMenuItem<String>(
                                    value: e['id'].toString(),
                                    child: Text(
                                      e['name'].toString(),
                                      style: const TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  )
                ],
              ),
              // Display error message if region is not selected
              displayTownInfo
                  ? const Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text(
                        'Please select a region first',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Sample Images (optional)'),
                const SizedBox(height: 5),
                Obx(() => Container(
                    height: imageController.imageList.isEmpty ? null : null,
                    child: imageController.imageList.isEmpty
                        ? InkWell(
                            onTap: () {
                              uploadImages(context);
                            },
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: appcolor().greyColor.withOpacity(0.4),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
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
                                  SizedBox(
                                    width: Get.width * 0.7,
                                    child: Text(
                                      'You can upload as many variations of the product or service',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: appcolor().mediumGreyColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Obx(() {
                            return imageController.imageList.isNotEmpty
                                ? Container(
                                    height: 120,
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          imageController.imageList.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Image.file(
                                                File(imageController
                                                    .imageList[index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  imageController
                                                      .removeat(index);
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }))),
                // Add more images
                Obx(
                  () => Container(
                    child: imageController.imageList.isEmpty
                        ? null
                        : InkWell(
                            onTap: () {
                              uploadImages(context);
                            },
                            child: Container(
                              // margin: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                                color: appcolor().greyColor.withOpacity(0.4),
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
              ]),
              const SizedBox(height: 30),
              Obx(() {
                return InkWell(
                  onTap: newErrandController.isFormFilled && !newErrandController.isLoading.value
                      ? () {
                    // if (errandController.isTownsLoading.value) {
                    //   newErrandController.town.value = '';
                    //   newErrandController
                    // }
                          createErrand();
                        }
                      : null,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: newErrandController.isFormFilled  && !newErrandController.isLoading.value
                          ? Colors.blue[700]
                          : const Color(0xffe0e6ec),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: newErrandController.isLoading.value
                          ? CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueGrey.withOpacity(0.5)),
                      )
                          : Text(
                        'RUN ERRAND',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: newErrandController.isFormFilled
                              ? Colors.white
                              : Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
