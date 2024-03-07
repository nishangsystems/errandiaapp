import 'dart:convert';

import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/controller/errandia_business_view_controller.dart';
import 'package:errandia/app/modules/buiseness/verify_business_otp.dart';
import 'package:errandia/app/modules/buiseness/view/visit_shop.dart';
import 'package:errandia/app/modules/categories/CategoryData.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:errandia/app/modules/reviews/views/review_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../APi/business.dart';
import '../../errands/view/Product/serivces.dart';
import '../../global/Widgets/CustomDialog.dart';
import '../../global/Widgets/bottomsheet_item.dart';
import '../../global/Widgets/popupBox.dart';
import 'edit_business_view.dart';

class errandia_business_view extends StatefulWidget {
  late final Map<String, dynamic> businessData;

  errandia_business_view({Key? key, required this.businessData}): super(key: key);

  @override
  State<StatefulWidget> createState() => _errandia_business_viewState();
}

class _errandia_business_viewState extends State<errandia_business_view> with WidgetsBindingObserver {
  final business_controller controller = Get.put(business_controller());
  late final ErrandiaBusinessViewController errandiaBusinessViewController;
  late ScrollController scrollController;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final profile_controller profileController = Get.put(profile_controller());
  // List<dynamic> businessBranchesData = [];
  late PopupBox popup;

  bool sendingOTPLoading = false;

  late String businessSlug;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    errandiaBusinessViewController = Get.put(ErrandiaBusinessViewController());

    setState(() {
      businessSlug = widget.businessData['slug'];
    });

