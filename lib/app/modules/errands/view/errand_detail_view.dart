import 'dart:async';
import 'dart:convert';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/errands/controller/errandia_detail_view_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_results.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/pill_widget.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/main.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class errand_detail_view extends StatefulWidget {
  final data;
  bool received;

  errand_detail_view({super.key, this.data, this.received = false});

  @override
  _errand_detail_viewState createState() => _errand_detail_viewState();
}

class _errand_detail_viewState extends State<errand_detail_view> {
  late errandia_detail_view_controller detailController;
  late errand_controller errandController;
  late home_controller homeController;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late PopupBox popup;

  late ScrollController _scrollController;
  late profile_controller profileController;

  late Timer _timer;
  int _delta = 1; // How much we scroll every time the timer ticks
  bool _leftToRight = true; // Direction of the scroll

  @override
  void initState() {
    super.initState();
    detailController = Get.put(errandia_detail_view_controller());
    errandController = Get.put(errand_controller());
    homeController = Get.put(home_controller());
    profileController = Get.put(profile_controller());
    _scrollController = ScrollController();
    _startAutoScroll();

    profileController.getUser();
  }

  void _startAutoScroll() {
    try {
      _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double newScroll = currentScroll + _delta;

        if (newScroll > maxScroll || newScroll < 0) {
          _leftToRight = !_leftToRight;
          _delta = -_delta; // Reverse the direction
        }

        _scrollController.jumpTo(newScroll.clamp(0.0, maxScroll));
      });
    } catch (e) {
      print("error starting auto scroll: $e");
    }
  }

  // convert categories to string
  String categoriesString(List categories) {
    String categoryString = "";
    for (int i = 0; i < categories.length; i++) {
      categoryString += categories[i]['name'];
      if (i != categories.length - 1) {
        categoryString += ", ";
      }
    }
    return categoryString;
  }

  String _formatAddress(Map<String, dynamic> item) {
    print("item: $item");
    // String street = item['street'].toString() != '[]' && '';
    String townName = item['town'].toString() != '[]' && item['town'] != ""
        ? item['town']['name']
        : '';
    String regionName =
    item['region'].toString() != '[]' && item['region'] != ""
        ? item['region']['name'].split(" -")[0]
        : '';

    return [townName, regionName].where((s) => s.isNotEmpty).join(", ").trim();
  }

  // show email if phone is not available and vice versa
  bool isPhoneAvailable(Map<String, dynamic> item) {
    return item['phone'] != null && item['phone'] != "";
  }

  bool isEmailAvailable(Map<String, dynamic> item) {
    return item['email'] != null && item['email'] != "";
  }

  // check if categories are empty
  bool categoriesEmpty(List categories) {
    return categories.toString() == "[]";
  }

  // check if photos are empty
  bool isPhotosEmpty(List photos) {
    return photos.isEmpty;
  }



  bool hasActiveSubscription() {
    print("has active subscription: ${widget.data['user']['active_subscription']}");
    String? userDataString = ErrandiaApp.prefs.getString('user');

    if (userDataString != null) {
      var userData = jsonDecode(userDataString);
      print("user data on errand detail: $userData");
      return userData['active_subscription'];
    }

    return false;

  }

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

