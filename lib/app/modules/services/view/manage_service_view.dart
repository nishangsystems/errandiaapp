import 'dart:convert';

import 'package:errandia/app/APi/product.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/global/Widgets/filter_product_view.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/Widgets/row_item_widget.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/services/controller/manage_service_controller.dart';
import 'package:errandia/app/modules/services/view/add_service_view.dart';
import 'package:errandia/app/modules/services/view/edit_service_view.dart';
import 'package:errandia/app/modules/services/view/service_details_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../global/Widgets/blockButton.dart';
import '../../global/constants/color.dart';

class manage_service_view extends StatefulWidget {
  manage_service_view({super.key});

  @override
  State<manage_service_view> createState() => _manage_service_viewState();
}

class _manage_service_viewState extends State<manage_service_view> with WidgetsBindingObserver {
  manage_service_tab_controller tabController =
      Get.put(manage_service_tab_controller());
  manage_service_controller service_controller = Get.put(manage_service_controller());

  late profile_controller profileController;
  late ScrollController scrollController;
  late PopupBox popup;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late business_controller businessController;
  late home_controller homeController;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    profileController = Get.put(profile_controller());
    businessController = Get.put(business_controller());
    homeController = Get.put(home_controller());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileController.loadMyServices();
    });

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        profileController.loadMyServices();
      }
    });

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      profileController.reloadMyServices();
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget allServices(BuildContext ctx) {
      return Obx(
              () {
            if (profileController.isServiceLoading.isTrue) {
              return Center(
                child: buildLoadingWidget(),
              );
            } else if (profileController.isServiceError.value) {
              return Center(
                child: buildErrorWidget(
                  message: 'An error occurred while fetching services',
                  callback: () {
                    profileController.reloadMyServices();
                  },
                ),
              );
            } else if (profileController.serviceItemList.isEmpty) {
              return Center(
                child: Text(
                  'No Services found',
                  style: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      key: const PageStorageKey('allMyServices'),
                      controller: scrollController,
                      itemCount: profileController.serviceItemList.length,
                      itemBuilder: (context, index) {
                        var data = profileController.serviceItemList[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => ServiceDetailsView(service: data),
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 500),
                            );
                          },

                          child: RowItemWidget(
                            name: data['name'],
                            price: data['unit_price'].toString(),
                            image: data['featured_image'],
                            index: index,
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
                                      managebottomSheetWidgetitem(
                                        title: 'Edit Service',
                                        icondata: Icons.edit,
                                        callback: () async {
                                          print('tapped');
                                          Get.back();
                                          Get.to(() => EditServiceView(data: data));
                                        },
                                      ),
                                      // managebottomSheetWidgetitem(
                                      //   title: 'Edit Photo',
                                      //   icondata: FontAwesomeIcons.fileImage,
                                      //   callback: () {
                                      //     Get.back();
                                      //   },
                                      // ),
                                      // managebottomSheetWidgetitem(
                                      //   title: 'UnPublish Product',
                                      //   icondata: FontAwesomeIcons.minusCircle,
                                      //   callback: () {},
                                      // ),
                                      managebottomSheetWidgetitem(
                                        title: 'Move to trash',
                                        icondata: Icons.delete,
                                        callback: () {
                                          Get.back();

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext dialogContext) {
                                              // Use dialogContext
                                              var response;
                                              return CustomAlertDialog(
                                                  title: "Delete Service",
                                                  message: "Are you sure you want to delete this service?",
                                                  dialogType: MyDialogType.error,
                                                  onConfirm: () {
                                                    // delete product
                                                    print("delete product: ${data['slug']}");
                                                    ProductAPI.deleteProductOrService(data['slug'])
                                                        .then((response_) {
                                                      if (response_ != null) {
                                                        response = jsonDecode(response_);
                                                        print("delete service response: $response");

                                                        if (mounted) {
                                                          // Check if the widget is still in the tree
                                                          if (response["status"] == 'success') {
                                                            Navigator.of(dialogContext)
                                                                .pop(); // Close the dialog

                                                            // Show success popup
                                                            popup = PopupBox(
                                                              title: 'Success',
                                                              description: response['data']['message'],
                                                              type: PopupType.success,
                                                            );
                                                          } else {
                                                            Navigator.of(dialogContext)
                                                                .pop(); // Close the dialog

                                                            // Show error popup
                                                            popup = PopupBox(
                                                              title: 'Error',
                                                              description: response['data']['data'],
                                                              type: PopupType.error,
                                                            );
                                                          }

                                                          popup.showPopup(context); // Show the popup
                                                        }
                                                      }
                                                    });
                                                  },
                                                  onCancel: () {
                                                    // cancel delete
                                                    print("cancel delete");
                                                    Navigator.of(dialogContext).pop(); // Close the dialog
                                                  });
                                            },
                                          ).then((_) {
                                            if (mounted) {
                                              try {
                                                popup.dismissPopup(
                                                    navigatorKey.currentContext!); // Dismiss the popup
                                              } catch (e) {
                                                print("error dismissing popup: $e");
                                              }
                                              profileController.reloadMyServices();
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
                          )
                        );
                      },
                    ),
                  )
                ],
              );
            }
          }
      );
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
              itemCount: 3,
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
                          Row(
                            children: [
                              Text(
                                'XAF 20',
                                style: TextStyle(
                                  color: appcolor().mediumGreyColor,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              // trashed container
                              // Container(
                              //   padding: EdgeInsets.symmetric(
                              //     horizontal: 5,
                              //     vertical: 2,
                              //   ),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //     color: appcolor().redColor,
                              //   ),
                              //   child: Text(
                              //     'Trash',
                              //     style: TextStyle(
                              //       fontSize: 12,
                              //       color: Colors.red,
                              //     ),
                              //   ),
                              // ),
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
                                    title: 'Move to Publish',
                                    icondata: Icons.move_up_outlined,
                                    callback: () async {
                                      print('tapped');
                                      Get.back();
                                    },
                                  ),
                                  managebottomSheetWidgetitem(
                                    title: 'Move to Draft',
                                    icondata: Icons.move_down_outlined,
                                    callback: () {
                                      Get.back();
                                    },
                                  ),

                                  managebottomSheetWidgetitem(
                                    title: 'Delete Product Permanently',
                                    icondata: Icons.delete,
                                    callback: () {
                                      Get.back();
                                    },
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
                              'Edit',
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

    Widget Drafts(BuildContext ctx) {
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
              itemCount: 0,
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
                          Row(
                            children: [
                              Text(
                                'XAF 20',
                                style: TextStyle(
                                  color: appcolor().mediumGreyColor,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              // publish_draft_widget(false, index),
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
                                    title: 'Move to Publish',
                                    icondata: Icons.move_up_outlined,
                                    callback: () async {
                                      print('tapped');
                                      Get.back();
                                    },
                                  ),
                                  managebottomSheetWidgetitem(
                                    title: 'Move to Trash',
                                    icondata: Icons.move_down_outlined,
                                    callback: () {
                                      Get.back();
                                    },
                                  ),

                                  managebottomSheetWidgetitem(
                                    title: 'Delete Product Permanently',
                                    icondata: Icons.delete,
                                    callback: () {
                                      Get.back();
                                    },
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
                              'Edit',
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
          ),
        ],
      ).paddingOnly(
        left: 10,
        right: 10,
        top: 10,
      );
    }

    Widget Published(BuildContext ctx) {
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
              itemCount: 0,
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
                          Row(
                            children: [
                              Text(
                                'XAF 20',
                                style: TextStyle(
                                  color: appcolor().mediumGreyColor,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              // publish_draft_widget(true, 0),
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
                                    title: 'Move to Draft',
                                    icondata: Icons.move_up_outlined,
                                    callback: () async {
                                      print('tapped');
                                      Get.back();
                                    },
                                  ),
                                  managebottomSheetWidgetitem(
                                    title: 'Move to Trash',
                                    icondata: Icons.move_down_outlined,
                                    callback: () {
                                      Get.back();
                                    },
                                  ),

                                  managebottomSheetWidgetitem(
                                    title: 'Delete Product Permanently',
                                    icondata: Icons.delete,
                                    callback: () {
                                      Get.back();
                                    },
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
                              'Edit',
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

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => add_service_view());
            },
            backgroundColor: Colors.orange,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
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
            backgroundColor: Colors.orange,
            elevation: 2,
            leading: IconButton(
              icon: const  Icon(
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
              'Manage Services',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            ),
            iconTheme: const IconThemeData(
              color: Colors.black,
              size: 30,
            ),
          ),
          body: allServices(context),
      )
    );
  }
}

Widget filter_sort_container(
  Callback filterButton,
  Callback sortButton,
  Callback searchButton,
) {
  return Container(
    // width: Get.width*0.4,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: filterButton,
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
          onTap: sortButton,
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
          onTap: searchButton,
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

Widget publish_draft_widget(bool publish, int index) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 2,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: publish == true
          ? const Color.fromARGB(255, 218, 246, 187)
          : appcolor().greyColor,
    ),
    child: Text(
      publish == true ? 'Publish' : 'Draft',
      style: TextStyle(
        fontSize: 12,
        color: publish == true ? Colors.green : Colors.grey,
      ),
    ),
  );
}
