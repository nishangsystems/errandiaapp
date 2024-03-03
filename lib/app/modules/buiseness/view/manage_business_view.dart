import 'dart:convert';

import 'package:errandia/app/APi/business.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/view/add_business_view.dart';
import 'package:errandia/app/modules/buiseness/view/edit_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/Widgets/business_item.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/products/view/add_product_view.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/services/view/add_service_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/Widgets/blockButton.dart';
import '../../global/Widgets/bottomsheet_item.dart';
import '../../global/Widgets/customDrawer.dart';
import '../../global/constants/color.dart';

enum BusinessAction { suspend, reinstate, delete }

class manage_business_view extends StatefulWidget {
  manage_business_view({super.key});

  @override
  State<manage_business_view> createState() => _manage_business_viewState();
}

class _manage_business_viewState extends State<manage_business_view>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final manage_business_tabController mController =
      Get.put(manage_business_tabController());
  late profile_controller profileController;
  late ScrollController scrollController;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late PopupBox popup;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    profileController = Get.put(profile_controller());
    mController.tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.loadMyBusinesses();
    });

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        profileController.loadMyBusinesses();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      profileController.reloadMyBusinesses();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget allBusiness() {
      return Expanded(child: Obx(() {
        if (profileController.isLoading.isTrue) {
          return buildLoadingWidget();
        } else if (profileController.isError.isTrue) {
          return buildErrorWidget(
            message: 'An error occurred',
            callback: () {
              profileController.reloadMyBusinesses();
            },
          );
        } else if (profileController.itemList.isEmpty) {
          return SizedBox(
            height: Get.height * 0.5,
            child: Center(
              child: Text(
                'No Business found',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        } else {
          return ListView.builder(
            key: const PageStorageKey('allMyBusinesses'),
            controller: scrollController,
            itemCount: profileController.itemList.length,
            itemBuilder: (context, index) {
              var data = profileController.itemList[index];
              if (kDebugMode) {
                print("manage business : $data");
              }
              return BusinessItem(
                name: data['name'],
                address: data['address'],
                image: data['image'],
                onTap: () {
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
                          bottomSheetWidgetitem(
                            title: 'Edit Business',
                            imagepath:
                                'assets/images/sidebar_icon/icon-edit.png',
                            callback: () async {
                              print('tapped');
                              Get.back();
                              Get.to(() => EditBusinessView(
                                    data: data,
                                  ));
                            },
                          ),
                          bottomSheetWidgetitem(
                            title: 'Add New Product',
                            imagepath:
                                'assets/images/sidebar_icon/add_products.png',
                            callback: () async {
                              print('add new product');
                              Get.back();
                              Get.to(() => add_product_view());
                            },
                          ),
                          bottomSheetWidgetitem(
                            title: 'Add New Service',
                            imagepath:
                                'assets/images/sidebar_icon/services.png',
                            callback: () async {
                              print('add new service');
                              Get.back();
                              Get.to(() => add_service_view());
                            },
                          ),
                          bottomSheetWidgetitem(
                            title: 'Suspend Business',
                            imagepath:
                                'assets/images/sidebar_icon/icon-suspend.png',
                            callback: () {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return businessDialog(BusinessAction.suspend);
                                },
                              );
                            },
                          ),
                          bottomSheetWidgetitem(
                            title: 'Update Location',
                            imagepath:
                                'assets/images/sidebar_icon/icon-location.png',
                            callback: () {},
                          ),
                          bottomSheetWidgetitem(
                            title: 'Move to trash',
                            imagepath:
                                'assets/images/sidebar_icon/icon-trash.png',
                            callback: () {
                              Get.back();

                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  // Use dialogContext
                                  var response;
                                  return CustomAlertDialog(
                                      title: "Delete Business",
                                      message:
                                          "Are you sure you want to delete this business?",
                                      dialogType: MyDialogType.error,
                                      onConfirm: () {
                                        // delete product
                                        print(
                                            "delete business: ${data['slug']}");
                                        BusinessAPI.deleteBusiness(data['slug'])
                                            .then((response_) {
                                          if (response_ != null) {
                                            response = jsonDecode(response_);
                                            print(
                                                "delete business response: $response");

                                            if (mounted) {
                                              // Check if the widget is still in the tree
                                              if (response["status"] ==
                                                  'success') {
                                                profileController
                                                    .reloadMyProducts();
                                                profileController
                                                    .reloadMyServices();

                                                Navigator.of(dialogContext)
                                                    .pop(); // Close the dialog

                                                // Show success popup
                                                popup = PopupBox(
                                                  title: 'Success',
                                                  description: response['data']
                                                      ['message'],
                                                  type: PopupType.success,
                                                );
                                              } else {
                                                Navigator.of(dialogContext)
                                                    .pop(); // Close the dialog

                                                // Show error popup
                                                popup = PopupBox(
                                                  title: 'Error',
                                                  description: response['data']
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
                                  profileController.reloadMyBusinesses();
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
              );
            },
          );
        }
      }));
    }

    mController.myTabs = <Widget>[
      allBusiness(),
      Published(),
      Trashed(),
    ];

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        floatingActionButton: InkWell(
          onTap: () {
            Get.to(() => add_business_view());
          },
          child: Container(
            width: Get.width * 0.47,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: appcolor().skyblueColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: appcolor().mainColor,
                  size: 28,
                ),
                Spacer(),
                Text(
                  'Add Business',
                  style: TextStyle(fontSize: 16, color: appcolor().mainColor),
                ),
              ],
            ),
          ),
        ),
        endDrawer: CustomEndDrawer(
          onBusinessCreated: () {
            home_controller().closeDrawer();
            home_controller().featuredBusinessData.clear();
            home_controller().fetchFeaturedBusinessesData();
            business_controller().itemList.clear();
            business_controller().loadBusinesses();
            home_controller().recentlyPostedItemsData.clear();
            home_controller().fetchRecentlyPostedItemsData();
            profile_controller().itemList.clear();
            profile_controller().loadMyBusinesses();
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
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
            'Manage Business',
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          iconTheme: IconThemeData(
            color: appcolor().mediumGreyColor,
            size: 30,
          ),
        ),
        body: Column(
          children: [
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
                dividerColor: appcolor().bluetextcolor,
                isScrollable: true,
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
                controller: mController.tabController,
                tabs: [
                  Container(
                    height: Get.height * 0.05,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text('All Businesses'),
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                    width: Get.width * 0.26,
                    child: const Text('Published'),
                  ),
                  SizedBox(
                      height: Get.height * 0.05, child: const Text('Trashed')),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: mController.tabController,
                children: mController.myTabs,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getActionText(BusinessAction action) {
  switch (action) {
    case BusinessAction.suspend:
      return 'Suspend Business';
    case BusinessAction.reinstate:
      return 'Reinstate Business';
    case BusinessAction.delete:
      return 'Delete Business';
  }
}

String getActionPrompt(BusinessAction action) {
  switch (action) {
    case BusinessAction.suspend:
      return 'Are you sure you want to suspend this Business ?';
    case BusinessAction.reinstate:
      return 'Are you sure you want to Reinstate this Business ?';
    case BusinessAction.delete:
      return 'Are you sure you want to Delete this Business ?';
  }
}

// get action button color
Color getActionButtonColor(BusinessAction action) {
  switch (action) {
    case BusinessAction.suspend:
      return const Color.fromARGB(255, 225, 146, 20);
    case BusinessAction.reinstate:
      return appcolor().mainColor;
    case BusinessAction.delete:
      return appcolor().redColor;
  }
}

Widget businessDialog(BusinessAction action) {
  return AlertDialog(
    insetPadding: const EdgeInsets.symmetric(
      horizontal: 10,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getActionText(action),
            style: TextStyle(
              color: appcolor().mainColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Text(
              getActionPrompt(action),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  right: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                width: Get.width * 0.16,
                height: Get.height * 0.06,
                child: const Image(
                  image: AssetImage(
                    'assets/images/barber_logo.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rubiliams Hair Clinic',
                    style: TextStyle(
                      color: appcolor().mainColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Molyko, Buea',
                    style: TextStyle(
                      color: appcolor().mediumGreyColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: Get.height * 0.12,
          ),
          Column(
            children: [
              blockButton(
                title: Text(
                  getActionText(action),
                  style: const TextStyle(color: Colors.white),
                ),
                ontap: () {
                  Get.back();
                },
                color: getActionButtonColor(action),
              ),
              SizedBox(
                height: Get.height * 0.015,
              ),
              blockButton(
                title: Text(
                  'Cancel',
                  style: TextStyle(color: appcolor().mediumGreyColor),
                ),
                ontap: () {
                  Get.back();
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
}

Widget Published() {
  return Column(
    children: [
      filter_sort_container(),
      SizedBox(
        height: Get.height * 0.01,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
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
                    width: Get.width * 0.16,
                    height: Get.height * 0.06,
                    child: Image(
                      image: AssetImage(
                        'assets/images/barber_logo.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rubiliams Hair Clinic',
                        style: TextStyle(
                          color: appcolor().mainColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Molyko, Buea',
                        style: TextStyle(
                          color: appcolor().mediumGreyColor,
                          fontSize: 13,
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
                          // height: 250,
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
                              bottomSheetWidgetitem(
                                title: 'Edit Business',
                                imagepath:
                                    'assets/images/sidebar_icon/icon-edit.png',
                                callback: () async {
                                  print('tapped');
                                  Get.back();
                                },
                              ),
                              bottomSheetWidgetitem(
                                title: 'Reinstate Business',
                                imagepath:
                                    'assets/images/sidebar_icon/icon-reinstate.png',
                                callback: () {
                                  Get.back();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        insetPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
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
                                                'Reinstate Business',
                                                style: TextStyle(
                                                  color: appcolor().mainColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 15,
                                                ),
                                                child: Text(
                                                  'Are you sure you want to Reinstate this Business ?',
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.02,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      right: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8,
                                                      ),
                                                    ),
                                                    width: Get.width * 0.16,
                                                    height: Get.height * 0.06,
                                                    child: Image(
                                                      image: AssetImage(
                                                        'assets/images/barber_logo.png',
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Rubiliams Hair Clinic',
                                                        style: TextStyle(
                                                          color: appcolor()
                                                              .mainColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Molyko, Buea',
                                                        style: TextStyle(
                                                          color: appcolor()
                                                              .mediumGreyColor,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.12,
                                              ),
                                              Column(
                                                children: [
                                                  blockButton(
                                                    title: Text(
                                                      'Reinstate Business',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    ontap: () {
                                                      Get.back();
                                                    },
                                                    color: appcolor().mainColor,
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.015,
                                                  ),
                                                  blockButton(
                                                    title: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: appcolor()
                                                            .mainColor,
                                                      ),
                                                    ),
                                                    ontap: () {
                                                      Get.back();
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
                              ),

                              bottomSheetWidgetitem(
                                title: 'Move to trash',
                                imagepath:
                                    'assets/images/sidebar_icon/icon-trash.png',
                                callback: () {},
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
                          'MANAGE',
                          style: TextStyle(
                              color: appcolor().bluetextcolor,
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

Widget Trashed() {
  return Column(
    children: [
      filter_sort_container(),
      SizedBox(
        height: Get.height * 0.01,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
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
                    width: Get.width * 0.16,
                    height: Get.height * 0.06,
                    child: Image(
                      image: AssetImage(
                        'assets/images/barber_logo.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rubiliams Hair Clinic',
                        style: TextStyle(
                          color: appcolor().mainColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Molyko, Buea',
                        style: TextStyle(
                          color: appcolor().mediumGreyColor,
                          fontSize: 13,
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
                              bottomSheetWidgetitem(
                                title: 'Move to Published',
                                imagepath:
                                    'assets/images/sidebar_icon/icon-move.png',
                                callback: () async {
                                  print('tapped');
                                  Get.back();
                                },
                              ),
                              // bottomSheetWidgetitem(

                              //   title: 'Delete Business Permanently',
                              //   imagepath:
                              //       'assets/images/sidebar_icon/icon-reinstate.png',
                              //   callback: () {},
                              // ),
                              InkWell(
                                // highlightColor: Colors.grey,

                                hoverColor: Colors.grey,
                                // focusColor: Colors.grey,
                                // splashColor: Colors.grey,
                                // overlayColor: Colors.grey,
                                onTap: () {
                                  Get.back();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 20,
                                        ),
                                        scrollable: true,
                                        content: SizedBox(
                                          // height: Get.height * 0.7,
                                          width: Get.width,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Delete Business',
                                                style: TextStyle(
                                                  color: appcolor().mainColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                ),
                                                child: const Text(
                                                  'Are you sure you want to Delete this Business ?',
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.02,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      right: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8,
                                                      ),
                                                    ),
                                                    width: Get.width * 0.16,
                                                    height: Get.height * 0.06,
                                                    child: const Image(
                                                      image: AssetImage(
                                                        'assets/images/barber_logo.png',
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Rubiliams Hair Clinic',
                                                        style: TextStyle(
                                                          color: appcolor()
                                                              .mainColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Molyko, Buea',
                                                        style: TextStyle(
                                                          color: appcolor()
                                                              .mediumGreyColor,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.12,
                                              ),
                                              Column(
                                                children: [
                                                  blockButton(
                                                    title: const Text(
                                                      'Delete Business',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    ontap: () {
                                                      Get.back();
                                                    },
                                                    color: appcolor().redColor,
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.015,
                                                  ),
                                                  blockButton(
                                                    title: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: appcolor()
                                                            .mainColor,
                                                      ),
                                                    ),
                                                    ontap: () {
                                                      Get.back();
                                                    },
                                                    color:
                                                        const Color(0xfffafafa),
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
                                child: Row(
                                  children: [
                                    Container(
                                      height: 24,
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/sidebar_icon/icon-trash.png',
                                        ),
                                        color: appcolor().redColor,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Text(
                                      'Delete Business Permanently',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: appcolor().redColor),
                                    ),
                                  ],
                                ).paddingSymmetric(vertical: 15),
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
                          'MANAGE',
                          style: TextStyle(
                              color: appcolor().bluetextcolor,
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

Widget filter_sort_container() {
  return Container(
    // width: Get.width*0.4,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {},
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
                  'Filter Lis',
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
          onTap: () {},
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
          onTap: () {},
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
