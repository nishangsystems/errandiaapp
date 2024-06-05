import 'dart:convert';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/APi/business.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/controller/errandia_business_view_controller.dart';
import 'package:errandia/app/modules/buiseness/featured_buiseness/view/featured_list_item.dart';
import 'package:errandia/app/modules/buiseness/view/edit_business_view.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/errands/view/see_all_errands.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/errand_widget_card.dart';
import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:errandia/app/modules/global/Widgets/items_list_widget.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/products/controller/product_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/services/view/service_details_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../products/view/product_view.dart';
import '../../recently_posted_item.dart/view/recently_posted_list.dart';

class VisitShop extends StatefulWidget {
  late Map<String, dynamic> businessData;

  VisitShop({super.key, required this.businessData});

  @override
  State<VisitShop> createState() => _VisitShopState();
}

class _VisitShopState extends State<VisitShop> with WidgetsBindingObserver {
  final business_controller controller = Get.put(business_controller());
  late profile_controller profileController;
  final home_controller homeController = Get.put(home_controller());
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late ProductController productController;
  late ErrandiaBusinessViewController errBController;

  late PopupBox popup;

  bool sendingOTPLoading = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBindingObserver.
    profileController = Get.put(profile_controller());
    productController = Get.put(ProductController());
    errBController = Get.put(ErrandiaBusinessViewController());
    profileController.getUser();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.loadShopProducts(widget.businessData['slug']);
      productController.loadShopServices(widget.businessData['slug']);
      errBController.loadBusinesses(widget.businessData['slug']);
    });

    print("userData: ${profileController.userData}");
  }

  void showPopupMenu(BuildContext context) {
    var userIsOwner = profileController.userData.value['id'] ==
        widget.businessData['user']['id'];
    List<PopupMenuEntry<String>> menuItems = userIsOwner
        ? [
            // const PopupMenuItem<String>(
            //     value: 'share',
            //     child: Row(
            //       children: [
            //         Icon(Icons.share, size: 14, color: Colors.black),
            //         SizedBox(
            //           width: 5,
            //         ),
            //         Text('Share', style: TextStyle(fontSize: 15)),
            //       ],
            //     )),
            const PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 14, color: Colors.black),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Edit', style: TextStyle(fontSize: 15)),
                  ],
                )),
            const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 14, color: Colors.black),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Delete', style: TextStyle(fontSize: 15)),
                  ],
                )),
          ]
        : [
            // const PopupMenuItem<String>(value: 'share', child: Text('Share')),
          ];

    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
      // Position the menu
      items: menuItems,
      initialValue: null,
    ).then((String? value) {
      // Handle the action based on the value
      if (value != null) {
        switch (value) {
          case 'edit':
            Get.to(() => EditBusinessView(data: widget.businessData))
                ?.then((value) {
              print("value update: $value");
              if (value != null) {
                setState(() {
                  widget.businessData = value;
                });
              }
            });
            break;
          case 'delete':
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                // Use dialogContext
                var response;
                return CustomAlertDialog(
                    title: "Delete Business",
                    message: "Are you sure you want to delete this business?",
                    dialogType: MyDialogType.error,
                    onConfirm: () {
                      // delete product
                      print("delete business: ${widget.businessData['slug']}");
                      BusinessAPI.deleteBusiness(widget.businessData['slug'])
                          .then((response_) {
                        if (response_ != null) {
                          response = jsonDecode(response_);
                          print("delete business response: $response");

                          if (mounted) {
                            // Check if the widget is still in the tree
                            if (response["status"] == 'success') {
                              profileController.reloadMyProducts();
                              profileController.reloadMyServices();

                              Navigator.of(dialogContext)
                                  .pop(); // Close the dialog
                              Navigator.of(context)
                                  .pop(true); // Navigate back with result

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
                profileController.reloadMyBusinesses();
                Get.back();
              }
            });
            break;
          // case 'share':
          //   // Handle share action
          //   break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("businessData: ${widget.businessData['slug']}");
    }

    Widget _buildRPIErrorWidget(String message, VoidCallback onReload) {
      return !homeController.isRPILoading.value
          ? Container(
              height: Get.height * 0.3,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message),
                    ElevatedButton(
                      onPressed: onReload,
                      style: ElevatedButton.styleFrom(
                        primary: appcolor().mainColor,
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyle(color: appcolor().lightgreyColor),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : buildLoadingWidget();
    }

    Widget Related_Businesses_List() {
      return Obx(() {
        if (errBController.isBranchesLoading.value) {
          print("loading related businesses");
          return Container(
            height: Get.height * 0.3,
            color: Colors.white,
            child: buildLoadingWidget(),
          );
        } else if (errBController.branchesList.isEmpty) {
          return Container(
            height: Get.height * 0.3,
            color: Colors.white,
            child: Center(
              child: Text(
                'No related businesses found',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontSize: 15,
                ),
              ),
            ),
          );
        } else {
          print("related businesses: ${errBController.branchesList}");
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: Get.height * 0.31,
            color: Colors.white,
            child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: errBController.branchesList.length > 6
                  ? 6
                  : errBController.branchesList.length,
              itemBuilder: (context, index) {
                var data = errBController.branchesList[index];
                print("sub data: ${data['street']}");
                return InkWell(
                  onTap: () {
                    Get.to(() => errandia_business_view(businessData: data));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: Get.width * 0.4,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.005,
                        ),
                        Container(
                          height: Get.height * 0.15,
                          width: Get.width,
                          color: appcolor().lightgreyColor,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/errandia_logo.png',
                            image: getImagePath(data['image'].toString()),
                            fit: BoxFit.contain,
                            width: double.infinity,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/errandia_logo.png',
                                // Your fallback image
                                fit: BoxFit.contain,
                                width: double.infinity,
                              );
                            },
                          ),
                        ).paddingOnly(left: 3, right: 3, top: 10, bottom: 5),
                        SizedBox(
                          height: Get.height * 0.009,
                        ),
                        SizedBox(
                            width: Get.width * 0.35,
                            child: Text(
                              data['category']['name'].toString(),
                              style: TextStyle(
                                  fontSize: 11,
                                  // fontWeight: FontWeight.bold,
                                  color: appcolor().mediumGreyColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ).paddingOnly(left: 3)),
                        SizedBox(
                          height: Get.height * 0.001,
                        ),
                        Text(
                          capitalizeAll(data['name'] ?? ""),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: appcolor().mainColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).paddingOnly(left: 3),
                        SizedBox(
                          height: Get.height * 0.001,
                        ),
                        (data['street'] != '' && data['street'] != null)
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: appcolor().mediumGreyColor,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 1,
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.35,
                                    child: Text(
                                      data['street'].toString(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: appcolor().mediumGreyColor,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "No location provided",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: appcolor().mediumGreyColor,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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

    Widget Service_item_list() {
      return Obx(() {
        if (productController.isShopServicesLoading.value) {
          return Container(
            height: Get.height * 0.3,
            color: Colors.white,
            child: buildLoadingWidget(),
          );
        } else if (productController.shopServiceList.isEmpty) {
          return Container(
            height: Get.height * 0.3,
            color: Colors.white,
            child: Center(
              child: Text(
                'No services found',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontSize: 15,
                ),
              ),
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: Get.height * 0.3,
            color: Colors.white,
            child: ListView.builder(
              itemCount: productController.shopServiceList.length,
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = productController.shopServiceList[index];
                return GestureDetector(
                  onTap: () {
                    if (kDebugMode) {
                      print("service item: ${item['name']}");
                    }
                    Get.to(() => ServiceDetailsView(service: item));
                  },
                  child: errandia_widget(
                    cost: item['unit_price'].toString(),
                    imagePath: item['featured_image'],
                    name: item['name'],
                    location:
                        item['shop'] != null ? item['shop']['street'] : "",
                  ),
                );
              },
            ),
          );
        }
      });
    }

    Widget product_item_list() {
      return Obx(() {
        if (productController.isShopProductsLoading.value) {
          return Container(
            height: Get.height * 0.3,
            color: Colors.white,
            child: buildLoadingWidget(),
          );
        } else if (productController.shopProductList.isEmpty) {
          return Container(
            height: Get.height * 0.3,
            color: Colors.white,
            child: Center(
              child: Text(
                'No products found',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontSize: 15,
                ),
              ),
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: Get.height * 0.3,
            color: Colors.white,
            child: ListView.builder(
              itemCount: productController.shopProductList.length,
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = productController.shopProductList[index];

                return GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print("product item clicked: ${item['name']}");
                      }
                      Get.to(() => Product_view(item: item));
                    },
                    child: errandia_widget(
                      cost: item['unit_price'].toString(),
                      imagePath: item['featured_image'],
                      name: item['name'],
                      location:
                          item['shop'] != null ? item['shop']['street'] : "",
                    ));
              },
            ),
          );
        }
      });
    }

    Widget Recently_posted_items_Widget() {
      return Obx(() {
        if (homeController.isRPIError.value) {
          return _buildRPIErrorWidget('Failed to load recently posted items',
              homeController.reloadRecentlyPostedItems);
        } else if (homeController.isRPILoading.value) {
          return Container(
            height: Get.height * 0.45,
            color: Colors.white,
            child: buildLoadingWidget(),
          );
        } else if (homeController.recentlyPostedItemsData.isEmpty) {
          return Container(
            height: Get.height * 0.45,
            color: Colors.white,
            child: const Center(
              child: Text('No recently posted items'),
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: Get.height * 0.45,
            color: Colors.white,
            child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: homeController.recentlyPostedItemsData.length > 4
                  ? 4
                  : homeController.recentlyPostedItemsData.length,
              itemBuilder: (context, index) {
                var data = homeController.recentlyPostedItemsData[index];

                return InkWell(
                  onTap: () {
                    // Get.to(Product_view(item: data,name: data['name'].toString(),));
                    // Get.back();
                    Get.to(() => errand_detail_view(
                          data: data,
                        ));
                  },
                  child: ErrandWidgetCard(
                    data: data,
                  ),
                );
              },
            ),
          );
        }
      });
    }

    return WillPopScope(
      onWillPop: () async {
        profileController.reloadMyBusinesses();
        profileController.reloadMyProducts();
        profileController.reloadMyServices();
        homeController.reloadFeaturedBusinessesData();
        Get.back();
        return true;
      },
      child: Stack(children: [
        Scaffold(
            appBar:
                titledAppBar(capitalizeAll(widget.businessData['name'] ?? ''), [
              if (profileController.userData.value['id'] ==
                  widget.businessData['user']['id'])
                IconButton(
                  onPressed: () {
                    // Share.share('text', subject: 'hello share');
                    showPopupMenu(context);
                  },
                  // vertical 3 dots
                  icon: const Icon(
                    Icons.more_vert,
                    size: 30,
                  ),
                  color: appcolor().mediumGreyColor,
                ),
            ]),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Products',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: appcolor().mainColor,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            var data = widget.businessData;
                            Get.to(() =>
                                ItemListWidget(data: data, isService: false));
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 20),
                  ),

                  product_item_list(),

                  SizedBox(
                    height: Get.height * 0.03,
                  ),

                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Services',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: appcolor().mainColor,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            var data = widget.businessData;
                            Get.to(() =>
                                ItemListWidget(data: data, isService: true));
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 20),
                  ),

                  Service_item_list(),

                  // Container(
                  //   color: Colors.white,
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'Related Businesses',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.w700,
                  //           fontSize: 18,
                  //           color: appcolor().mainColor,
                  //         ),
                  //       ),
                  //       const Spacer(),
                  //       TextButton(
                  //         onPressed: () {
                  //           Get.to(() => BusinessesViewWithBar());
                  //         },
                  //         child: const Text('See All'),
                  //       ),
                  //     ],
                  //   ).paddingSymmetric(horizontal: 20),
                  // ),
                  //
                  // Related_Businesses_List(),

                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Recently Posted Errands',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: appcolor().mainColor,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const SeeAllErrands());
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 20),
                  ),

                  Recently_posted_items_Widget(),
                ],
              ),
            )),
        if (sendingOTPLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ]),
    );
  }
}

