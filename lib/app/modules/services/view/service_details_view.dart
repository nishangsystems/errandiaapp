import 'dart:convert';

import 'package:errandia/app/APi/product.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/product_controller.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/services/view/edit_service_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ServiceDetailsView extends StatefulWidget {
  var service;

  ServiceDetailsView({super.key, required this.service});

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView>
    with TickerProviderStateMixin {
  late final TabController tabController =
  TabController(length: 2, vsync: this);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late profile_controller profileController;
  late PopupBox popup;
  late ProductController productCtl;

  late Map<String, dynamic> _localService;

  @override
  void initState() {
    super.initState();
    productCtl = Get.put(ProductController());
    profileController = Get.find<profile_controller>();
    _localService = widget.service;

    // profileController.loadMyProducts();
   WidgetsBinding.instance.addPostFrameCallback((_) {
     productCtl.reload();
     productCtl.loadOtherServices(_localService['slug']);
     productCtl.loadOtherProducts(_localService['slug']);
    });
  }

  void showPopupMenu(BuildContext context) {
    var userIsOwner =
        profileController.userData.value['id'] == _localService['user']['id'];
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
            Get.to(() => EditServiceView(data: _localService))
                ?.then((value) {
              print("value update: $value");
              if (value != null) {
                setState(() {
                  _localService = value;
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
                    title: "Delete Service",
                    message: "Are you sure you want to delete this service?",
                    dialogType: MyDialogType.error,
                    onConfirm: () {
                      // delete product
                      print("delete product: ${_localService['slug']}");
                      ProductAPI.deleteProductOrService(_localService['slug'])
                          .then((response_) {
                        if (response_ != null) {
                          response = jsonDecode(response_);
                          print("delete service response: $response");

                          if (mounted) {
                            // Check if the widget is still in the tree
                            if (response["status"] == 'success') {
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
                profileController.reloadMyServices();
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

  String _formatAddress(Map<String, dynamic> shop) {
    String street = shop['street'] ?? '';
    String townName = shop['town'] != null ? shop['town']['name'] : '';
    String regionName = shop['region'] != null ? shop['region']['name'] : '';

    return [street, townName, regionName].where((s) => s.isNotEmpty).join(", ").trim();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("service: ${_localService['slug']}");
    }
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        profileController.reloadMyServices();
        productCtl.reload();
        productCtl.loadOtherServices(_localService['slug']);
        productCtl.loadOtherProducts(_localService['slug']);
        return true;
      },
      child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _localService['shop'] != null ||
                      _localService['shop'].toString() != "null"
                      ? InkWell(
                    onTap: () {
                      Get.to(() => errandia_business_view(
                        businessData: _localService['shop'],
                      ));
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FaIcon(FontAwesomeIcons.store),
                        Text(
                          'Store',
                          style: TextStyle(color: Colors.black, fontSize: 10),
                        ),
                      ],
                    ),
                  )
                      : Container(),
                  _localService['shop'] != null ||
                      _localService['shop'].toString() != "null"
                      ? const SizedBox(
                    width: 10,
                  )
                      : Container(),
                  _localService['shop']['whatsapp'] != "" && _localService['shop']['whatsapp'] != "whatsapp" ? SizedBox(
                    width: Get.width * 0.4,
                    height: 50,
                    child: blockButton(
                      title: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.white,
                            ),
                            Text(
                              '  Chat on Whatsapp',
                              style: TextStyle(color: Colors.white, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      ontap: () async {
                        print("whatsapp: ${_localService['shop']['whatsapp']}");
                        launchWhatsapp(_localService['shop']['whatsapp']);
                      },
                      color: appcolor().mainColor,
                    ),
                  ) : Container(),

                  if (_localService['shop']['whatsapp'] !="" || _localService['shop']['whatsapp']!="whatsapp")
                    const Spacer(),

                  _localService['shop'] != null ||
                      _localService['shop'].toString() != 'null'
                      ? SizedBox(
                    width: Get.width * 0.4,
                    height: 50,
                    child: blockButton(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call_rounded,
                              color: appcolor().mainColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
                              'Call',
                              style: TextStyle(
                                fontSize: 16,
                                color: appcolor().mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ontap: () {
                        launchCaller(_localService['shop']['phone']);
                      },
                      color: appcolor().skyblueColor,
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 244, 244, 244),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: appcolor().mediumGreyColor,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              capitalizeAll(_localService['name']),
              style: TextStyle(
                color: appcolor().mediumGreyColor,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.messenger_sharp,
                  size: 30,
                ),
                color: appcolor().mediumGreyColor,
              ),
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
            ],
          ),
          body: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // service image
              Container(
                margin: const EdgeInsets.all(0.0),
                // height: Get.height * 0.3,
                width: Get.width,
                child: ClipRRect(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/errandia_logo_1.jpeg',
                    image: getImagePathWithSize(_localService['featured_image'], width: 720, height: 500),
                    fit: BoxFit.contain,
                    width: double.infinity,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/errandia_logo_1.jpeg',
                        fit: BoxFit.contain,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
              ),

              product_review_widget(_localService),

              SizedBox(
                height: Get.height * 0.03,
              ),

              Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(
                          color: appcolor().greyColor,
                        ))),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: Get.height * 0.07,
                      child: TabBar(
                        // isScrollable: true,
                        dividerColor: appcolor().mediumGreyColor,
                        unselectedLabelColor: appcolor().mediumGreyColor,
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                        indicatorColor: appcolor().mainColor,

                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appcolor().mainColor,
                          fontSize: 18,
                        ),
                        controller: tabController,
                        labelColor: appcolor().mainColor,
                        tabs: const [
                          Tab(
                            text: "Description",
                          ),
                          Tab(
                            text: "Contact Info",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      height: Get.height * 0.2,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          // Text('${widget.item['description']}'),
                          Text(_localService['description'],
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // business logo
                              Container(
                                height: Get.height * 0.1,
                                width: Get.width * 0.2,
                                color: Colors.white,
                                child: Image.network(
                                  getImagePath(_localService['shop']['image']),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/errandia_logo.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.08,
                              ),

                              _localService['shop'] != null ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Text(
                                        'Business Name',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[700]
                                        ),
                                      ),
                                      Text(
                                        capitalizeAll(_localService['shop']['name']),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),

                                      SizedBox(
                                        height: Get.height * 0.01,
                                      ),

                                      (_localService['shop']['street'] != "" || _localService['shop']['street'] != null)  || _localService['shop']['town'] != null || _localService['shop']['region'] != null ? Text(
                                        'Address',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[700]
                                        ),
                                      ) : Container(),

                                    SizedBox(
                                        width: Get.width * 0.5,
                                        child: Text(
                                          _formatAddress(_localService['shop']),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ): Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: Get.height * 0.015,
              ),

              // Container(
              //   height: Get.height * 0.08,
              //   decoration: BoxDecoration(
              //     border: Border.symmetric(
              //       horizontal: BorderSide(
              //         color: appcolor().greyColor,
              //       ),
              //     ),
              //     color: Colors.white,
              //   ),
              //   padding: const EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
              //   child: InkWell(
              //     onTap: () {
              //       Get.to(product_send_enquiry());
              //     },
              //     child: Row(
              //       children: [
              //         Icon(
              //           FontAwesomeIcons.message,
              //           color: appcolor().blueColor,
              //         ),
              //         Text(
              //           'Send Enquiry',
              //           style: TextStyle(color: appcolor().blueColor),
              //         ),
              //         const Spacer(),
              //         Icon(
              //           Icons.arrow_forward_ios_outlined,
              //           color: appcolor().mainColor,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //
              SizedBox(
                height: Get.height * 0.015,
              ),

              // suplier review
              // Container(
              //   height: Get.height * 0.08,
              //   decoration: BoxDecoration(
              //     border: Border.symmetric(
              //       horizontal: BorderSide(
              //         color: appcolor().greyColor,
              //       ),
              //     ),
              //     color: Colors.white,
              //   ),
              //   padding: const EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
              //   child: Row(
              //     children: [
              //       const Text(
              //         'Supplier Review',
              //         style: TextStyle(fontSize: 15),
              //       ),
              //       const Spacer(),
              //       TextButton(
              //         onPressed: () {
              //           Get.to(Review_view());
              //         },
              //         child: const Text(
              //           'See All',
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              //
              // Container(
              //   // height: Get.height * 0.3,
              //   width: Get.width,
              //   decoration: BoxDecoration(
              //     border: Border.symmetric(
              //       horizontal: BorderSide(
              //         color: appcolor().greyColor,
              //       ),
              //     ),
              //     color: Colors.white,
              //   ),
              //   padding: const EdgeInsets.only(left: 20, right: 15, top: 15, bottom: 5),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Row(
              //             children: [
              //               Container(
              //                 margin: const EdgeInsets.only(right: 8),
              //                 height: Get.height * 0.05,
              //                 width: Get.width * 0.1,
              //                 color: Colors.white,
              //                 // child: Image.asset(widget.item['featured_image']),
              //                 child: Image.network(
              //                   _localService['featured_image'],
              //                   fit: BoxFit.cover,
              //                   errorBuilder: (context, error, stackTrace) {
              //                     return Image.asset(
              //                       'assets/images/errandia_logo.png',
              //                       fit: BoxFit.cover,
              //                     );
              //                   },
              //                 ),
              //               ),
              //               const Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     'Name of supplier',
              //                   ),
              //                   Text('location'),
              //                 ],
              //               ),
              //               // Spacer(),
              //               SizedBox(
              //                 width: Get.width * 0.13,
              //               ),
              //               RatingBar.builder(
              //                 itemCount: 5,
              //                 direction: Axis.horizontal,
              //                 initialRating: 1,
              //                 itemSize: 22,
              //                 maxRating: 5,
              //                 allowHalfRating: true,
              //                 glow: true,
              //                 itemBuilder: (context, _) {
              //                   return const Icon(
              //                     Icons.star,
              //                     color: Colors.amber,
              //                   );
              //                 },
              //                 onRatingUpdate: (value) {
              //                   debugPrint(value.toString());
              //                 },
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: Get.height * 0.15,
              //         child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: Recently_item_List.length,
              //           itemBuilder: (context, index) {
              //             return Container(
              //               margin:
              //               const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              //               height: Get.height * 0.2,
              //               color: Colors.white,
              //               width: Get.width * 0.2,
              //               child: Center(
              //                   child: Image.asset(Recently_item_List[index]
              //                       .imagePath
              //                       .toString())),
              //             );
              //           },
              //         ),
              //       ),
              //       Container(
              //         padding: const EdgeInsets.only(bottom: 10),
              //         child: const Text(
              //           'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // InkWell(
              //   onTap: () {
              //     // var item = {
              //     //   'name': _localService.name,
              //     //   'imagePath': _localService.imagePath,
              //     //   'cost': _localService.cost,
              //     //   'location': _localService.location,
              //     //   'featured_image': "https://picsum.photos/250?image=9",
              //     //   'address': 'Akwa, Douala',
              //     // };
              //     // Get.to(() => add_review_view(
              //     //   review: item,
              //     // ));
              //   },
              //   child: Container(
              //     margin:
              //     const EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
              //     height: Get.height * 0.05,
              //     width: Get.width * 0.4,
              //     decoration: BoxDecoration(
              //         color: appcolor().mainColor,
              //         borderRadius: BorderRadius.circular(5)),
              //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //     child: const Center(
              //       child: Text(
              //         'Add Your Review',
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white,
              //             fontSize: 12),
              //       ),
              //     ),
              //   ),
              // ),

              const Padding(
                padding: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 10),
                child: Text(
                  'More products from this supplier',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Obx(
                      () {
                    if (productCtl.isProductLoading.value == true) {
                      return SizedBox(
                        height: Get.height * 0.3,
                        child: buildLoadingWidget(),
                      );
                    } else if (productCtl.productList.isEmpty) {
                      return SizedBox(
                        height: Get.height * 0.3,
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
                      return SizedBox(
                        height: Get.height * 0.3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productCtl.productList.length,
                          itemBuilder: (context, index) {
                            var item = productCtl.productList[index];
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
                                  location: item['shop'] != null ? item['shop']['street'] : "",
                                ));
                          },
                        ),
                      );
                    }
                  }
              ),

              const Padding(
                padding:
                EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
                child: Text(
                  'More Services Offered by this Supplier',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Obx(
                      () {
                    if (productCtl.isServiceLoading.value == true) {
                      return SizedBox(
                        height: Get.height * 0.3,
                        child: buildLoadingWidget(),
                      );
                    } else if (productCtl.serviceList.isEmpty) {
                      return SizedBox(
                        height: Get.height * 0.3,
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
                      return SizedBox(
                        height: Get.height * 0.3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productCtl.serviceList.length,
                          itemBuilder: (context, index) {
                            var item = productCtl.serviceList[index];
                            return GestureDetector(
                              onTap: () {
                                if (kDebugMode) {
                                  print("service item: ${item['name']}");
                                }
                                // Get.to(() => ServiceDetailsView(service: item));
                                Get.offNamed('/service_view', arguments: item,
                                  preventDuplicates: false
                                );
                              },
                              child: errandia_widget(
                                cost: item['unit_price'].toString(),
                                imagePath: item['featured_image'],
                                name: item['name'],
                                location: item['shop'] != null ? item['shop']['street'] : "",
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
              ),

              SizedBox(
                height: Get.height * 0.1,
              )

            ],
          ))),
    );
  }
}

Widget product_review_widget(item) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(
      height: Get.height * 0.01,
    ),
    Text(
      capitalizeAll(item['name'].toString()),
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    ),
    SizedBox(
      height: Get.height * 0.01,
    ),
    Text(
      formatPrice(double.parse(item['unit_price'].toString())),
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: appcolor().mediumGreyColor),
    ),
    Row(
      children: [
        // RatingBar.builder(
        //   itemCount: 5,
        //   direction: Axis.horizontal,
        //   initialRating: 1,
        //   itemSize: 22,
        //   maxRating: 5,
        //   allowHalfRating: true,
        //   glow: true,
        //   itemBuilder: (context, _) {
        //     return const Icon(
        //       Icons.star,
        //       color: Colors.amber,
        //     );
        //   },
        //   onRatingUpdate: (value) {
        //     debugPrint(value.toString());
        //   },
        // ),
        SizedBox(
          width: Get.width * 0.01,
        ),
        // Text(
        //   // '${item['reviews']} Supplier Reviews',
        //   '{} Supplier Reviews',
        //   style: TextStyle(color: appcolor().mediumGreyColor, fontSize: 12),
        // ),
      ],
    ),
  ]).paddingOnly(left: 15, right: 15);
}
