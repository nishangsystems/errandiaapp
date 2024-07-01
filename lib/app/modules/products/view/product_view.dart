import 'dart:convert';

import 'package:errandia/app/APi/product.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/products/controller/product_controller.dart';
import 'package:errandia/app/modules/products/view/edit_product_view.dart';
import 'package:errandia/app/modules/services/view/service_details_view.dart';
import 'package:errandia/main.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/constants/color.dart';
import '../../profile/controller/profile_controller.dart';

class Product_view extends StatefulWidget {
  var item;
  final name;

  Product_view({super.key, required this.item, this.name});

  @override
  State<Product_view> createState() => _Product_viewState();
}

class _Product_viewState extends State<Product_view>
    with TickerProviderStateMixin {
  late final TabController tabController =
      TabController(length: 2, vsync: this);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late profile_controller profileController;
  late ProductController productCtl;
  late PopupBox popup;

  @override
  void initState() {
    super.initState();
    productCtl = Get.put(ProductController());
    profileController = Get.find<profile_controller>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      productCtl.reload();
      productCtl.loadOtherProducts(widget.item?['slug']);
      productCtl.loadOtherServices(widget.item['slug']);
    });
  }

  void showPopupMenu(BuildContext context) {
    var userIsOwner =
        profileController.userData.value['id'] == widget.item['user']['id'];
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
            Get.to(() => EditProductView(data: widget.item))?.then((value) {
              print("value update: $value");
              if (value != null) {
                setState(() {
                  widget.item = value;
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
                    title: "Delete Product",
                    message: "Are you sure you want to delete this product?",
                    dialogType: MyDialogType.error,
                    onConfirm: () async {
                      // delete product
                      print("delete product: ${widget.item['slug']}");
                      ProductAPI.deleteProductOrService(widget.item['slug'])
                          .then((response_) {
                        if (response_ != null) {
                          response = jsonDecode(response_);
                          print("delete product response: $response");

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
                profileController.reloadMyProducts();
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

    return [street, townName, regionName]
        .where((s) => s.isNotEmpty)
        .join(", ")
        .trim();
  }

  bool isMyProduct() {
    String? currentUser = ErrandiaApp.prefs.getString('user');

    if (currentUser != null) {
      var user = jsonDecode(currentUser);
      return user['id'] == widget.item['user']['id'];
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    //  print(widget.item.product_name);
    print("product item: ${widget.item}");
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        profileController.reloadMyProducts();
        productCtl.reload();
        productCtl.loadOtherServices(widget.item['slug']);
        productCtl.loadOtherProducts(widget.item['slug']);
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
                widget.item['shop'] != null ||
                        widget.item['shop'].toString() != "null"
                    ? InkWell(
                        onTap: () {
                          Get.to(() => errandia_business_view(
                                businessData: widget.item['shop'],
                              ));
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FaIcon(FontAwesomeIcons.store),
                            Text(
                              'Store',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                widget.item['shop'] != null ||
                        widget.item['shop'].toString() != "null"
                    ? const SizedBox(
                        width: 10,
                      )
                    : Container(),
                widget.item['shop']['whatsapp'] != "" &&
                        widget.item['shop']['whatsapp'] != "whatsapp"
                    ? SizedBox(
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                          ontap: () async {
                            print(
                                "whatsapp number: ${widget.item['shop']['whatsapp']}");
                            launchWhatsapp(widget.item['shop']['whatsapp']);
                          },
                          color: appcolor().mainColor,
                        ),
                      )
                    : Container(),
                if (widget.item['shop']['whatsapp'] != "" ||
                    widget.item['shop']['whatsapp'] != "whatsapp")
                  const Spacer(),
                widget.item['shop'] != null ||
                        widget.item['shop'].toString() != 'null'
                    ? SizedBox(
                        width: Get.width * 0.4,
                        height: 50,
                        child: blockButton(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.call,
                                    color: appcolor().mainColor, size: 20),
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
                            launchCaller(widget.item['shop']['phone']);
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
          centerTitle: isMyProduct() ? false : true,
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
            capitalizeAll(widget.item['name'].toString()),
            style: TextStyle(
              color: appcolor().mediumGreyColor,
            ),
          ),
          actions: [
            if (isMyProduct())
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
              Column(
                children: [
                  image_select_widget(context, widget.item),
                  product_review_widget(widget.item),
                  // SizedBox(
                  //   height: Get.height * 0.03,
                  // ),
                  // chat on whatsapp button
                  // blockButton(
                  //   title: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(
                  //         FontAwesomeIcons.whatsapp,
                  //         color: Colors.white,
                  //       ),
                  //       Text(
                  //         '  Chat on Whatsapp',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  //   ontap: () {},
                  //   color: appcolor().mainColor,
                  // ),

                  // call button
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  // blockButton(
                  //   title: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(
                  //         FontAwesomeIcons.phone,
                  //         color: appcolor().mainColor,
                  //         size: 18,
                  //       ),
                  //       Text(
                  //         '  Call 673580194',
                  //         style: TextStyle(
                  //             color: appcolor().mainColor, fontSize: 16),
                  //       )
                  //     ],
                  //   ),
                  //   ontap: () {},
                  //   color: appcolor().skyblueColor,
                  // ),
                ],
              ),

              // tab bar view
              SizedBox(
                height: Get.height * 0.01,
              ),
              // Divider(
              //   color: appcolor().mediumGreyColor,
              // ),
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
                            text: "Supplier Info",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      height: Get.height * 0.2,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          // Text('${widget.item['description']}'),
                          Text(
                            widget.item['description'],
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: Get.height * 0.1,
                                width: Get.width * 0.2,
                                color: Colors.white,
                                child: Image.network(
                                  getImagePath(widget.item['shop']['image']),
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
                                width: Get.width * 0.05,
                              ),
                              widget.item['shop'] != null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Business Name',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey[700]),
                                        ),
                                        Text(
                                          capitalizeAll(
                                              widget.item['shop']['name']),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.01,
                                        ),
                                        (widget.item['shop']['street'] != "" ||
                                                    widget.item['shop']
                                                            ['street'] !=
                                                        null) ||
                                                widget.item['shop']['town'] !=
                                                    null ||
                                                widget.item['shop']['region'] !=
                                                    null
                                            ? Text(
                                                'Address',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey[700]),
                                              )
                                            : Container(),
                                        SizedBox(
                                          width: Get.width * 0.5,
                                          child: Text(
                                            _formatAddress(widget.item['shop']),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
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
              //   padding: const EdgeInsets.only(
              //       left: 20, right: 15, top: 5, bottom: 5),
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
              //           '   Send Enquiry',
              //           style: TextStyle(color: appcolor().blueColor),
              //         ),
              //         Spacer(),
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
              //   padding: const EdgeInsets.only(
              //       left: 20, right: 15, top: 5, bottom: 5),
              //   child: Row(
              //     children: [
              //       const Text(
              //         'Supplier Review',
              //         style: TextStyle(fontSize: 15),
              //       ),
              //       Spacer(),
              //       TextButton(
              //         onPressed: () {
              //           Get.to(Review_view());
              //         },
              //         child: Text(
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
              //   padding:
              //       EdgeInsets.only(left: 20, right: 15, top: 15, bottom: 5),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Container(
              //             child: Row(
              //               children: [
              //                 Container(
              //                   margin: const EdgeInsets.only(right: 8),
              //                   height: Get.height * 0.05,
              //                   width: Get.width * 0.1,
              //                   color: Colors.white,
              //                   // child: Image.asset(widget.item['featured_image']),
              //                   child: Image.network(
              //                     getImagePath(
              //                         widget.item['featured_image'].toString()),
              //                     fit: BoxFit.fill,
              //                     errorBuilder: (BuildContext context,
              //                         Object exception,
              //                         StackTrace? stackTrace) {
              //                       return Image.asset(
              //                         'assets/images/errandia_logo.png',
              //                         fit: BoxFit.cover,
              //                         height: Get.height * 0.17,
              //                         width: Get.width * 0.4,
              //                       );
              //                     },
              //                   ),
              //                 ),
              //                 const Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       'Name of supplier',
              //                     ),
              //                     Text('location'),
              //                   ],
              //                 ),
              //                 // Spacer(),
              //                 SizedBox(
              //                   width: Get.width * 0.13,
              //                 ),
              //                 RatingBar.builder(
              //                   itemCount: 5,
              //                   direction: Axis.horizontal,
              //                   initialRating: 1,
              //                   itemSize: 22,
              //                   maxRating: 5,
              //                   allowHalfRating: true,
              //                   glow: true,
              //                   itemBuilder: (context, _) {
              //                     return Icon(
              //                       Icons.star,
              //                       color: Colors.amber,
              //                     );
              //                   },
              //                   onRatingUpdate: (value) {
              //                     debugPrint(value.toString());
              //                   },
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //       Container(
              //         height: Get.height * 0.15,
              //         child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: Recently_item_List.length,
              //           itemBuilder: (context, index) {
              //             return Container(
              //               margin:
              //                   EdgeInsets.only(right: 10, top: 10, bottom: 10),
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
              //         padding: EdgeInsets.only(bottom: 10),
              //         child: Text(
              //           'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // add your Reviews

              // InkWell(
              //   onTap: () {
              //     var item_ = {
              //       'name': widget.item.name,
              //       'price': widget.item.price,
              //       'image': widget.item.imagePath,
              //       'location': 'location',
              //       'address': 'Molyko, Buea',
              //       'featured_image': 'https://picsum.photos/250?image=9'
              //     };
              //     print("item: ${widget.item}");
              //     Get.to(add_review_view(
              //       review: item_,
              //     ));
              //   },
              //   child: Container(
              //     margin: const EdgeInsets.only(
              //         left: 20, right: 15, top: 10, bottom: 10),
              //     height: Get.height * 0.05,
              //     width: Get.width * 0.4,
              //     decoration: BoxDecoration(
              //         color: appcolor().mainColor,
              //         borderRadius: BorderRadius.circular(5)),
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                padding:
                    EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 10),
                child: Text(
                  'More products from this supplier',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Obx(() {
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
                              // replace current view
                              Get.offNamed(
                                '/product_view',
                                arguments: item,
                                preventDuplicates: false,
                              );
                              // Get.to(() => Product_view(
                              //       item: item,
                              //     ));
                            },
                            child: errandia_widget(
                              cost: item['unit_price'].toString(),
                              imagePath: item['featured_image'],
                              name: item['name'],
                              location: item['shop'] != null
                                  ? item['shop']['street']
                                  : "",
                            ));
                      },
                    ),
                  );
                }
              }),

              const Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
                child: Text(
                  'Services Offered by this Supplier',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Obx(() {
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
                          onTap: () async {
                            await Future.delayed(Duration.zero);
                            if (!mounted) return;
                            if (kDebugMode) {
                              print("service item: ${item['name']}");
                            }
                            // WidgetsBinding.instance.addPostFrameCallback((_) {
                            Get.to(() => ServiceDetailsView(service: item));
                            // });
                          },
                          child: errandia_widget(
                            cost: item['unit_price'].toString(),
                            imagePath: item['featured_image'],
                            name: item['name'],
                            location: item['shop'] != null
                                ? item['shop']['street']
                                : "",
                          ),
                        );
                      },
                    ),
                  );
                }
              }),

              // SizedBox(
              //   height: Get.height * 0.1,
              // )
            ],
          ),
        ),
      ),
    );
  }
}

