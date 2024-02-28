import 'dart:convert';

import 'package:errandia/app/APi/product.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/categories/CategoryData.dart';
import 'package:errandia/app/modules/errands/view/Product/serivces.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/view/products_send_enquiry.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:errandia/app/modules/reviews/views/add_review.dart';
import 'package:errandia/app/modules/reviews/views/review_view.dart';
import 'package:errandia/app/modules/services/view/edit_service_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

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
  final profile_controller profileController = Get.find<profile_controller>();
  late PopupBox popup;

  void showPopupMenu(BuildContext context) {
    var userIsOwner =
        profileController.userData.value['id'] == widget.service['user']['id'];
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
            Get.to(() => EditServiceView(data: widget.service))
                ?.then((value) {
              print("value update: $value");
              if (value != null) {
                setState(() {
                  widget.service = value;
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
                      print("delete product: ${widget.service['slug']}");
                      ProductAPI.deleteProductOrService(widget.service['slug'])
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

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("service: ${widget.service['name']}");
    }
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        profileController.reloadMyServices();
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
                  widget.service['shop'] != null ||
                      widget.service['shop'].toString() != "null"
                      ? InkWell(
                    onTap: () {
                      Get.to(() => errandia_business_view(
                        businessData: widget.service['shop'],
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
                  widget.service['shop'] != null ||
                      widget.service['shop'].toString() != "null"
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
                  widget.service['shop'] != null ||
                      widget.service['shop'].toString() != 'null'
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
                              'Call ${widget.service['shop']['phone']}',
                              style: TextStyle(
                                fontSize: 9,
                                color: appcolor().mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ontap: () {
                        launchCaller(widget.service['shop']['phone']);
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
              capitalizeAll(widget.service['name']),
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
              SizedBox(
                height: Get.height * 0.3,
                width: Get.width,
                child: ClipRRect(
                  child: Image.network(getImagePath(widget.service['featured_image'].toString()),
                      fit: BoxFit.cover, errorBuilder: (BuildContext context,
                          Object exception, StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/errandia_logo.png',
                          fit: BoxFit.fill,
                          height: Get.height * 0.17,
                          width: Get.width * 0.4,
                        );
                      }),
                ),
              ),

              product_review_widget(widget.service),

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
                          Text(widget.service['description'],
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
                                  getImagePath(widget.service['shop']['image']),
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

                              widget.service['shop'] != null ? Column(
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
                                        widget.service['shop']['name'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),

                                      SizedBox(
                                        height: Get.height * 0.01,
                                      ),

                                      widget.service['shop']['street'] != "" || widget.service['shop']['town'] != null || widget.service['shop']['region'] != null ? Text(
                                        'Address',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey[700]
                                        ),
                                      ) : Container(),

                                      widget.service['shop']['street'] != "" && widget.service['shop']['town'] != null && widget.service['shop']['region'] != null
                                      ? SizedBox(
                                        width: Get.width * 0.5,
                                        child: Text(
                                          widget.service['shop']['street']+", "+widget.service['shop']['town']['name']+ ", "+widget.service['shop']['region']['name'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ) : Container(),

                                      widget.service['shop']['street'] != "" && widget.service['shop']['town'] == null && widget.service['shop']['region'] != null
                                          ? SizedBox(
                                        width: Get.width * 0.5,
                                        child: Text(
                                          widget.service['shop']['street']+ ", "+widget.service['shop']['region']['name'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ) : Container(),

                                      widget.service['shop']['street'] == "" && widget.service['shop']['town'] != null && widget.service['shop']['region'] != null
                                          ? SizedBox(
                                        width: Get.width * 0.5,
                                        child: Text(
                                          widget.service['shop']['town']['name']+ ", "+widget.service['shop']['region']['name'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ) : Container(),

                                      widget.service['shop']['street'] == "" && widget.service['shop']['town'] == null && widget.service['shop']['region'] != null
                                          ? SizedBox(
                                        width: Get.width * 0.5,
                                        child: Text(
                                          widget.service['shop']['region']['name'],
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
                        'Send Enquiry',
                        style: TextStyle(color: appcolor().blueColor),
                      ),
                      const Spacer(),
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
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.to(Review_view());
                      },
                      child: const Text(
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
                padding: const EdgeInsets.only(left: 20, right: 15, top: 15, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              height: Get.height * 0.05,
                              width: Get.width * 0.1,
                              color: Colors.white,
                              // child: Image.asset(widget.item['featured_image']),
                              child: Image.network(
                                widget.service['featured_image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/errandia_logo.png',
                                    fit: BoxFit.cover,
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
                                return const Icon(
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
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Recently_item_List.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin:
                            const EdgeInsets.only(right: 10, top: 10, bottom: 10),
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
                      padding: const EdgeInsets.only(bottom: 10),
                      child: const Text(
                        'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                      ),
                    ),
                  ],
                ),
              ),

              InkWell(
                onTap: () {
                  // var item = {
                  //   'name': widget.service.name,
                  //   'imagePath': widget.service.imagePath,
                  //   'cost': widget.service.cost,
                  //   'location': widget.service.location,
                  //   'featured_image': "https://picsum.photos/250?image=9",
                  //   'address': 'Akwa, Douala',
                  // };
                  // Get.to(() => add_review_view(
                  //   review: item,
                  // ));
                },
                child: Container(
                  margin:
                  const EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
                  height: Get.height * 0.05,
                  width: Get.width * 0.4,
                  decoration: BoxDecoration(
                      color: appcolor().mainColor,
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                height: Get.height * 0.32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ui_23_item_list.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                        // height: Get.height * 0.15,
                        color: Colors.white,
                        width: Get.width * 0.38,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.15,
                              child: Image.asset(
                                  ui_23_item_list[index].imagePath.toString()),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: appcolor().mediumGreyColor,
                                ),
                                Text(
                                  ui_23_item_list[index].location.toString(),
                                  style: TextStyle(
                                      color: appcolor().mediumGreyColor,
                                      fontSize: 12),
                                )
                              ],
                            ),
                            Text(
                              ui_23_item_list[index].item_desc,
                              style: TextStyle(
                                  fontSize: 12, color: appcolor().mainColor),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              ui_23_item_list[index].itemname,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: appcolor().mainColor,
                                  fontSize: 16),
                            )
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
                height: Get.height * 0.32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Recently_item_List.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                        // height: Get.height * 0.15,
                        color: Colors.white,
                        width: Get.width * 0.38,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.15,
                              child: Image.asset(
                                  Recently_item_List[index].imagePath.toString()),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: appcolor().mediumGreyColor,
                                ),
                                Text(
                                  ui_23_item_list[index].location.toString(),
                                  style: TextStyle(
                                      color: appcolor().mediumGreyColor,
                                      fontSize: 12),
                                )
                              ],
                            ),
                            Text(
                              ui_23_item_list[index].item_desc,
                              style: TextStyle(
                                  fontSize: 12, color: appcolor().mainColor),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              ui_23_item_list[index].itemname,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: appcolor().mainColor,
                                  fontSize: 16),
                            )
                          ],
                        ));
                  },
                ),
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