// rerun an errand
  void rerunAnErrand(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use dialogContext
        var response;
        return CustomAlertDialog(
            title: "Alert!",
            message:
                "This action will rerun the errand and send notifications to corresponding businesses. \n"
                "Are you willing to proceed?\n",
            dialogType: MyDialogType.info,
            onConfirm: () {
              // delete product
              print("rerun errand: $id");
              ErrandsAPI.runErrand(id.toString()).then((response_) {
                if (response_ != null) {
                  response = jsonDecode(response_);
                  print("rerun errand response: $response");

                  // Check if the widget is still in the tree
                  if (response["status"] == 'success') {
                    errandController.reloadMyErrands();
                    homeController.reloadRecentlyPostedItems();

                    getErrandResultsInBackground(id.toString(), response['data']);

                    Navigator.of(dialogContext).pop(); // Close the dialog

                    // Show success popup
                    Get.snackbar("Info", response['message'],
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 5),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ));
                  } else {
                    Navigator.of(dialogContext).pop(); // Close the dialog

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
            },
            onCancel: () {
              // cancel delete
              print("cancel rerun");
              Navigator.of(dialogContext).pop(); // Close the dialog
            });
      },
    ).then((_) {
      if (mounted) {
        try {
          popup.dismissPopup(navigatorKey.currentContext!); // Dismiss the popup
        } catch (e) {
          print("error dismissing popup: $e");
        }
        errandController.reloadMyErrands();
        // Get.back();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("errand details: ${widget.data}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            // size: 30,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Errand Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
          size: 30,
        ),
        actions: [
          if (!widget.received && homeController.loggedIn.value)
            IconButton(
              onPressed: () {
                // rerun an errand
                rerunAnErrand(context, widget.data['id']);
              },
              icon: const Icon(
                Icons.replay,
                // size: 30,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * 0.3,
              child: Text(
                'Title',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: appcolor().darkBlueColor.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(
              width: Get.width * 0.88,
              child: Text(
                capitalizeAll(widget.data['title']),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: appcolor().darkBlueColor,
                ),
              ),
            ),
            // Divider(
            //   color: appcolor().darkBlueColor.withOpacity(0.1),
            //   thickness: 1,
            // ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            SizedBox(
              width: Get.width * 0.3,
              child: Text(
                'Description',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: appcolor().darkBlueColor.withOpacity(0.5)),
              ),
            ),
            ReadMoreText(
              capitalize(widget.data['description']),
              trimLength: 150,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: appcolor().darkBlueColor,
              ),
              textAlign: TextAlign.left,
              trimMode: TrimMode.Length,
              trimCollapsedText: 'read more',
              trimExpandedText: ' read less',
              moreStyle: TextStyle(
                color: appcolor().mainColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              lessStyle: TextStyle(
                color: appcolor().mainColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            // Divider(
            //   color: appcolor().darkBlueColor.withOpacity(0.1),
            //   thickness: 1,
            // ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            if (!categoriesEmpty(widget.data['categories']))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width * 0.3,
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: appcolor().darkBlueColor.withOpacity(0.5)),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.035,
                  ),
                  PillsDisplay(
                      text: categoriesString(widget.data['categories'])),
                ],
              ),
            // Divider
            Divider(
              color: appcolor().darkBlueColor.withOpacity(0.1),
              thickness: 1,
            ),

            SizedBox(
              height: Get.height * 0.015,
            ),
            Text(
              'Posted By',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: appcolor().darkBlueColor.withOpacity(0.5)),
            ),
            const SizedBox(
              height: 5,
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    // width: Get.width * 0.5,
                    height: Get.height * 0.1,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: appcolor().mainColor,
                      backgroundImage: widget.data['user']['photo'] == ""
                          ? const AssetImage(
                          'assets/images/errandia_logo.png') // Fallback image
                          : NetworkImage(getImagePath(
                          widget.data['user']['photo'].toString()))
                      as ImageProvider,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.03,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * 0.71,
                        child: Text(
                          capitalizeAll(widget.data['user']['name'].toString()),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: appcolor().mainColor,
                            textBaseline: TextBaseline.alphabetic,
                          ),
                          textScaleFactor: 1.0,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isLocationAvailable(widget.data['user']))
                        Text(
                          _formatAddress(widget.data['user']),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: appcolor().mainColor,
                          ),
                        ),
                      if (isLocationAvailable(widget.data['user']))
                        SizedBox(
                          height: Get.height * 0.015,
                        ),

                      Container(
                        width: Get.width * 0.71,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.data['when'].trim(),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: appcolor().mainColor,
                                ),
                              ),

                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (isPhoneAvailable(widget.data['user']) && hasActiveSubscription() && homeController.loggedIn.value)
                                      InkWell(
                                        onTap: () {
                                          launchCaller(widget.data['user']['phone']);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                                color: Colors.green,
                                                width: 1.5
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                  Icons.call,
                                                  color: appcolor().greenColor.withOpacity(0.9),
                                                  size: 16
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (isEmailAvailable(widget.data['user']) && hasActiveSubscription() && homeController.loggedIn.value)
                                      SizedBox(
                                        width: Get.width * 0.02,
                                      ),
                                    if (isEmailAvailable(widget.data['user']) && hasActiveSubscription() && homeController.loggedIn.value)
                                      InkWell(
                                        onTap: () {
                                          launchEmail(widget.data['user']['email']);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                                color: appcolor().mainColor,
                                                width: 1.5
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                  Icons.email,
                                                  color: appcolor().mainColor,
                                                  size: 16
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ]
                              )
                            ]
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ).marginZero.paddingZero,

            const SizedBox(
              height: 10,
            ),

            //photo container
            if (!isPhotosEmpty(widget.data['images']))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Photos',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: appcolor().darkBlueColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    height: 100,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: widget.data['images'].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            color: Colors.grey[300],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            child: Center(
                              child: FadeInImage.assetNetwork(
                                placeholder:
                                    'assets/images/errandia_logo.png',
                                image: getImagePathWithSize(
                                    widget.data['images'][index]
                                        ['image_path'],
                                    width: 100,
                                    height: 100),
                                fit: BoxFit.contain,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/errandia_logo.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
              ],
            ),
          ],
        ).paddingOnly(
          left: 20,
          top: 20,
          right: 10,
          bottom: 20,
        ),
      ),
    );
  }
}
