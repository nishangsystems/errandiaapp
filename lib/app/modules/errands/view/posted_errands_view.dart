import 'dart:convert';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/errands/view/New_Errand.dart';
import 'package:errandia/app/modules/errands/view/edit_errand.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/errands/view/errand_results.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class PostedErrandsView extends StatefulWidget {
  const PostedErrandsView({Key? key}) : super(key: key);

  @override
  _PostedErrandsViewState createState() => _PostedErrandsViewState();
}

class _PostedErrandsViewState extends State<PostedErrandsView>
    with WidgetsBindingObserver {
  late errand_tab_controller tabController;
  late home_controller homeController;
  late errand_controller errandController;
  late ScrollController _scrollController;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late PopupBox popup;
  late business_controller businessController;
  late profile_controller profileController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scrollController = ScrollController();
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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        errandController.fetchMyErrands();
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

  void markErrandFound(BuildContext context, data) async {
    await ErrandsAPI.markErrandAsFound(data['id'].toString()).then((response_) {
      var response = jsonDecode(response_);

      if (response['status'] == "success") {
        print("response mark errand: $response");
        errandController.reloadMyErrands();
        errandController.reloadReceivedErrands();
        Get.back();
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
      }
    }).catchError((e) {
      print("error marking errand as found: $e");
      Get.back();
      Get.snackbar("Error", "An error occurred",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
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
          return RefreshIndicator(
            onRefresh: () async {
              errandController.reloadMyErrands();
            },
            child: ListView.builder(
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
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
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
                                'Posted on: ',
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
                              if (data_['status'] == 1)
                                found_pending_cancel(index, 3),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                          duration: const Duration(
                                              milliseconds: 500));
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
                                  managebottomSheetWidgetitem(
                                    title: 'Mark as found',
                                    icondata: FontAwesomeIcons.circleCheck,
                                    callback: () {
                                      markErrandFound(context, data_);
                                    },
                                  ),

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
                                                          type:
                                                              PopupType.success,
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
            ),
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
            backgroundColor: Colors.blue[700],
            child: Icon(
              Icons.add,
              color: appcolor().skyblueColor,
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      }),
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
          'Posted Errands',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
      ),
      body: PostedErrands(context),
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
