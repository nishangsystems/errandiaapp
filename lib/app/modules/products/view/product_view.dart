import 'dart:convert';

import 'package:errandia/app/APi/product.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/products/view/edit_product_view.dart';
import 'package:errandia/app/modules/products/view/products_send_enquiry.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:errandia/app/modules/reviews/views/add_review.dart';
import 'package:errandia/app/modules/reviews/views/review_view.dart';
import 'package:errandia/common/random_ui/ui_23.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  final profile_controller profileController = Get.find<profile_controller>();
  late PopupBox popup;

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
            Get.to(() => EditProductView(data: widget.item))
                ?.then((value) {
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
                    onConfirm: () {
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

  @override
  Widget build(BuildContext context) {
    //  print(widget.item.product_name);
    print("product item: ${widget.item}");
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        profileController.reloadMyProducts();
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
                              style: TextStyle(color: Colors.black, fontSize: 10),
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
                SizedBox(
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
                    ontap: () async {},
                    color: appcolor().mainColor,
                  ),
                ),
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
                                Icon(
                                  Icons.call,
                                  color: appcolor().mainColor,
                                ),
                                Text(
                                  // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
                                  'Call ${widget.item['shop']['phone']}',
                                  style: TextStyle(
                                    fontSize: 9,
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
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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

                              widget.item['shop'] != null ? Column(
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
                                    capitalizeAll(widget.item['shop']['name']),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),

                                  SizedBox(
                                    height: Get.height * 0.01,
                                  ),

                                  widget.item['shop']['street'] != "" || widget.item['shop']['town'] != null || widget.item['shop']['region'] != null ? Text(
                                    'Address',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[700]
                                    ),
                                  ) : Container(),

                                  widget.item['shop']['street'] != "" && widget.item['shop']['town'] != null && widget.item['shop']['region'] != null
                                      ? SizedBox(
                                    width: Get.width * 0.5,
                                    child: Text(
                                      widget.item['shop']['street']+", "+widget.item['shop']['town']['name']+ ", "+widget.item['shop']['region']['name'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ) : Container(),

                                  widget.item['shop']['street'] != "" && widget.item['shop']['town'] == null && widget.item['shop']['region'] != null
                                      ? SizedBox(
                                    width: Get.width * 0.5,
                                    child: Text(
                                      widget.item['shop']['street']+ ", "+widget.item['shop']['region']['name'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ) : Container(),

                                  widget.item['shop']['street'] == "" && widget.item['shop']['town'] != null && widget.item['shop']['region'] != null
                                      ? SizedBox(
                                    width: Get.width * 0.5,
                                    child: Text(
                                      widget.item['shop']['town']['name']+ ", "+widget.item['shop']['region']['name'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ) : Container(),

                                  widget.item['shop']['street'] == "" && widget.item['shop']['town'] == null && widget.item['shop']['region'] != null
                                      ? SizedBox(
                                    width: Get.width * 0.5,
                                    child: Text(
                                      widget.item['shop']['region']['name'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ) : Container(),
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
              Container(
                height: Get.height * 0.08,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: appcolor().greyColor,
                    ),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
                child: InkWell(
                  onTap: () {
                    Get.to(product_send_enquiry());
                  },
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.message,
                        color: appcolor().blueColor,
                      ),
                      Text(
                        '   Send Enquiry',
                        style: TextStyle(color: appcolor().blueColor),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: appcolor().mainColor,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: Get.height * 0.015,
              ),
              // suplier review
              Container(
                height: Get.height * 0.08,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: appcolor().greyColor,
                    ),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
                child: Row(
                  children: [
                    const Text(
                      'Supplier Review',
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.to(Review_view());
                      },
                      child: Text(
                        'See All',
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                // height: Get.height * 0.3,
                width: Get.width,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: appcolor().greyColor,
                    ),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(left: 20, right: 15, top: 15, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                height: Get.height * 0.05,
                                width: Get.width * 0.1,
                                color: Colors.white,
                                // child: Image.asset(widget.item['featured_image']),
                                child: Image.network(
                                  getImagePath(
                                      widget.item['featured_image'].toString()),
                                  fit: BoxFit.fill,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/errandia_logo.png',
                                      fit: BoxFit.cover,
                                      height: Get.height * 0.17,
                                      width: Get.width * 0.4,
                                    );
                                  },
                                ),
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name of supplier',
                                  ),
                                  Text('location'),
                                ],
                              ),
                              // Spacer(),
                              SizedBox(
                                width: Get.width * 0.13,
                              ),
                              RatingBar.builder(
                                itemCount: 5,
                                direction: Axis.horizontal,
                                initialRating: 1,
                                itemSize: 22,
                                maxRating: 5,
                                allowHalfRating: true,
                                glow: true,
                                itemBuilder: (context, _) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                                onRatingUpdate: (value) {
                                  debugPrint(value.toString());
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: Get.height * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Recently_item_List.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin:
                                EdgeInsets.only(right: 10, top: 10, bottom: 10),
                            height: Get.height * 0.2,
                            color: Colors.white,
                            width: Get.width * 0.2,
                            child: Center(
                                child: Image.asset(Recently_item_List[index]
                                    .imagePath
                                    .toString())),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                      ),
                    ),
                  ],
                ),
              ),

              // add your Reviews

              InkWell(
                onTap: () {
                  var item_ = {
                    'name': widget.item.name,
                    'price': widget.item.price,
                    'image': widget.item.imagePath,
                    'location': 'location',
                    'address': 'Molyko, Buea',
                    'featured_image': 'https://picsum.photos/250?image=9'
                  };
                  print("item: ${widget.item}");
                  Get.to(add_review_view(
                    review: item_,
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 15, top: 10, bottom: 10),
                  height: Get.height * 0.05,
                  width: Get.width * 0.4,
                  decoration: BoxDecoration(
                      color: appcolor().mainColor,
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Center(
                    child: Text(
                      'Add Your Review',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 10),
                child: Text(
                  'More products from this supplier',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ui_23_item_list.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin:
                            const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                        // height: Get.height * 0.15,
                        color: Colors.white,
                        width: Get.width * 0.38,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            SizedBox(
                              height: Get.height * 0.15,
                              child: Image.asset(
                                  ui_23_item_list[index].imagePath.toString()),
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: appcolor().mediumGreyColor,
                                  size: 13,
                                ),
                                Text(
                                  ui_23_item_list[index].location.toString(),
                                  style: TextStyle(
                                      color: appcolor().mediumGreyColor,
                                      fontSize: 12),
                                )
                              ],
                            ).paddingOnly(left: 10, right: 10),
                            Text(
                              ui_23_item_list[index].item_desc,
                              style: TextStyle(
                                  fontSize: 12, color: appcolor().mainColor),
                            ).paddingOnly(left: 12, right: 12),
                            Text(
                              ui_23_item_list[index].itemname,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: appcolor().mainColor,
                                  fontSize: 14),
                            ).paddingOnly(left: 10, right: 10),
                          ],
                        ));
                  },
                ),
              ),

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
              SizedBox(
                height: Get.height * 0.35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Recently_item_List.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin:
                            const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                        // height: Get.height * 0.15,
                        color: Colors.white,
                        width: Get.width * 0.38,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            SizedBox(
                              height: Get.height * 0.15,
                              child: Image.asset(
                                  Recently_item_List[index].imagePath.toString()),
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: appcolor().mediumGreyColor,
                                  size: 13,
                                ),
                                Text(
                                  ui_23_item_list[index].location.toString(),
                                  style: TextStyle(
                                      color: appcolor().mediumGreyColor,
                                      fontSize: 12),
                                )
                              ],
                            ).paddingOnly(left: 10, right: 10),
                            Text(
                              ui_23_item_list[index].item_desc,
                              style: TextStyle(
                                  fontSize: 12, color: appcolor().mainColor),
                              textAlign: TextAlign.center,
                            ).paddingOnly(left: 12, right: 12),
                            Text(
                              ui_23_item_list[index].itemname,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: appcolor().mainColor,
                                  fontSize: 14),
                            ).paddingOnly(left: 10, right: 10),
                          ],
                        ));
                  },
                ),
              ),

              SizedBox(
                height: Get.height * 0.1,
              )
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
        height: Get.height * 0.3,
        width: Get.width,
        child: FlutterCarousel.builder(
          itemCount: item['images'].length + 1,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            String imageUrl;
            if (itemIndex == 0) {
              // First item is the featured image
              imageUrl = getImagePath(item['featured_image'].toString());
            } else {
              // Subsequent items are the other images
              imageUrl = getImagePath(item['images'][itemIndex - 1]['url'].toString());
            }

            return Container(
              margin: const EdgeInsets.all(0.0),
              width: Get.width,
              height: Get.height * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/errandia_logo.png',
                  image: imageUrl,
                  fit: BoxFit.fill,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/errandia_logo.png',
                      fit: BoxFit.fill,
                    );
                  }
                ),
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
                    margin:
                        const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                    padding: const EdgeInsets.all(2.0),
                    height: Get.height * 0.23,
                    color: Colors.white,
                    width: Get.width * 0.18,
                    // child: Center(child: Image.network(image['url'].toString())),
                    child: Center(
                        child: Image.network(
                            getImagePath(image['url'].toString()),
                            fit: BoxFit.fill, errorBuilder:
                                (BuildContext context, Object exception,
                                    StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/errandia_logo.png',
                        fit: BoxFit.fill,
                      );
                    })),
                  );
                },
              ),
            )
          : Container(),
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