Widget image_select_widget(BuildContext context, final item) {
  return Column(
    children: [
      // Container(
      //   height: Get.height * 0.3,
      //   width: Get.width,
      //   child: CarouselSlider.builder(
      //     options: CarouselOptions(
      //       enableInfiniteScroll: true,
      //       aspectRatio: MediaQuery.of(context).size.aspectRatio,
      //       viewportFraction: 1.0,
      //       scrollDirection: Axis.horizontal,
      //       // height: Get.height * 0.3,
      //     ),
      //     itemCount: item.length,
      //     itemBuilder: (context, index, realIndex) {
      //       // var image = item[index];
      //       // return Image.network(
      //       //   image['url'].toString(),
      //       //   fit: BoxFit.cover,
      //       // );
      //       print("image path: ${item}");
      //       return Container(
      //         margin: const EdgeInsets.all(5.0),
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(8.0),
      //           child: Image.network(
      //             getImagePath(item['featured_image'].toString()),
      //             fit: BoxFit.cover,
      //             errorBuilder: (BuildContext context, Object exception,
      //                 StackTrace? stackTrace) {
      //               return Image.asset(
      //                 'assets/images/errandia_logo.png',
      //                 fit: BoxFit.fill,
      //               );
      //             }
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),
      // featured image
      // SizedBox(
      //   height: Get.height * 0.3,
      //   width: Get.width,
      //   child: ClipRRect(
      //     child: Image.network(getImagePath(item['featured_image'].toString()),
      //         fit: BoxFit.cover, errorBuilder: (BuildContext context,
      //             Object exception, StackTrace? stackTrace) {
      //       return Image.asset(
      //         'assets/images/errandia_logo.png',
      //         fit: BoxFit.fill,
      //         height: Get.height * 0.17,
      //         width: Get.width * 0.4,
      //       );
      //     }),
      //   ),
      // ),
      SizedBox(
        height: Get.height * 0.33,
        width: Get.width,
        child: FlutterCarousel.builder(
          itemCount: item['images'].length + 1,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            String imageUrl;
            if (itemIndex == 0) {
              // First item is the featured image
              imageUrl = getImagePathWithSize(item['featured_image'].toString(),
                  width: 720, height: 500);
            } else {
              // Subsequent items are the other images
              imageUrl = getImagePathWithSize(
                  item['images'][itemIndex - 1]['url'].toString(),
                  width: 720,
                  height: 500);
            }

            return Container(
              margin: const EdgeInsets.all(0.0),
              width: Get.width,
              // height: Get.height * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/errandia_logo_1.jpeg',
                    image: imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/errandia_logo_1.jpeg',
                        fit: BoxFit.contain,
                        width: double.infinity,
                      );
                    }),
              ),
            );
          },
          options: CarouselOptions(
            height: Get.height * 0.4,
            autoPlay: true,
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 8),
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeOutExpo,
            floatingIndicator: false,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            showIndicator: false,
          ),
        ),
      ),

      item['images'].length > 0
          ? SizedBox(
              height: Get.height * 0.1,
              width: Get.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: item['images'].length,
                itemBuilder: (context, index) {
                  var image = item['images'][index];
                  return Container(
                    margin: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                    padding: const EdgeInsets.all(2.0),
                    height: Get.height * 0.23,
                    color: Colors.white,
                    width: Get.width * 0.18,
                    // child: Center(child: Image.network(image['url'].toString())),
                    child: Center(
                        child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/errandia_logo.png',
                            image: getImagePathWithSize(image['url'].toString(),
                                width: 200, height: 200),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/errandia_logo.png',
                                fit: BoxFit.fill,
                                width: double.infinity,
                              );
                            })),
                  );
                },
              ),
            )
          : SizedBox(
              height: Get.height * 0.015,
            ),
    ],
  );
}

Widget product_review_widget(item) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
