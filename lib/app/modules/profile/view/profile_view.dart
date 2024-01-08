import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// profile_controller profilecontroller= Get.put(profile_controller());

class Profile_view extends StatefulWidget {
  const Profile_view({super.key});

  @override
  State<Profile_view> createState() => _Profile_viewState();
}

class _Profile_viewState extends State<Profile_view>
    with TickerProviderStateMixin {
  late final TabController tabController =
      TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    String prod_list_size = profile_controller().product_list.length > 0
        ? profile_controller().product_list.length.toString()
        : "";

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
              Container(
                // child: Image(image: AssetImage(''),),
                height: Get.height * 0.12,
                width: Get.width * 0.27,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image(
                  image: AssetImage(
                    'assets/images/profile_image.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),

              // profile name container
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  'Profile Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // profile location
              Container(
                child: Text(
                  'Buea, South West Region, Cameroo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
              // details container
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                margin: EdgeInsets.only(top: 15, left: 15, right: 15),
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
                  unselectedLabelStyle: TextStyle(
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
                  tabs: [
                    Tab(
                      text: tabController.index == 0
                          ? "Product " + prod_list_size
                          : "Product",
                    ),
                    Tab(
                      text: "Services",
                    ),
                    Tab(
                      text: "Bussiness ",
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
            padding: EdgeInsets.symmetric(horizontal: 15),
            // height: Get.height * 0.2,
            child: TabBarView(
              controller: tabController,
              children: [
                profile_controller().product_list.length < 0
                    ? product_item_list()
                    : accoutSuspended(),
                profile_controller().service_list.length > 0
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
                            child: Text(
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
                profile_controller().Buiseness_list.length > 0
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
                            child: Text(
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
  String imagepath,
  int count,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          child: Image(
        image: AssetImage(imagepath),
        height: Get.height * 0.03,
        fit: BoxFit.fill,
        color: appcolor().mediumGreyColor,
      )),
      Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Text(
          title,
        ),
      ),
      Container(
        child: Text(count.toString()),
      ),
    ],
  );
}

Widget product_item_list() {
  return GridView.builder(
    itemCount: profile_controller().product_list.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      childAspectRatio: 1 / 1.5,
    ),
    itemBuilder: (context, index) {
      return profile_controller().product_list[index];
    },
  );
}

Widget Service_item_list() {
  return GridView.builder(
    itemCount: profile_controller().service_list.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      childAspectRatio: 1 / 1.5,
    ),
    itemBuilder: (context, index) {
      return profile_controller().service_list[index];
    },
  );
}

Widget Buiseness_item_list() {
  return GridView.builder(
      itemCount: profile_controller().Buiseness_list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        childAspectRatio: 1 / 1.8,
      ),
      itemBuilder: (context, index) {
        // return Text(index.toString());
        return business_controller().businessList[index];
      });
}

Widget accoutSuspended() {
  return Container(
    // height: Get.height,

    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    margin: EdgeInsets.only(
      top: 10,
    ),
    decoration: BoxDecoration(
      color: appcolor().pinkColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: Get.height * 0.07,
          child: Image(
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
        Container(
          child: Text(
            'Sorry your account has been . While your account is suspended, You cannot add products, services, businesses nor carryout transactions on Errand.',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16),
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