    errandiaBusinessViewController.update();
    errandiaBusinessViewController.loadBusinessBranches(businessSlug);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      errandiaBusinessViewController.reloadBusinesses();
    });

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 10) {
        errandiaBusinessViewController.loadBusinessBranches(businessSlug);
      }
    });
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
                              Get.snackbar(
                                'Success',
                                response['data']['message'],
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 5),
                              );
                            } else {
                              Navigator.of(dialogContext)
                                  .pop(); //
                              Navigator.pop(context); // Close the dialog

                              // Show error popup
                              Get.snackbar(
                                'Error',
                                response['data']['message'],
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 10),
                              );
                            }

                          }
                        }
                      });
                    },
                   onCancel: () {
                    Get.back();
                   }
                    );
              },
            ).then((_) {
              // if (mounted) {
              //   try {
              //     popup.dismissPopup(dialogContext); // Dismiss the popup
              //   } catch (e) {
              //     print("error dismissing popup: $e");
              //   }
                profileController.reloadMyBusinesses();
              //   // Get.back();
              // }
            });
            break;
        // case 'share':
        //   // Handle share action
        //   break;
        }
      }
    });
  }

  void sendOTP(BuildContext context) async {
    try {
      setState(() {
        sendingOTPLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await BusinessAPI.sendBusinessOtp(widget.businessData['slug'])
          .then((response) {
        print("send otp response: $response");

        var data = jsonDecode(response);

        if (response != null) {
          print("send otp response: $data");
          if (data['status'] == 'success') {
            prefs.setString('shopUuid', data['data']['data']['uuid']);
            Get.to(() => VerifyBusinessOtp(
              businessData: widget.businessData,
            ))?.then((value) {
              if (value != null) {
                setState(() {
                  widget.businessData = value;
                });
              }
            });
          } else {
            // show error popup
            popup = PopupBox(
              title: 'Error',
              description: data['data']['data']['error'].contains("does not exist") ? "Business does not exist" : data['data']['data']['error'],
              type: PopupType.error,
            );
            popup.showPopup(context);
          }
        }
      });
    } finally {
      setState(() {
        sendingOTPLoading = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    errandiaBusinessViewController.reloadBusinesses();
    errandiaBusinessViewController.loadBusinessBranches(businessSlug);

    if (state == AppLifecycleState.resumed) {
      errandiaBusinessViewController.reloadBusinesses();
      errandiaBusinessViewController.loadBusinessBranches(businessSlug);
    }

    if (state == AppLifecycleState.detached) {
      errandiaBusinessViewController.reloadBusinesses();
      errandiaBusinessViewController.loadBusinessBranches(businessSlug);
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    print("bz data: ${widget.businessData}");
    print("current slug: ${widget.businessData['image']}");

    Widget _buildBusinessBranchesErrorWidget(String message, [VoidCallback? onReload]) {
      return !errandiaBusinessViewController.isLoading.value ? Container(
        height: Get.height * 0.9,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              onReload != null
                  ? ElevatedButton(
                onPressed: onReload,
                style: ElevatedButton.styleFrom(
                  primary: appcolor().mainColor,
                ),
                child: Text('Retry',
                  style: TextStyle(
                      color: appcolor().lightgreyColor
                  ),
                ),
              )
                  : const SizedBox(),
            ],
          ),
        ),
      ): buildLoadingWidget();
    }

    return WillPopScope(
      onWillPop: () async {
        errandiaBusinessViewController.reloadBusinesses();
        errandiaBusinessViewController.loadBusinessBranches(businessSlug);
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(
          Icons.arrow_back_ios,
            ),
            onPressed: () {
          Get.back();
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * 0.5,
                child: Text(
                  capitalizeAll(widget.businessData['name'] ?? ""),
                  style: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          actions: [
            IconButton(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                size: 30,
              ),
              color: appcolor().mediumGreyColor,
            ),
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
          ],
          iconTheme: IconThemeData(
            color: appcolor().mediumGreyColor,
            size: 30,
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
          },
        ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (widget.businessData['whatsapp'] != "" && widget.businessData['whatsapp'] != "whatsapp") ? SizedBox(
                width: Get.width * 0.45,
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
                              color: Colors.white,
                              fontSize: 10
                          ),
                        ),
                      ],
                    ),
                  ),
                  ontap: () async
                  {
                    print("whatsapp: ${widget.businessData['whatsapp']}");
                    launchWhatsapp(widget.businessData['whatsapp']);
                  },
                  color: appcolor().mainColor,
                ),
              ) : Container(),
              if (widget.businessData['whatsapp'] == "" || widget.businessData['whatsapp'] == "whatsapp")
                const Spacer(),
              SizedBox(
                width: Get.width * 0.45,
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
                          'Call ${widget.businessData['phone']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: appcolor().mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ontap: () {
                    launchCaller(widget.businessData['phone']);
                  },
                  color: appcolor().skyblueColor,
                ),
              ),

            ],
          ),
        ).paddingAll(12),

        body: SingleChildScrollView(
          // physics: AlwaysScrollableScrollPhysics(),
          // padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.sta,
            children: [
              SizedBox(
                height: Get.height * 0.3,
                width: Get.width,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/errandia_logo.png',
                  image: getImagePath(widget.businessData['image'].toString()),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/errandia_logo.png',
                      fit: BoxFit.contain,
                      width: double.infinity,
                    );
                  },
                )
              ),

              SizedBox(
                height: Get.height * 0.01,
              ),
              // shop name
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //
              //
              //     // divider
              //
              //                     ],
              // ).paddingSymmetric(
              //   horizontal: 15,
              //   vertical: 5,
              // ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  product_review_widget(widget.businessData),

                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                  ),

                  SizedBox(
                    height: Get.height * 0.01,
                  ),

                  if (profileController.userData.value['id'] ==
                      widget.businessData['user']['id'])
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.businessData['phone_verified'] == 0
                            ? Padding(
                          padding:
                          const EdgeInsets.only(right: 8),
                          child: Text(
                            "You're business is unverified!",
                            style: TextStyle(
                              fontSize: 13,
                              color: appcolor().redColor,
                            ),
                          ),
                        )
                            : Padding(
                          padding:
                          const EdgeInsets.only(right: 8),
                          child: Text(
                            "You're business is verified!",
                            style: TextStyle(
                              fontSize: 13,
                              color: appcolor().greenColor,
                            ),
                          ),
                        ),
                        widget.businessData['phone_verified'] == 1
                            ? const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 17,
                        )
                            : const Icon(Icons.info_outline,
                            color: Colors.red, size: 17),
                        const Spacer(),
                        // verify now link
                        widget.businessData['phone_verified'] == 0
                            ? InkWell(
                          onTap: () async {
                            // verify business
                            sendOTP(context);
                          },
                          child: Container(
                            height: Get.height * 0.03,
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: appcolor().mainColor,
                            ),
                            child: const Center(
                              child: Text(
                                'Verify Now',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ) : Container(),
                      ],
                    ),

                  if (profileController.userData.value['id'] ==
                      widget.businessData['user']['id'])
                    SizedBox(
                      height: Get.height * 0.02,
                    ),

                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height: Get.height * 0.01,
                  ),

                  // description of the shop
                  Text(
                    widget.businessData['description'] ?? "No description provided",
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  // follow us on social media
                  (widget.businessData['facebook']!="" && widget.businessData['instagram']!="") ? Row(
                    children: [
                      const Text('Follow us on social media'),
                      // fb
                      widget.businessData['facebook'] != "" ? InkWell(
                        onTap: ()async{
                          mlaunchUrl(widget.businessData['facebook']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: Icon(
                            FontAwesomeIcons.squareFacebook,
                            color: appcolor().bluetextcolor,
                          ),
                        ),
                      ): Container(),

                      // insta
                      widget.businessData['instagram'] != "" ? InkWell(
                        onTap: () async {
                          mlaunchUrl(widget.businessData['instagram']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.instagram,
                            color: Colors.pink,
                          ),
                        ),
                      ): Container(),
                    ],
                  ): Container(),
                ],
              ).paddingSymmetric(
                horizontal: 15,
                vertical: 5,
              ),

              // description text
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //
              //     ],
              // ).paddingSymmetric(
              //   horizontal: 0,
              //   vertical: 5,
              // ),

              SizedBox(
                height: Get.height * 0.01,
              ),
              // Divider(),

              // visit shop
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
                    var data = widget.businessData;
                    print("bz data: ${data}");

                    Get.to(() =>  VisitShop(
                      businessData: data
                    ));
                  },
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.shop,
                        color: appcolor().blueColor,
                        size: 18,
                      ),
                      Text(
                        '   Visit Shop',
                        style:
                            TextStyle(color: appcolor().blueColor, fontSize: 16),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: appcolor().bluetextcolor,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: Get.height * 0.025,
              ),
              Divider(),

              // business branches
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.buildingUser,
                        size: 20,
                      ),
                      SizedBox(
                        width: Get.width * 0.05,
                      ),
                      Obx(() => RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 15),
                          children: [
                            const TextSpan(text: 'Related Businesses  '),
                            TextSpan(
                              text: '(${errandiaBusinessViewController.total.value})',
                              style: TextStyle(color: appcolor().mediumGreyColor),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                  Divider(
                    color: appcolor().mainColor,
                    thickness: 1.5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    height: 280,
                    child: Obx(
                        () {
                          if (errandiaBusinessViewController.isLoading.value) {
                            return buildLoadingWidget();
                          } else if (errandiaBusinessViewController.isError.value) {
                            return _buildBusinessBranchesErrorWidget(
                              "An error occurred while fetching business branches",
                              () {
                                errandiaBusinessViewController.loadBusinessBranches(businessSlug);
                              },
                            );
                          } else if (errandiaBusinessViewController.itemList.isEmpty) {
                            return _buildBusinessBranchesErrorWidget(
                              "No business branches found"
                            );
                          } else {
                            return ListView.builder(
                              key: const PageStorageKey('businessBranches'),
                              controller: scrollController,
                              itemCount: errandiaBusinessViewController.isLoading.value
                                  ? errandiaBusinessViewController.itemList.length + 1
                                  : errandiaBusinessViewController.itemList.length,
                              itemBuilder: (context, index) {
                                 var data = errandiaBusinessViewController.itemList[index];
                                return InkWell(
                                  onTap: () {
                                    errandiaBusinessViewController.reloadBusinesses();
                                    errandiaBusinessViewController.loadBusinesses(data['slug']);
                                    Get.to(() {
                                      return errandia_business_view(
                                        key: UniqueKey(),
                                        businessData: data,
                                      );
                                    },
                                      preventDuplicates: false,
                                      transition: Transition.cupertino,
                                    );
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => errandia_business_view(businessData: data),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric( horizontal: 10),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: appcolor().greyColor,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                              ),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: 'assets/images/errandia_logo.png',
                                                image: getImagePath(data['image'].toString()),
                                                fit: BoxFit.contain,
                                                width: 60,
                                                imageErrorBuilder: (context, error, stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/errandia_logo.png',
                                                    fit: BoxFit.contain,
                                                    width: 60,
                                                  );
                                                },
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  capitalizeAll(data['name'] ?? ""),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                data['street'] != null ? Text(
                                                  data['street'],
                                                  style: TextStyle(
                                                    color: appcolor().mediumGreyColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ): const Text(
                                                  'No street provided',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ).paddingOnly(left: 10),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                Get.to(() => VisitShop(businessData: data));
                                              },
                                              icon: Icon(
                                                Icons.arrow_forward_ios_outlined,
                                                color: appcolor().bluetextcolor,
                                              ),
                                            ),
                                          ],
                                        ).paddingOnly(bottom: 10, top: 5),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                    )
                  ),
                ],
              ).paddingSymmetric(
                horizontal: 15,
                vertical: 3,
              ),

              //supplier review

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
              //           Get.to(() => Review_view());
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
              //                 child: Image.asset(Recently_item_List[2].avatarImage.toString()),
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
              //           itemCount: ui_23_item_list.length,
              //           itemBuilder: (context, index) {
              //             return Container(
              //               margin:
              //                   const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              //               height: Get.height * 0.2,
              //               color: Colors.white,
              //               width: Get.width * 0.2,
              //               child: Center(
              //                 child: Image.asset(ui_23_item_list[index].imagePath.toString())
              //               ),
              //             );
              //           },
              //         ),
              //       ),
              //       Container(
              //         padding: const EdgeInsets.only(bottom: 10),
              //         child: const Text(
              //           'Praesentium quo impedit eaque ut. Aperiam qui illum. Porro quis autem dolorum saepe dolor ipsa ut.',
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ).paddingOnly(
            top: 10,
            bottom: 20,
          ),
        ),
      ),
    );
  }
}