Widget product_review_widget(Map<String, dynamic> data) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          capitalizeAll(data['name'].toString() ?? ''),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        data['street'] != null
            ? Text(
                data['street'],
                style: const TextStyle(),
              )
            : const Text(
                'No street provided',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
        const SizedBox(
          height: 5,
        ),
        // Row(
        //   children: [
        //     Icon(
        //       Icons.person,
        //       size: 18,
        //       color: appcolor().mediumGreyColor,
        //     ),
        //     Text(
        //       '  Member Since 2010',
        //       style: TextStyle(
        //         fontSize: 13,
        //         color: appcolor().mediumGreyColor,
        //       ),
        //     ),
        //     const Spacer(),
        //     RatingBar.builder(
        //       initialRating: 3.5,
        //       allowHalfRating: true,
        //       ignoreGestures: true,
        //       itemSize: 18,
        //       itemBuilder: (context, index) {
        //         return const Icon(
        //           Icons.star_rate_rounded,
        //           color: Colors.amber,
        //         );
        //       },
        //       onRatingUpdate: (val) {},
        //     ),
        //     Text(
        //       '10 Reviews',
        //       style: TextStyle(
        //         fontSize: 11,
        //         color: appcolor().mediumGreyColor,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ],
        // ),
      ]),

      // region and town
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          data['region'] != null || data['region'].toString() != 'null'
              ? Text(
                  data['region']['name'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[800],
                  ),
                )
              : const Text(
                  'No region provided',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
          data['town'] != null || data['town'].toString() != 'null'
              ? Text(
                  data['town']['name'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                )
              : const Text(
                  'No town provided',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
        ],
      ),
    ],
  );
}

