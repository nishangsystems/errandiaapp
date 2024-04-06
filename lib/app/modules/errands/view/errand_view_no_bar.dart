import 'dart:convert';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/modules/errands/view/edit_errand.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/errands/view/errand_results.dart';
import 'package:errandia/app/modules/errands/view/errand_view.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/Widgets/filter_product_view.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/services/controller/manage_service_controller.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../APi/apidomain & api.dart';
import '../../global/Widgets/blockButton.dart';
import '../../global/constants/color.dart';
import '../controller/errand_controller.dart';
import 'New_Errand.dart';

manage_service_controller service_controller =
    Get.put(manage_service_controller());

class ErrandViewWithoutBar extends StatefulWidget {
  ErrandViewWithoutBar({super.key});

  @override
  ErrandViewWithoutBarState createState() => ErrandViewWithoutBarState();
}

class ErrandViewWithoutBarState extends State<ErrandViewWithoutBar>
    with WidgetsBindingObserver {
  late errand_tab_controller tabController;
  late home_controller homeController;
  late errand_controller errandController;

  late ScrollController _scrollController;
  late ScrollController _scrollController2;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late PopupBox popup;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scrollController = ScrollController();
    _scrollController2 = ScrollController();
    errandController = Get.put(errand_controller());
    homeController = Get.put(home_controller());
    tabController = Get.put(errand_tab_controller());

    homeController.loadIsLoggedIn();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      errandController.fetchMyErrands();
      errandController.fetchReceivedErrands();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        errandController.fetchMyErrands();
      }
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      homeController.loadIsLoggedIn();
      errandController.reloadMyErrands();
      errandController.reloadReceivedErrands();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget PostedErrands(BuildContext ctx) {
      return Obx(() {
        if (errandController.isMyErrandLoading.isTrue) {
          return buildLoadingWidget();
        } else if (errandController.isMyErrandError.isTrue) {
          return buildErrorWidget(
            message: 'An error occurred',
            callback: () {
              errandController.reloadMyErrands();
            },
          );
        } else if (errandController.myErrandList.isEmpty) {
          return buildErrorWidget(
            message: 'No errands found',
            callback: () {
              errandController.reloadMyErrands();
            },
          );
        } else {
          return ListView.builder(
            key: const PageStorageKey('myPostedErrands'),
            controller: _scrollController,
            itemCount: errandController.myErrandList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var data_ = errandController.myErrandList[index];
              var date = data_['created_at'].split('T');
              var date1 = date[0].split('-');
              return Container(
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
                child: Row(
                  children: [
                    // image container
                    // Container(
                    //     margin: const EdgeInsets.only(
                    //       right: 10,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(
                    //         8,
                    //       ),
                    //     ),
                    //     width: Get.width * 0.12,
                    //     height: Get.height * 0.06,
                    //     child: ListView.builder(
                    //         itemCount: data_['images'].length,
                    //         itemBuilder: (context, index) {
                    //           var image = data_['images'][index];
                    //           return Image.network(
                    //             image['url'].toString(),
                    //             errorBuilder: (BuildContext context,
                    //                 Object exception,
                    //                 StackTrace? stackTrace) {
                    //               return Image.asset(
                    //                 'assets/images/errandia_logo.png',
                    //                 fit: BoxFit.fill,
                    //               );
                    //             },
                    //           );
                    //         })),

                    // display first image if available otherwise show default errandia_logo image
                    Container(
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      width: Get.width * 0.14,
                      height: Get.height * 0.06,
                      child: data_['images'].length > 0
                          ? FadeInImage.assetNetwork(
                              placeholder: 'assets/images/errandia_logo.png',
                              image: getImagePathWithSize(
                                  data_['images'][0]['image_path'],
                                  width: 200,
                                  height: 180),
                              fit: BoxFit.fill,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/errandia_logo.png',
                                  fit: BoxFit.fill,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/errandia_logo.png',
                              fit: BoxFit.fill,
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width * 0.45,
                          child: Text(
                            data_['title'].toString(),
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: appcolor().mainColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width * 0.56,
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text(
                            data_['description'].length >= 30
                                ? '${data_['description'] + '..'}'
                                    .substring(0, 30)
                                : data_['description'].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 12,
                              color: appcolor().mediumGreyColor,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'posted on :',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '${date1[2]}-${date1[1]}-${date1[0]}',
                              style: TextStyle(
                                color: appcolor().mainColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.04,
                            ),
                            // found_pending_cancel(index, 3),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        print(index.toString());
                        Get.bottomSheet(
                          // backgroundColor: Colors.white,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.white,
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.horizontal_rule,
                                    size: 25,
                                  ),
                                ),
                                // Text(index.toString()),
                                managebottomSheetWidgetitem(
                                  title: 'Edit Errand',
                                  icondata: Icons.edit,
                                  callback: () async {
                                    if (kDebugMode) {
                                      print('tapped');
                                    }
                                    Get.back();
                                    Get.to(
                                        () => EditErrand(
                                              data: data_,
                                            ),
                                        transition: Transition.rightToLeft,
                                        duration:
                                            const Duration(milliseconds: 500));
                                  },
                                ),
                                managebottomSheetWidgetitem(
                                  title: 'View Errand',
                                  icondata: FontAwesomeIcons.eye,
                                  callback: () {
                                    Get.back();
                                    Get.to(errand_detail_view(
                                      data: data_,
                                    ));
                                  },
                                ),
                                // managebottomSheetWidgetitem(
                                //   title: 'Mark as found',
                                //   icondata: FontAwesomeIcons.circleCheck,
                                //   callback: () {},
                                // ),

                                // view errand results
                                managebottomSheetWidgetitem(
                                  title: 'View Results',
                                  icondata: FontAwesomeIcons.list,
                                  callback: () {
                                    Get.back();
                                    Get.to(() => ErrandResults(
                                          errandId: data_['id'].toString(),
                                        ));
                                  },
                                ),

                                managebottomSheetWidgetitem(
                                  title: 'Delete',
                                  icondata: Icons.delete,
                                  callback: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        // Use dialogContext
                                        var response;
                                        return CustomAlertDialog(
                                            title: "Delete Errand",
                                            message:
                                                "Are you sure you want to delete this errand?\n"
                                                "This action cannot be undone.\n",
                                            dialogType: MyDialogType.error,
                                            onConfirm: () {
                                              // delete product
                                              print(
                                                  "delete errand: ${data_['id']}");
                                              ErrandsAPI.deleteErrand(
                                                      data_['id'].toString())
                                                  .then((response_) {
                                                if (response_ != null) {
                                                  response =
                                                      jsonDecode(response_);
                                                  print(
                                                      "delete business response: $response");

                                                  if (mounted) {
                                                    // Check if the widget is still in the tree
                                                    if (response["status"] ==
                                                        'success') {
                                                      errandController
                                                          .reloadMyErrands();
                                                      homeController
                                                          .reloadRecentlyPostedItems();

                                                      Navigator.of(
                                                              dialogContext)
                                                          .pop(); // Close the dialog

                                                      // Show success popup
                                                      popup = PopupBox(
                                                        title: 'Success',
                                                        description:
                                                            response['data']
                                                                ['message'],
                                                        type: PopupType.success,
                                                      );
                                                    } else {
                                                      Navigator.of(
                                                              dialogContext)
                                                          .pop(); // Close the dialog

                                                      // Show error popup
                                                      popup = PopupBox(
                                                        title: 'Error',
                                                        description:
                                                            response['data']
                                                                ['data'],
                                                        type: PopupType.error,
                                                      );
                                                    }

                                                    popup.showPopup(
                                                        context); // Show the popup
                                                  }
                                                }
                                              });
                                            },
                                            onCancel: () {
                                              // cancel delete
                                              print("cancel delete");
                                              Navigator.of(dialogContext)
                                                  .pop(); // Close the dialog
                                            });
                                      },
                                    ).then((_) {
                                      if (mounted) {
                                        try {
                                          popup.dismissPopup(navigatorKey
                                              .currentContext!); // Dismiss the popup
                                        } catch (e) {
                                          print("error dismissing popup: $e");
                                        }
                                        errandController.reloadMyErrands();
                                        Get.back();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          enableDrag: true,
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'View',
                            style: TextStyle(
                                fontSize: 13,
                                color: appcolor().mediumGreyColor,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: appcolor().greyColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              Icons.more_horiz,
                              color: appcolor().greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      });
    }

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
          return ListView.builder(
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
                  Get.to(() => errand_detail_view(
                        data: data_, received: true,
                      ), transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 500)
                  );
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
                    vertical: 10,
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
                                              color: appcolor().darkBlueColor)),
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
                                color: appcolor().darkBlueColor.withOpacity(0.5),
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
                              Get.snackbar(
                                'Delete',
                                'Delete this errand',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: appcolor().redColor,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 5),
                                margin: const EdgeInsets.only(
                                  bottom: 15,
                                  left: 10,
                                  right: 10,
                                ),
                                mainButton: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: appcolor().mainColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.delete_forever_outlined,
                                    color: appcolor().redColor.withOpacity(0.6),
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
                                      color: appcolor().redColor.withOpacity(0.6),
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
                                kDebugMode
                                    ? data_['description'] +
                                        " sls sieoiuoe eoieur toieie rorieieowieowieiurow woeieow woeiwowiw wowow wow wiwowiw wowowiw woiw woiw wwoiw wowiw woi  slsksls slsl skslsdkd dldksl sld skdlsks dlskdlskdwopk sldpwi soeir elwoieu erueiow eiur eoiwrwoie w"
                                    : data_['description'],
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
                      Row(
                          children: [
                            // call button
                            // if (isPhoneAvailable(data_['user']) || !isEmailAvailable(data_['user']))
                            InkWell(
                              onTap: () {
                                launchCaller(data_['user']['phone'].toString());
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
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
                                child: Row(
                                  children: [
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
                                  ]
                                )
                              ),
                            ),

                            // posted when
                            Spacer(),
                            Text(
                              data_['when'],
                              style: TextStyle(
                                color: appcolor().mainColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // accept button
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Get.snackbar(
                                  'Accept',
                                  'Accept this errand',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: appcolor().greenColor,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 5),
                                  margin: const EdgeInsets.only(
                                    bottom: 15,
                                    left: 10,
                                    right: 10,
                                  ),
                                  mainButton: TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: appcolor().mainColor,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.greenAccent[700]!,
                                  ),
                                  gradient: Gradient.lerp(
                                    LinearGradient(
                                      colors: [
                                        Colors.green.withOpacity(0.8),
                                        Colors.greenAccent[700]!,
                                      ],
                                    ),
                                    LinearGradient(
                                      colors: [
                                        Colors.green,
                                        Colors.green.withOpacity(0.5),
                                      ],
                                    ),
                                    0.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.01,
                                    ),
                                    const Text(
                                      'Accept',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ]
                                )
                              ),
                            ),
                          ]
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      });
    }

    return Scaffold(
        floatingActionButton: Obx(() {
          if (tabController.tabIndex.value == 0) {
            return FloatingActionButton(
              onPressed: () async {
                Get.to(() => const New_Errand());
              },
              backgroundColor: appcolor().mainColor,
              child: Icon(
                Icons.add,
                color: appcolor().skyblueColor,
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        }),
        endDrawer: Drawer(
          width: Get.width * 0.7,
          child: SafeArea(
            child: Column(
              children: [
                blockButton(
                  title: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      hintText: 'Search Product',
                    ),
                  ),
                  ontap: () {},
                  color: Colors.white,
                ).paddingOnly(
                  bottom: 20,
                ),
                blockButton(
                  title: const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  ontap: () {},
                  color: appcolor().mainColor,
                )
              ],
            ).paddingSymmetric(horizontal: 10, vertical: 50),
          ),
        ),
        body: SafeArea(
          child: Builder(
            builder: (ctx) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    'Errands',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: appcolor().mainColor,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: appcolor().greyColor,
                      ),
                    ),
                  ),
                  height: Get.height * 0.08,
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    dividerColor: appcolor().bluetextcolor,
                    isScrollable: false,
                    unselectedLabelColor: appcolor().mediumGreyColor,
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    indicatorColor: appcolor().mainColor,
                    labelColor: appcolor().bluetextcolor,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appcolor().mainColor,
                      fontSize: 18,
                    ),
                    controller: tabController.tab_controller,
                    tabs: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text('Posted'),
                      ),
                      SizedBox(
                        width: Get.width * 0.26,
                        child: const Text('Received'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController.tab_controller,
                    children: [
                      PostedErrands(ctx),
                      RecievedErrands(ctx),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Widget Trashed(BuildContext ctx) {
  return Column(
    children: [
      filter_sort_container(
        () {
          Get.to(filter_product_view());
        },
        () {
          Get.bottomSheet(
            Container(
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Text(
                    'Sort List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: appcolor().mainColor,
                    ),
                  ),
                  // z-a
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Service Name : ',
                              style: TextStyle(
                                color: appcolor().mainColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Desc Z-A',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Radio(
                          value: 'sort descending',
                          groupValue: service_controller
                              .manage_service_sort_group_value.value,
                          onChanged: (val) {
                            service_controller.manage_service_sort_group_value
                                .value = val.toString();
                          },
                        ),
                      )
                    ],
                  ),

                  // a-z
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Service Name : ',
                              style: TextStyle(
                                color: appcolor().mainColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Asc A-Z',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Radio(
                          value: 'sort ascending',
                          groupValue: service_controller
                              .manage_service_sort_group_value.value,
                          onChanged: (val) {
                            service_controller.manage_service_sort_group_value
                                .value = val.toString();
                          },
                        ),
                      ),
                    ],
                  ),

                  // distance nearest to me
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: 16),
                              children: [
                            TextSpan(
                              text: 'Date',
                              style: TextStyle(
                                color: appcolor().mainColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Last Modified',
                            ),
                          ])),
                      Spacer(),
                      Obx(() => Radio(
                            value: 'Date Last modified ',
                            groupValue: service_controller
                                .manage_service_sort_group_value.value,
                            onChanged: (val) {
                              service_controller.manage_service_sort_group_value
                                  .value = val.toString();
                            },
                          ))
                    ],
                  ),

                  //recentaly added
                  Row(
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                            color: appcolor().mainColor, fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_upward,
                        size: 25,
                        color: appcolor().mediumGreyColor,
                      ),
                      Spacer(),
                      Obx(
                        () => Radio(
                          value: 'Price',
                          groupValue: service_controller
                              .manage_service_sort_group_value.value,
                          onChanged: (val) {
                            service_controller.manage_service_sort_group_value
                                .value = val.toString();
                            print(val.toString());
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ).paddingSymmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
          );
        },
        () {
          Scaffold.of(ctx).openEndDrawer();
        },
      ),
      SizedBox(
        height: Get.height * 0.01,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(
                10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image container
                  Container(
                    margin: EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                    width: Get.width * 0.14,
                    height: Get.height * 0.06,
                    child: Image(
                      image: AssetImage(
                        'assets/images/hair_cut.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 0.45,
                        child: Text(
                          'I need a Dell Laptop',
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: appcolor().mainColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'posted on :',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '02 Apr 2023',
                              style: TextStyle(
                                color: appcolor().mainColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 2),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'By',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '  Dr.Pearline Commins',
                              style: TextStyle(
                                color: appcolor().mainColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(
                        top: 2,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: appcolor().lightgreyColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Molyko-Buea',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 12,
                            color: appcolor().mediumGreyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      print(index.toString());
                      Get.bottomSheet(
                        // backgroundColor: Colors.white,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.horizontal_rule,
                                  size: 25,
                                ),
                              ),
                              // Text(index.toString()),
                              managebottomSheetWidgetitem(
                                title: 'Edit Errand',
                                icondata: Icons.edit,
                                callback: () async {
                                  print('tapped');
                                  Get.back();
                                },
                              ),
                              managebottomSheetWidgetitem(
                                title: 'Post Errand',
                                icondata: FontAwesomeIcons.shareFromSquare,
                                callback: () {
                                  Get.back();
                                },
                              ),

                              managebottomSheetWidgetitem(
                                title: 'Delete Permanently',
                                icondata: Icons.delete,
                                callback: () {},
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),

                        enableDrag: true,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'View',
                          style: TextStyle(
                              fontSize: 13,
                              color: appcolor().mediumGreyColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: appcolor().greyColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            color: appcolor().greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
    ],
  ).paddingOnly(
    left: 10,
    right: 10,
    top: 10,
  );
}

Widget filter_sort_container(
  Callback filter_button,
  Callback sort_button,
  Callback search_button,
) {
  return Container(
    // width: Get.width*0.4,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: filter_button,
          child: Container(
            width: Get.width * 0.35,
            decoration: BoxDecoration(
                border: Border.all(color: appcolor().greyColor),
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Filter List',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Icon(
                  FontAwesomeIcons.arrowDownWideShort,
                  color: appcolor().mediumGreyColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: sort_button,
          child: Container(
            width: Get.width * 0.35,
            decoration: BoxDecoration(
                border: Border.all(color: appcolor().greyColor),
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Sort List ',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Icon(
                  FontAwesomeIcons.arrowDownWideShort,
                  color: appcolor().mediumGreyColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: search_button,
          child: Container(
            // width: Get.width*0.4,

            decoration: BoxDecoration(
              border: Border.all(color: appcolor().greyColor),
              borderRadius: BorderRadius.circular(
                10,
              ),
              color: appcolor().skyblueColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.search,
                  color: appcolor().mainColor,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
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

// status

// found 2,
// pending 1,
// cancelled 0,
Widget found_pending_cancel(int index, int status) {
  String s = 'found';
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
