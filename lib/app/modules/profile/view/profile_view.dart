import 'dart:convert';

import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/view/add_business_view.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/buiseness/view/visit_shop.dart';
import 'package:errandia/app/modules/categories/CategoryData.dart';
import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:errandia/app/modules/global/Widgets/myShopsDialog.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/view/add_product_view.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/profile/view/edit_profile_view.dart';
import 'package:errandia/app/modules/services/view/add_service_view.dart';
import 'package:errandia/modal/Shop.dart';
import 'package:errandia/utils/helper.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:errandia/app/modules/services/view/service_details_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile_view extends StatefulWidget {
  const Profile_view({super.key});

  @override
  State<Profile_view> createState() => _Profile_viewState();
}

class _Profile_viewState extends State<Profile_view>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController tabController =
      TabController(length: 3, vsync: this);
  late Map<String, dynamic> userData = {};
  late SharedPreferences prefs;
  late profile_controller profileController;
  late ScrollController scrollController;
  late ScrollController serviceScrollController;
  late ScrollController productScrollController;

  late Shop shop;

  // get user from sharedprefs
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user');
    // user image
    String? userProfileImg = prefs.getString('userProfileImg');
    if (userDataString != null) {
      print("user data: $userDataString");
      setState(() {
        userData = jsonDecode(userDataString);
        print("prof img: $userProfileImg");
        userData['photo'] =
            userProfileImg == null || userProfileImg.toString() == ""
                ? null
                : getImagePathWithSize(userProfileImg, width: 200, height: 200);
      });
    }
    print("user profile image: ${userData['photo']}");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    profileController = Get.put(profile_controller());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      profileController.reloadMyBusinesses();
      profileController.reloadMyProducts();
      profileController.reloadMyServices();
    });
    getUser();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 20) {
        profileController.loadMyBusinesses();
      }
    });

    serviceScrollController = ScrollController();
    serviceScrollController.addListener(() {
      if (serviceScrollController.position.pixels >=
          serviceScrollController.position.maxScrollExtent - 20) {
        profileController.loadMyServices();
      }
    });

    productScrollController = ScrollController();
    productScrollController.addListener(() {
      if (productScrollController.position.pixels >=
          productScrollController.position.maxScrollExtent - 20) {
        profileController.loadMyProducts();
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    serviceScrollController.dispose();
    productScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      profileController.reloadMyBusinesses();
      profileController.reloadMyProducts();
      profileController.reloadMyServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    String prod_list_size = profileController.product_list.isNotEmpty
        ? profileController.product_list.length.toString()
        : "";

    if (kDebugMode) {
      print("user: ${userData.toString}");
    }

    Widget _buildMyBusinessesErrorWidget(
        String message, VoidCallback onReload) {
      return !profileController.isLoading.value
          ? Container(
              height: Get.height * 0.9,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () => onReload(),
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
              ).paddingAll(10),
            )
          : buildLoadingWidget();
    }

    Widget _buildMyProductsErrorWidget(String message, VoidCallback onReload) {
      return !profileController.isProductLoading.value
          ? Container(
              height: Get.height * 0.9,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () => onReload(),
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
              ).paddingAll(10),
            )
          : buildLoadingWidget();
    }

    Widget _buildMyServicesErrorWidget(String message, VoidCallback onReload) {
      return !profileController.isServiceLoading.value
          ? Container(
              height: Get.height * 0.9,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () => onReload(),
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
              ).paddingAll(10),
            )
          : buildLoadingWidget();
    }

    Widget Buiseness_item_list() {
      return Obx(() {
        if (profileController.isLoading.value) {
          return buildLoadingWidget();
        } else if (profileController.isError.value) {
          return _buildMyBusinessesErrorWidget(
              'An error occurred while loading your businesses',
              profileController.reloadMyBusinesses);
        } else if (profileController.itemList.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Businesses Yet',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => add_business_view())?.then((_) {
                    business_controller().itemList.clear();
                    business_controller().loadBusinesses();
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: appcolor().mainColor,
                ),
                child: const Text(
                  'Add Business',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              profileController.reloadMyBusinesses();
            },
            child: GridView.builder(
                key: const PageStorageKey('my-businesses'),
                controller: scrollController,
                itemCount: profileController.isLoading.value
                    ? profileController.itemList.length + 1
                    : profileController.itemList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  childAspectRatio: 1 / 1.4,
                ),
                itemBuilder: (context, index) {
                  // return Text(index.toString());
                  final businessData = profileController.itemList[index];
                  return GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print("business item clicked: ${businessData['name']}");
                      }
                      Get.to(() =>
                          errandia_business_view(businessData: businessData));
                    },
                    child: errandia_widget(
                      imagePath: businessData['image'],
                      name: businessData['name'],
                      location: _formatAddress(businessData ?? {}),
                    ),
                  );
                }),
          );
        }
      });
    }

    Widget product_item_list() {
      return Obx(
        () {
          if (profileController.isProductLoading.value) {
            return buildLoadingWidget();
          } else if (profileController.isProductError.value) {
            return _buildMyProductsErrorWidget(
                'An error occurred while loading your products',
                profileController.reloadMyProducts);
          } else if (profileController.productItemList.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Products Yet',
                  style: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 16,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => add_product_view())?.then((_) {
                      profileController.loadMyProducts();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: appcolor().mainColor,
                  ),
                  child: const Text(
                    'Add Products',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                profileController.reloadMyProducts();
              },
              child: GridView.builder(
                key: UniqueKey(),
                controller: productScrollController,
                itemCount: profileController.isProductLoading.value
                    ? profileController.productItemList.length + 1
                    : profileController.productItemList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1 / 1.5,
                ),
                itemBuilder: (context, index) {
                  final item = profileController.productItemList[index];

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
                        location: item['shop'] != null
                            ? _formatAddress(item['shop'])
                            : "",
                      ));
                },
              ),
            );
          }
        },
      );
    }

    Widget Service_item_list() {
      return Obx(
        () {
          if (profileController.isServiceLoading.value) {
            return buildLoadingWidget();
          } else if (profileController.isServiceError.value) {
            return _buildMyServicesErrorWidget(
                'An error occurred while loading your services',
                profileController.reloadMyServices);
          } else if (profileController.serviceItemList.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Services Yet',
                  style: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 16,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => add_service_view())?.then((_) {
                      profileController.loadMyServices();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: appcolor().mainColor,
                  ),
                  child: const Text(
                    'Add Services',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                profileController.reloadMyServices();
              },
              child: GridView.builder(
                key: UniqueKey(),
                controller: serviceScrollController,
                itemCount: profileController.isServiceLoading.value
                    ? profileController.serviceItemList.length + 1
                    : profileController.serviceItemList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1 / 1.5,
                ),
                itemBuilder: (context, index) {
                  final item = profileController.serviceItemList[index];
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
                      location: item['shop'] != null
                          ? _formatAddress(item['shop'])
                          : "",
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    }

    return Scaffold(
        body: Column(
      children: [
        Container(
          height: Get.height * 0.323,
          color: appcolor().mainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // profile picture container
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 2,
                      ),
                    ),
                    onPressed: () {
                      if (kDebugMode) {
                        print("edit profile");
                      }
                      Get.to(() => const edit_profile_view())?.then((_) {
                        getUser();
                      });
                    },
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 5, vertical: 0),
                ],
              ),
              Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Container(
                      // height: Get.height * 0.13,
                      width: Get.width * 0.22,
                      // color: Colors.redAccent,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: userData['photo'] != null
                            ? Image.network(userData['photo'],
                                fit: BoxFit.cover, errorBuilder:
                                    (BuildContext context, Object exception,
                                        StackTrace? stackTrace) {
                                return Center(
                                    child: Text(
                                  userData["name"] != null
                                      ? getFirstLetter(userData['name'])
                                      : "",
                                  style: const TextStyle(
                                    color: Color(0xffff0000),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ));
                              })
                            : Center(
                                child: Text(
                                userData["name"] != null
                                    ? getFirstLetter(userData['name'])
                                    : "",
                                style: const TextStyle(
                                  color: Color(0xffff0000),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                      ),
                    ),
                  ),

                  // Image.network(
                  //   getImagePath(userData['photo'] ?? ""),
                  //   height: Get.height * 0.13,
                  //   width: Get.width * 0.27,
                  //   fit: BoxFit.cover,
                  //   key: UniqueKey(),
                  // ) : Center(
                  //     child: Text(
                  //       getFirstLetter(userData['name']),
                  //       style: const TextStyle(
                  //         color: Color(0xffff0000),
                  //         fontSize: 40,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     )
                  // ),
                  // Align(
                  //   alignment: AlignmentDirectional.topEnd,
                  //   child: SizedBox(
                  //     width: Get.width * 0.3,
                  //     height: Get.height * 0.13,
                  //     // color: Colors.redAccent,
                  //   ),
                  // ),
                  // Positioned(
                  //   top: -8.0,
                  //   right: 12.0,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: InkWell(
                  //       onTap: () {
                  //         if (kDebugMode) {
                  //           print("edit profile");
                  //         }
                  //         Get.to(() => const edit_profile_view())?.then((_) {
                  //           getUser();
                  //         });
                  //       },
                  //       customBorder: const CircleBorder(),
                  //       splashColor: Colors.red,
                  //       child: const Icon(
                  //         Icons.edit,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              // profile name container
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  userData['name'] != null
                      ? capitalizeAll(userData['name'])
                      : "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              Spacer(),
              // show user email with edit rounded button
              Container(
                margin: const EdgeInsets.only(
                  top: 5,
                  left: 15,
                  right: 3,
                  bottom: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (userData['email'] != null && userData['email'] != "")
                        const Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 15,
                        ),

                        if (userData['email'] == null || userData['email'] == "" && userData['phone'] != null && userData['phone'] != "")
                          const Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 15,
                          ),

                        const SizedBox(
                          width: 5,
                        ),

                        if (userData['email'] != null && userData['email'] != "")
                        Text(
                          userData['email'] ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),

                        if (userData['email'] == null || userData['email'] == "" && userData['phone'] != null && userData['phone'] != "")
                        Text(
                          userData['phone'] ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        backgroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: appcolor().mainColor,
                        ),
                        fixedSize: const Size(80, 20),
                      ),
                      onPressed: () {
                        if (kDebugMode) {
                          print("edit profile");
                        }
                        Get.to(() => const edit_profile_view())?.then((_) {
                          getUser();
                        });
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: appcolor().mainColor
                        ),
                      ),
                    ).paddingSymmetric(horizontal: 5, vertical: 0),
                  ],
                ),
              ),

              // profile location
              // const Text(
              //   'Buea, South West Region, Cameroon',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 13,
              //   ),
              // ),
              // details container
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 10,
              //     vertical: 20,
              //   ),
              //   margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              //   height: Get.height * 0.15,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: Colors.white,
              //   ),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       details_container_item_widget(
              //         'Subscriber',
              //         'assets/images/sidebar_icon/icon-profile-subscribers.png',
              //         2,
              //       ),
              //       details_container_item_widget(
              //         'Following',
              //         'assets/images/sidebar_icon/icon-profile-following.png',
              //         2,
              //       ),
              //       details_container_item_widget(
              //         'Errands',
              //         'assets/images/sidebar_icon/icon-profile-errands.png',
              //         2,
              //       ),
              //       details_container_item_widget(
              //         'Reviews',
              //         'assets/images/sidebar_icon/icon-reviews.png',
              //         2,
              //       ),
              //     ],
              //   ),
              // ),

              //
            ],
          ).paddingOnly(top: 15),
        ),

        // tab bar
        Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: appcolor().greyColor,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                // height: Get.height * 0.07,
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
                  labelColor: appcolor().darkBlueColor,
                  tabs: const [
                    Tab(
                      text: "Products",
                      // tabController.index == 0
                      //     ? "Products ($prod_list_size)"
                      //     : "Product
                    ),
                    Tab(
                      text: "Services",
                    ),
                    Tab(
                      text: "Businesses",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // tab bar view
        Expanded(
          child: Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 15),
            // height: Get.height * 0.2,
            child: TabBarView(
              controller: tabController,
              children: [
                product_item_list(),
                Service_item_list(),
                Buiseness_item_list()
              ],
            ),
          ),
        ),
        SizedBox(
          height: Get.height * 0.015,
        ),
      ],
    ));
  }
}

