import 'dart:convert';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/subscription/view/manage_subscription_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class ReceivedErrandsView extends StatefulWidget {
  const ReceivedErrandsView({Key? key}) : super(key: key);

  @override
  _ReceivedErrandsViewState createState() => _ReceivedErrandsViewState();
}

class _ReceivedErrandsViewState extends State<ReceivedErrandsView>
    with WidgetsBindingObserver {
  late errand_tab_controller tabController;
  late home_controller homeController;
  late errand_controller errandController;

  late ScrollController _scrollController2;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late PopupBox popup;
  late business_controller businessController;
  late profile_controller profileController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scrollController2 = ScrollController();
    errandController = Get.put(errand_controller());
    homeController = Get.put(home_controller());
    tabController = Get.put(errand_tab_controller());
    businessController = Get.put(business_controller());
    profileController = Get.put(profile_controller());

    homeController.loadIsLoggedIn();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      errandController.fetchMyErrands();
      errandController.fetchReceivedErrands();
    });

    _scrollController2.addListener(() {
      if (_scrollController2.position.pixels ==
          _scrollController2.position.maxScrollExtent) {
        errandController.fetchReceivedErrands();
      }
    });
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

  bool isWhatsAppAvailable(Map<String, dynamic> item) {
    return item['whatsapp_number'] != null && item['whatsapp_number'] != "";
  }

  void rejectErrand(BuildContext context, data) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use dialogContext
        var response;
        return CustomAlertDialog(
            title: "Reject Errand",
            message: "Are you sure you want to reject this errand?\n"
                "This action cannot be undone.\n",
            dialogType: MyDialogType.error,
            onConfirm: () async {
              try {
                var response_ = await ErrandsAPI.rejectReceivedErrand(
                    data['errand_received_id'].toString());
                if (response_ != null) {
                  response = jsonDecode(response_);
                  print("reject business response: $response");

                  if (response["status"] == 'success') {
                    errandController.reloadReceivedErrands();
                    homeController.reloadRecentlyPostedItems();

                    // Close the dialog
                    Navigator.of(dialogContext).pop();

                    // Show success popup
                    Get.snackbar(
                      'Success',
                      response['message'],
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    );
                  } else {
                    Navigator.of(dialogContext).pop(); // Close the dialog

                    // Show error popup
                    Get.snackbar(
                      'Error',
                      response['message'],
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    );
                  }
                }
              } catch (e) {
                print("Error: $e");
              }
            },
            onCancel: () {
              // cancel delete
              print("cancel reject");
              Get.back(); // Close the dialog
            });
      },
    ).then((_) {
      // if (mounted) {
      //   try {
      //     popup.dismissPopup(navigatorKey.currentContext!); // Dismiss the popup
      //   } catch (e) {
      //     print("error dismissing popup: $e");
      //   }
      errandController.reloadReceivedErrands();
      //   Get.back();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget RecievedErrands(BuildContext ctx) {
      return Obx(() {
        if (errandController.isReceivedLoading.isTrue) {
          return buildLoadingWidget();
        } else if (errandController.isReceivedError.isTrue) {
          return buildErrorWidget(
            message: 'An error occurred',
            callback: () {
              errandController.reloadReceivedErrands();
            },
          );
        } else if (errandController.receivedList.isEmpty) {
          return buildErrorWidget(
            message: 'No received errands yet.',
            callback: () {
              errandController.reloadReceivedErrands();
            },
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              errandController.reloadReceivedErrands();
            },
            child: ListView.builder(
              key: const PageStorageKey("myReceivedErrands"),
              controller: _scrollController2,
              itemCount: errandController.receivedList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var data_ = errandController.receivedList[index];
                var date = data_['created_at'].split('T');
                var date1 = date[0].split('-');
                return GestureDetector(
                  onTap: () {
                    Get.to(
                        () => errand_detail_view(
                              data: data_,
                              received: true,
                            ),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 500));
                  },
                  child: Container(
                    // height: Get.height * 0.15,
                    padding: const EdgeInsets.all(
                      10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // top row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // image container
                            Container(
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              width: Get.width * 0.05,
                              height: Get.height * 0.03,
                              child: CircleAvatar(
                                radius: 50,
                                // backgroundColor: Colors.white,
                                backgroundImage: data_['user']['photo'] == "" ||
                                        data_['user']['photo'] == null
                                    ? const AssetImage(
                                        'assets/images/errandia_logo.png') // Fallback image
                                    : NetworkImage(getImagePath(
                                            data_['user']['photo'].toString()))
                                        as ImageProvider,
                                child: data_['user']['photo'] == "" ||
                                        data_['user']['photo'] == null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                                width: 0.5,
                                                color:
                                                    appcolor().darkBlueColor)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.asset(
                                                'assets/images/errandia_logo.png')))
                                    : null, // Only show the icon if there is no photo
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.002,
                            ),
                            SizedBox(
                              width: isLocationAvailable(data_['user'])
                                  ? Get.width * 0.28
                                  : Get.width * 0.34,
                              child: Text(
                                data_['user']['name'].toString(),
                                style: TextStyle(
                                  color: appcolor().mainColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(
                              width: Get.width * 0.003,
                            ),

                            // dot
                            if (isLocationAvailable(data_['user']))
                              Container(
                                width: Get.width * 0.01,
                                height: Get.height * 0.01,
                                decoration: BoxDecoration(
                                  color:
                                      appcolor().darkBlueColor.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),

                            if (isLocationAvailable(data_['user']))
                              SizedBox(
                                width: Get.width * 0.02,
                              ),

                            // location icon
                            if (isLocationAvailable(data_['user']))
                              Icon(
                                Icons.location_on,
                                color: appcolor().mediumGreyColor.withRed(300),
                                size: 12,
                              ),

                            // location text with formatAddress
                            if (isLocationAvailable(data_['user']))
                              SizedBox(
                                width: Get.width * 0.02,
                              ),
                            if (isLocationAvailable(data_['user']))
                              SizedBox(
                                width: Get.width * 0.25,
                                child: Text(
                                  _formatAddress(data_['user']),
                                  style: TextStyle(
                                    color: appcolor().mediumGreyColor,
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            const Spacer(),

                            // delete icon with text
                            InkWell(
                              onTap: () {
                                rejectErrand(context, data_);
                                // Get.snackbar(
                                //   'Delete',
                                //   'Delete this errand',
                                //   snackPosition: SnackPosition.BOTTOM,
                                //   backgroundColor: appcolor().redColor,
                                //   colorText: Colors.white,
                                //   duration: const Duration(seconds: 5),
                                //   margin: const EdgeInsets.only(
                                //     bottom: 15,
                                //     left: 10,
                                //     right: 10,
                                //   ),
                                //   mainButton: TextButton(
                                //     onPressed: () {
                                //       Get.back();
                                //     },
                                //     child: Text(
                                //       'Cancel',
                                //       style: TextStyle(
                                //         color: appcolor().mainColor,
                                //       ),
                                //     ),
                                //   ),
                                // );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Icon(
                                      Icons.delete_forever_outlined,
                                      color:
                                          appcolor().redColor.withOpacity(0.6),
                                      size: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.002,
                                  ),
                                  Text(
                                    'Reject',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: appcolor()
                                            .redColor
                                            .withOpacity(0.6),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: Get.height * 0.005,
                        ),
                        // middle row
                        Row(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width * 0.88,
                                child: Text(
                                  capitalizeAll(data_['title']),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: appcolor().mainColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                width: Get.width * 0.88,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Text(
                                  data_['description'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: appcolor().mediumGreyColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),

                        SizedBox(
                          height: Get.height * 0.013,
                        ),
                        // bottom row
                        Row(children: [
                          // call button
                          // if (isPhoneAvailable(data_['user']) || !isEmailAvailable(data_['user']))
                          if (hasActiveSubscription() &&
                              isPhoneAvailable(data_['user']))
                            InkWell(
                              onTap: () {
                                launchCaller(data_['user']['phone'].toString());
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 8, right: 8),
                                  decoration: BoxDecoration(
                                    color: appcolor().amberColor,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.orangeAccent,
                                    ),
                                    gradient: Gradient.lerp(
                                      LinearGradient(
                                        colors: [
                                          appcolor().skyblueColor,
                                          appcolor().amberColor,
                                        ],
                                      ),
                                      LinearGradient(
                                        colors: [
                                          appcolor().amberColor,
                                          appcolor().skyblueColor,
                                        ],
                                      ),
                                      0.5,
                                    ),
                                  ),
                                  child: Row(children: [
                                    Icon(
                                      Icons.call,
                                      color: appcolor().darkBlueColor,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.01,
                                    ),
                                    Text(
                                      'Call Now',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: appcolor().darkBlueColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ])),
                            ),

                          if (!hasActiveSubscription())
                            // a button to subscribe
                            InkWell(
                              onTap: () {
                                Get.to(() => const subscription_view(),
                                    transition: Transition.rightToLeft,
                                    duration:
                                        const Duration(milliseconds: 500));
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 8, right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  child: Row(children: [
                                    Icon(
                                      Icons.payment,
                                      color: appcolor().redColor,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.01,
                                    ),
                                    Text(
                                      'Subscribe',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: appcolor().redColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ])),
                            ),

                          // posted when
                          const Spacer(),
                          Text(
                            data_['when'],
                            style: TextStyle(
                              color: appcolor().mainColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          // message button
                          if (hasActiveSubscription() &&
                              isWhatsAppAvailable(data_['user']))
                            const Spacer(),

                          if (hasActiveSubscription() &&
                              isWhatsAppAvailable(data_['user']))
                            InkWell(
                              onTap: () {
                                launchWhatsapp(data_['user']['whatsapp_number']
                                    .toString());
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 8, right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.green[700]!,
                                    ),
                                    gradient: Gradient.lerp(
                                      LinearGradient(
                                        colors: [
                                          appcolor()
                                              .greenColor
                                              .withOpacity(0.8),
                                          appcolor().greenColor,
                                        ],
                                      ),
                                      LinearGradient(
                                        colors: [
                                          appcolor().mainColor,
                                          appcolor()
                                              .greenColor
                                              .withOpacity(0.5),
                                        ],
                                      ),
                                      0.5,
                                    ),
                                  ),
                                  child: Row(children: [
                                    const Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.01,
                                    ),
                                    const Text(
                                      'Message',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ])),
                            ),
                        ])
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      });
    }

    return Scaffold(
      endDrawer: CustomEndDrawer(
        onBusinessCreated: () {
          homeController.closeDrawer();
          homeController.featuredBusinessData.clear();
          homeController.fetchFeaturedBusinessesData();
          businessController.itemList.clear();
          businessController.loadBusinesses();
          homeController.recentlyPostedItemsData.clear();
          homeController.fetchRecentlyPostedItemsData();
          profileController.itemList.clear();
          profileController.loadMyBusinesses();
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            // size: 30,
          ),
          onPressed: () {
            Get.back();
            // Get.to(Home_view());
          },
        ),
        // automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Received Errands',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
      ),
      body: RecievedErrands(context),
    );
  }
}

Widget managebottomSheetWidgetitem({
  required String title,
  required IconData icondata,
  required Callback callback,
  Color? color,
}) {
  return InkWell(
    // highlightColor: Colors.grey,

    hoverColor: Colors.grey,
    // focusColor: Colors.grey,
    // splashColor: Colors.grey,
    // overlayColor: Colors.grey,
    onTap: callback,
    child: Row(
      children: [
        Container(
          height: 24,
          child: Icon(
            icondata,
            color: color == null ? Colors.black : color,
          ),
        ),
        SizedBox(
          width: 18,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color == null ? Colors.black : color,
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 15),
  );
}

Widget found_pending_cancel(int index, int status) {
  String s = 'Found';
  Color color = Colors.green;
  IconData icondata = FontAwesomeIcons.circleCheck;
  if (status == 0) {
    s = 'Cancelled';
    color = Colors.red;
    icondata = FontAwesomeIcons.circleXmark;
  }
  if (status == 1) {
    s = 'panding';
    color = Colors.orange;
    icondata = Icons.pending;
  }

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 2,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(
          icondata,
          color: color,
          size: 12,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          s,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        )
      ],
    ),
  );
}
