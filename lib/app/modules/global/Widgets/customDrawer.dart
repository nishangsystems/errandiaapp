import 'package:errandia/app/modules/Dashboard/view/dashboard_view.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:errandia/app/modules/errands/view/run_an_errand_1.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/setting/view/setting_view.dart';
import 'package:errandia/app/modules/subscription/view/manage_subscription_view.dart';
import 'package:errandia/auth_services/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../buiseness/view/add_business_view.dart';
import '../../buiseness/view/businesses_view.dart';
import '../../buiseness/view/manage_business_view.dart';
import '../../errands/view/manage_errands_page.dart';
import '../../home/controller/home_controller.dart';

class CustomEndDrawer extends StatelessWidget {
  final VoidCallback onBusinessCreated;
  CustomEndDrawer({super.key, required this.onBusinessCreated});

  final padding = const EdgeInsets.symmetric(horizontal: 10);
  final home_controller homeController = Get.put(home_controller());

  @override
  Widget build(BuildContext context) {
    final profile_controller profileController = Get.put(profile_controller());

    return WillPopScope(
      onWillPop: () async {
        homeController.closeDrawer();
        profileController.reloadMyBusinesses();
        return false;
      },
      child: Drawer(
        shadowColor: Colors.grey,
        key: UniqueKey(),
        child: ListView(
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            Container(
              padding: padding + const EdgeInsets.symmetric(horizontal: 8),
              // height: Get.height * 0.2,
              child: Text(
                'Explore Errandia',
                style: TextStyle(
                  color: appcolor().mainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Obx(() => homeController.loggedIn.value
                ? drawerItemWidget(
                    text: 'Create Business',
                    imagePath: 'assets/images/sidebar_icon/create_shop.png',
                    callback: () {
                      Get.back();
                      Get.to(() => add_business_view())?.then((_) {
                        onBusinessCreated();
                        profileController.reloadMyBusinesses();
                      });
                    },
                  )
                : drawerItemWidget(
                    text: 'Businesses',
                    imagePath: 'assets/images/sidebar_icon/create_shop.png',
                    callback: () {
                      Get.to(() => Businesses_View());
                    },
                  )),
            Obx(() => !homeController.loggedIn.value
                ? drawerItemWidget(
                    text: 'Search',
                    imagePath: 'assets/images/sidebar_icon/create_shop.png',
                    callback: () {
                      Get.to(() => const run_an_errand_1());
                    },
                  )
                : Container()),
            Obx(() => homeController.loggedIn.value
                ? drawerItemWidget(
                    text: 'My Dashboard',
                    imagePath: 'assets/images/sidebar_icon/dashboard.png',
                    callback: () {
                      Get.back();
                      Get.to(() => const dashboard_view());
                    },
                  )
                : Container()),
            Obx(() => homeController.loggedIn.value
                ? Divider(
                    color: appcolor().mediumGreyColor,
                  )
                : Container()),
            Obx(() => homeController.loggedIn.value
                ? drawerItemWidget(
                    text: 'Manage Businesses',
                    imagePath: 'assets/images/sidebar_icon/icon-company.png',
                    callback: () {
                      Get.back();
                      Get.to(() => manage_business_view(), popGesture: true);
                    },
                  )
                : Container()),
            Obx(() => homeController.loggedIn.value
                ? drawerItemWidget(
                    text: 'Errands',
                    imagePath:
                        'assets/images/sidebar_icon/icon-profile-errands.png',
                    callback: () {
                      Get.back();
                      Get.to(() => const ManageErrandsPage());
                    },
                  )
                : Container()),
            // Obx(() => homeController.loggedIn.value
            //     ? drawerItemWidget(
            //         text: 'Following',
            //         imagePath:
            //             'assets/images/sidebar_icon/icon-profile-following.png',
            //         callback: () {
            //           Get.back();
            //           Get.to(() => const following_view());
            //         },
            //       )
            //     : Container()),
            // Obx(() => homeController.loggedIn.value
            //     ? drawerItemWidget(
            //         text: 'Reviews',
            //         imagePath:
            //             'assets/images/sidebar_icon/icon-profile-reviews.png',
            //         callback: () {
            //           Get.back();
            //           Get.to(() => manage_review_view());
            //         })
            //     : Container()),
            Obx(() => homeController.loggedIn.value
                ? drawerItemWidget(
                    text: 'Subscription',
                    imagePath:
                        'assets/images/sidebar_icon/icon-profile-subscribers.png',
                    callback: () {
                      Get.back();
                      // Get.to(() => subscriber_view());
                      Get.to(
                        () => const subscription_view(),
                        transition: Transition.fade,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  )
                : Container()),
            Obx(() => homeController.loggedIn.value
                ? const SizedBox(
                    height: 5,
                  )
                : Container()),
            const Divider(),
            Obx(() => homeController.loggedIn.value
                ? drawerItemWidget(
                    text: 'Settings',
                    imagePath: 'assets/images/sidebar_icon/icon-settings.png',
                    callback: () {
                      Get.back();
                      Get.to(() => setting_view());
                    },
                  )
                : Container()),
            Obx(() =>
                homeController.loggedIn.value ? const Divider() : Container()),
            Obx(() => homeController.loggedIn.value
                ? drawerItemWidget(
                    text: 'Logout',
                    imagePath: 'assets/images/sidebar_icon/icon-logout.png',
                    callback: () async {
                      await AuthService.logout();
                    },
                  )
                : drawerItemWidget(
                    text: 'Register/Login',
                    imagePath: 'assets/images/sidebar_icon/icon-logout.png',
                    callback: () {
                      // Get.back();
                      Get.to(() => const signin_view());
                    },
                  )),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}

Widget drawerItemWidget({
  required String text,
  required String imagePath,
  required Callback callback,
  final hovercolor = Colors.white70,
}) {
  return InkWell(
    onTap: callback,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        children: [
          Container(
            height: Get.height * 0.025,
            child: Image(
              image: AssetImage(imagePath),
              fit: BoxFit.fill,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: Get.width * 0.05,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