Widget details_container_item_widget(
  String title,
  String imagePath,
  int count,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Image(
        image: AssetImage(imagePath),
        height: Get.height * 0.03,
        fit: BoxFit.fill,
        color: appcolor().mediumGreyColor,
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          title,
        ),
      ),
      Text(count.toString()),
    ],
  );
}

Widget noProductsFound() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    margin: const EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: Get.height * 0.07,
          child: const Icon(
            Icons.warning,
            color: Colors.orange,
            size: 40,
          ),
        ),
        const Text(
          'No Products Found',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: const Text(
            'You have not added any product to your businesses yet.',
            textAlign: TextAlign.center,
          ),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () {},
                text: 'Contact Us',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
              const TextSpan(
                text: ' for assistance.',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget accountSuspended() {
  return Container(
    // height: Get.height,

    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    margin: const EdgeInsets.only(
      top: 10,
    ),
    decoration: BoxDecoration(
      color: appcolor().pinkColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: Get.height * 0.07,
          child: const Image(
            image: AssetImage(
              'assets/images/account_suspended.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        Text(
          'ACCOUNT SUSPENDED',
          style: TextStyle(
              color: appcolor().redColor,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        const Text(
          'Sorry your account has been . While your account is suspended, You cannot add products, services, businesses nor carryout transactions on Errand.',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16),
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () {},
                text: 'Contact Us',
                style: TextStyle(
                    color: appcolor().bluetextcolor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              TextSpan(
                text: ' for more details',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
