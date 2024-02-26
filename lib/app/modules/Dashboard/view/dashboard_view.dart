import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_view.dart';
import 'package:errandia/app/modules/global/Widgets/account_suspended_widget.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/manage_review/view/manage_review_view.dart';
import 'package:errandia/app/modules/products/view/add_product_view.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/services/view/manage_service_view.dart';
import 'package:errandia/app/modules/sms_plan/view/sms_plan_view.dart';
import 'package:errandia/app/modules/subscribers/view/subscriber_view.dart';
import 'package:errandia/app/modules/subscription/view/manage_subscription_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../buiseness/view/manage_business_view.dart';
import '../../global/Widgets/bottomsheet_item.dart';
import '../../products/view/manage_products_view.dart';

profile_controller profileController = Get.put(profile_controller());

class dashboard_view extends StatelessWidget {
  const dashboard_view({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        profileController.reloadMyProducts();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfffafafa),
        floatingActionButton: InkWell(
          onTap: () {
            custombottomsheet(context);
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: appcolor().skyblueColor,
            ),
            child: Icon(
              Icons.add,
              size: 30,
              color: appcolor().mainColor,
            ),
          ),
        ),
        appBar: appbar(),
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
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, bottom: 5, top: 7),
                child: Text(
                  'My Dashboard',
                  style: TextStyle(
                      color: appcolor().mainColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: Get.height * 0.40,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1 / 1.3,
                  crossAxisCount: 3,
                  children: [
                    dashboard_widget(
                      Imagepath: 'assets/images/sidebar_icon/icon-company.png',
                      title: 'Manage Businesses',
                      belowtext: '0 Businesses',
                      callback: () {
                        // Get.offAll(Home_view());
                        Get.to(() => manage_business_view());
                      },
                    ),
                    dashboard_widget(
                      Imagepath:
                          'assets/images/sidebar_icon/icon-manage-products.png',
                      title: 'Manage Products',
                      belowtext: '0 Products',
                      callback: () {
                        // Get.back();
                        Get.to(() => manage_product_view());
                      },
                    ),
                    dashboard_widget(
                      Imagepath: 'assets/images/sidebar_icon/services.png',
                      title: 'Manage Services',
                      belowtext: '0 Services',
                      callback: () {
                        // Get.back();
                        Get.to(() => manage_service_view());
                      },
                    ),
                    dashboard_widget(
                      Imagepath:
                          'assets/images/sidebar_icon/icon-profile-errands.png',
                      title: 'Errands',
                      belowtext: '0 Errands',
                      callback: () {
                        Get.to(() => errand_view());
                      },
                    ),
                    dashboard_widget(
                      Imagepath: 'assets/images/sidebar_icon/icon-reviews.png',
                      title: 'Reviews',
                      belowtext: '0 Reviews',
                      callback: () {
                        Get.to(()=>manage_review_view());
                      },
                    ),
                    dashboard_widget(
                      Imagepath:
                          'assets/images/sidebar_icon/icon-profile-subscribers.png',
                      title: 'Subscribers',
                      belowtext: '0 Subscribers',
                      callback: () {
                        Get.to(() => subscriber_view());
                      },
                    ),
                    // dashboard_widget(
                    //   Imagepath:
                    //       'assets/images/sidebar_icon/icon-profile-following.png',
                    //   title: 'Following',
                    //   belowtext: '0 Following',
                    //   callback: () {
                    //     Get.to(() => const following_view());
                    //   },
                    // ),
                  ],
                ),
              ),
              const Divider(),
              SizedBox(
                height: Get.height * 0.2,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 1,
                  childAspectRatio: 1 / 1.3,
                  crossAxisCount: 3,
                  children: [
                    dashboard_widget(
                        Imagepath:
                            'assets/images/sidebar_icon/icon-business-branches.png',
                        title: 'Business Branches',
                        belowtext: '0 Branches',
                        callback: () {}),
                    dashboard_widget(
                        Imagepath: 'assets/images/sidebar_icon/icon-manager.png',
                        title: 'Branch Managers',
                        belowtext: '0 Managers',
                        callback: () {}),
                  ],
                ),
              ),
              const Divider(),
              SizedBox(
                height: Get.height * 0.2,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 1,
                  childAspectRatio: 1 / 1.3,
                  crossAxisCount: 3,
                  children: [
                    dashboard_widget(
                        Imagepath:
                            'assets/images/sidebar_icon/icon-dashboard-subscription-plan.png',
                        title: 'Subscription',
                        belowtext: 'Ongoing',
                        callback: () {
                          Get.to(()=> subscription_view());
                        }),
                    dashboard_widget(
                        Imagepath:
                            'assets/images/sidebar_icon/icon-dashboard-smsplan.png',
                        title: 'SMS Plan',
                        belowtext: 'No Plan',
                        callback: () {
                          Get.to(sms_plan_view());
                        }),
                    dashboard_widget(
                        Imagepath:
                            'assets/images/sidebar_icon/icon-dashboard-my-profile.png',
                        title: 'My Profile',
                        belowtext: '0 complete',
                        callback: () {}),
                  ],
                ),
              ),
            ],
          ),
        ).paddingSymmetric(horizontal: 10),
        // body: CustomScrollView(
        //   slivers: <Widget>[
        //     SliverGrid.count(
        //       crossAxisCount: 3,
        //       children: [
        //         Container(
        //           height: 100,
        //           width: 100,
        //           color: Colors.red,
        //         ),
        //       ],
        //     ),
        //     SliverPadding(
        //       padding: EdgeInsets.symmetric(
        //         vertical: 10,
        //       ),
        //     ),
        //     SliverGrid.count(
        //       crossAxisCount: 3,
        //       children: [
        //         Container(
        //           height: 100,
        //           width: 100,
        //           color: Colors.red,
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

Widget dashboard_widget({
  required String Imagepath,
  required String title,
  required String belowtext,
  required Callback callback,
}) {
  return InkWell(
    onTap: callback,
    child: Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),

        // height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 45,
              child: Image(
                image: AssetImage(
                  Imagepath,
                ),
                color: appcolor().mediumGreyColor,
                fit: BoxFit.fill,
              ),
            ),
            // SizedBox(height: Get.height,)
            Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      color: appcolor().mainColor,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  belowtext,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void custombottomsheet(BuildContext context) {
  Get.bottomSheet(
    // backgroundColor: Colors.white,
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          Icon(
            Icons.horizontal_rule,
            size: 25,
          ),
          bottomSheetWidgetitem(
            title: 'Add New Errand',
            imagepath: 'assets/images/sidebar_icon/icon-profile-errands.png',
            callback: () async {
              print('tapped');
              Get.back();
              showDialog(
                  context: context,
                  builder: (context) {
                    return account_suspended_widget();
                  });
            },
          ),
          bottomSheetWidgetitem(
            title: 'Add New Product',
            imagepath: 'assets/images/sidebar_icon/icon-manage-products.png',
            callback: () {
              Get.back();
              Get.to(() => add_product_view())?.then((_) {
                profile_controller().reloadMyProducts();
              });
            },
          ),
          bottomSheetWidgetitem(
            title: 'Add New Service',
            imagepath: 'assets/images/sidebar_icon/services.png',
            callback: () {},
          ),
          bottomSheetWidgetitem(
            title: 'Add New Business',
            imagepath: 'assets/images/sidebar_icon/create_shop.png',
            callback: () {},
          ),
          bottomSheetWidgetitem(
            title: 'Add New Manager',
            imagepath: 'assets/images/sidebar_icon/icon-manager.png',
            callback: () {},
          ),
        ],
      ),
    ),

    enableDrag: true,
  );
}