// widget businesses list
Widget businesses_item_list() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    height: Get.height * 0.3,
    color: Colors.white,
    child: ListView.builder(
      itemCount: business_controller().businessList.length,
      primary: false,
      shrinkWrap: false,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final item = business_controller().businessList[index];
        return GestureDetector(
          onTap: () {
            if (kDebugMode) {
              print("business item: ${item.name}");
            }
            Get.to(() => VisitShop(businessData: item.toJson()));
          },
          child: business_controller().businessList[index],
        );
      },
    ),
  );
}

// widget recently posted errands
Widget recently_posted_errands() {
  return FutureBuilder(
      future: api().getProduct('products', 1),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            height: Get.height * 0.17,
            color: Colors.white,
            child: const Center(
              child: Text('Recently Posted Errands not found'),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height * 0.17,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: Get.height * 0.45,
            color: Colors.white,
            child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                var data = snapshot.data[index];
                if (kDebugMode) {
                  print("data: $data");
                }

                return InkWell(
                  onTap: () {
                    // Get.to(Product_view(item: data,name: data['name'].toString(),));
                    // Get.back();
                    Get.to(errand_detail_view(
                      data: data,
                    ));
                  },
                  child: Card(
                    child: Container(
                      width: Get.width * 0.5,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * 0.09,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                    data['shop']['image'] != ''
                                        ? data['shop']['image'].toString()
                                        : Recently_item_List[index]
                                            .avatarImage
                                            .toString(),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.02,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data['shop']['name'].toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Text(
                                    //   Recently_item_List[index].date.toString(),
                                    //   style: TextStyle(fontSize: 12),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: appcolor().mediumGreyColor,
                          ),
                          Container(
                            height: Get.height * 0.2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            color: appcolor().lightgreyColor,
                            child: Center(
                              child: Image(
                                image: AssetImage(
                                  Featured_Businesses_Item_List[index]
                                      .imagePath
                                      .toString(),
                                ),
                                height: Get.height * 0.15,
                              ),
                            ),
                          ),
                          Divider(
                            color: appcolor().mediumGreyColor,
                          ),
                          SizedBox(
                            height: Get.height * 0.009,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   Featured_Businesses_Item_List[index]
                                //       .servicetype
                                //       .toString(),
                                //   style: TextStyle(
                                //       fontSize: 13,
                                //       fontWeight: FontWeight.bold,
                                //       color: appcolor().mediumGreyColor),
                                // ),
                                // SizedBox(
                                //   height: Get.height * 0.001,
                                // ),
                                Text(
                                  data['name'].toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: appcolor().mainColor),
                                ),
                                SizedBox(
                                  height: Get.height * 0.001,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    Text(
                                      data['shop']['street'].toString(),
                                      style: TextStyle(
                                          color: appcolor().mainColor),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: Get.height * 0.17,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      });
}
