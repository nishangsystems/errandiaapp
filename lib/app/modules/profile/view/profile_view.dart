import 'dart:convert';

import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/categories/CategoryData.dart';
import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/profile/view/edit_profile_view.dart';
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

class _Profile_viewState extends State<Profile_view> with TickerProviderStateMixin {
  late final TabController tabController =
      TabController(length: 3, vsync: this);
  late Map<String, dynamic> userData = {};
  late SharedPreferences prefs;

  // get user from sharedprefs
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user');
    if (userDataString != null) {
      print("user data: $userDataString");
      setState(() {
        userData = jsonDecode(userDataString);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    String prod_list_size = profile_controller().product_list.isNotEmpty
        ? profile_controller().product_list.length.toString()
        : "";

    if (kDebugMode) {
      print("user: ${userData.toString}");
    }

    return Scaffold(
        body: Column(
      children: [
        Container(
          // height: Get.height * 0.45,
          height: 320,
          color: appcolor().mainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // profile picture container
              Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Container(
                      height: Get.height * 0.13,
                      width: Get.width * 0.27,
                      // color: Colors.redAccent,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child:
                          userData['profile'] == null ? Image.network(
                            userData['profile'] ?? "",
                            height: Get.height * 0.13,
                            width: Get.width * 0.27,
                            fit: BoxFit.cover,
                          ) : Center(
                            child: Text(
                              getFirstLetter(userData['name']),
                              style: const TextStyle(
                                color: Color(0xffff0000),
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: SizedBox(
                      width: Get.width * 0.3,
                      height: Get.height * 0.13,
                      // color: Colors.redAccent,

                    ),
                  ),
                  Positioned(
                    top: -8.0,
                    right: 12.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          if (kDebugMode) {
                            print("edit profile");
                          }
                          Get.to(() => edit_profile_view());
                        },
                        customBorder: const CircleBorder(),
                        splashColor: Colors.red,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // profile name container
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                child:  Text(
                    userData['name'] != null ? capitalizeAll(userData['name']) : "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,

                  ),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                height: Get.height * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    details_container_item_widget(
                      'Subscriber',
                      'assets/images/sidebar_icon/icon-profile-subscribers.png',
                      2,
                    ),
                    details_container_item_widget(
                      'Following',
                      'assets/images/sidebar_icon/icon-profile-following.png',
                      2,
                    ),
                    details_container_item_widget(
                      'Errands',
                      'assets/images/sidebar_icon/icon-profile-errands.png',
                      2,
                    ),
                    details_container_item_widget(
                      'Reviews',
                      'assets/images/sidebar_icon/icon-reviews.png',
                      2,
                    ),
                  ],
                ),
              ),

              //
            ],
          ).paddingSymmetric(vertical: 15),
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
                      text: "Business",
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
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            // height: Get.height * 0.2,
            child: TabBarView(
              controller: tabController,
              children: [
                profile_controller().product_list.isNotEmpty
                    ? product_item_list()
                    : noProductsFound(),
                profile_controller().service_list.isNotEmpty
                    ? Service_item_list()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Services Yet',
                            style: TextStyle(
                              color: appcolor().mediumGreyColor,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Add Services',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                profile_controller().Buiseness_list.isNotEmpty
                    ? Buiseness_item_list()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Business Yet',
                            style: TextStyle(
                              color: appcolor().mediumGreyColor,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Add Business',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
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

Widget product_item_list() {
  return GridView.builder(
    itemCount: profile_controller().product_list.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      childAspectRatio: 1 / 1.5,
    ),

    itemBuilder: (context, index) {
      final item = Recently_item_List[index];

      return GestureDetector(
        onTap: () {
          if (kDebugMode) {
            print("product item clicked: ${item.name}");
          }
          Get.to(() => Product_view(item: item));
        },
        child: profile_controller().product_list[index],
      );
    },
  );
}

Widget Service_item_list() {
  return GridView.builder(
    itemCount: profile_controller().service_list.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      childAspectRatio: 1 / 1.5,
    ),
    itemBuilder: (context, index) {
      final item = profile_controller().service_list[index];
      return GestureDetector(
        onTap: () {
          if (kDebugMode) {
            print("service item: ${item.name}");
          }
          Get.to(() => ServiceDetailsView(service: item));
        },
        child: profile_controller().service_list[index],
      );
    },
  );
}

Widget Buiseness_item_list() {
  return GridView.builder(
      itemCount: profile_controller().Buiseness_list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        childAspectRatio: 1 / 1.8,
      ),
      itemBuilder: (context, index) {
        // return Text(index.toString());
        return business_controller().businessList[index];
      });
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