void errandia_view_bottomsheet() {
  Get.bottomSheet(
    isScrollControlled: true,
    // backgroundColor: Colors.white,
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: const Color(0xFFFFFFFF),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Icon(
            Icons.horizontal_rule,
            size: 25,
          ),
          // Text(index.toString()),
          // bottomSheetWidgetitem(
          //   title: 'Follow this shop',
          //   imagepath: 'assets/images/sidebar_icon/icon-profile-following.png',
          //   callback: () async {
          //     print('tapped');
          //     Get.back();
          //   },
          // ),
          bottomSheetWidgetitem(
            title: 'Call Suplier',
            imagepath: 'assets/images/sidebar_icon/icon-move.png',
            callback: () async {
              print('tapped');
              Get.back();
            },
          ),
          bottomSheetWidgetitem(
            title: 'Write a Review',
            imagepath: 'assets/images/sidebar_icon/icon-move.png',
            callback: () async {
              print('tapped');
              Get.back();
            },
          ),
          InkWell(
            hoverColor: Colors.grey,
            onTap: () {
              Get.back();
              Get.bottomSheet(
                isScrollControlled: true,
                Container(
                  color: Colors.white,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      const Icon(
                        Icons.horizontal_rule,
                        size: 25,
                      ),
                      Text(
                        'Report Shop'.tr,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: appcolor().mediumGreyColor,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: Get.height * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: appcolor().mediumGreyColor,
                              ),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'This is My Product'.tr,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                disabledBorder: InputBorder.none,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Why are you reporting this business'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            height: Get.height * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: appcolor().mediumGreyColor,
                              ),
                            ),
                            child: TextFormField(
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: ''.tr,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                disabledBorder: InputBorder.none,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width * 0.5,
                                height: Get.height * 0.06,
                                decoration: BoxDecoration(
                                  color: appcolor().redColor,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Submit Report'.tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.09,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Cancel'.tr,
                                  style: TextStyle(
                                    color: appcolor().mediumGreyColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            ],
                          ).paddingOnly(
                            top: 10,
                            bottom: 10,
                            right: 10,
                          ),
                        ],
                      ).paddingSymmetric(
                        horizontal: 15,
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  child: Image(
                    image: const AssetImage(
                      'assets/images/sidebar_icon/icon-trash.png',
                    ),
                    color: appcolor().redColor,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  'Report this shop',
                  style: TextStyle(fontSize: 16, color: appcolor().redColor),
                ),
              ],
            ).paddingSymmetric(vertical: 15),
          ),
        ],
      ).paddingSymmetric(horizontal: 15, vertical: 15,),
    ),

    enableDrag: true,
  );
}

Widget product_review_widget(Map<String, dynamic> data) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              capitalizeAll(data['name'] ?? ""),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            SizedBox(
              width: Get.width * 0.04,
            ),
            if (data['phone_verified'] == 1)
              Icon(
                Icons.verified_outlined,
                color: appcolor().blueColor,
              ),
            if (data['phone_verified'] == 0)
              Container()
          ],
        ),
        data['street'] != null
            ? Text(
          data['street'],
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        )
            : const Text(
          'No street provided',
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
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
