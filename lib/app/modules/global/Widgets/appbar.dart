import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/app/modules/notifications/notifications_list_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../constants/color.dart';

home_controller homeController = Get.put(home_controller());
Widget mywidget = home_controller().atbusiness.value == false
    ? Container()
    : IconButton(
        onPressed: () {},
        icon: Icon(
          FontAwesomeIcons.arrowDownShortWide,
          textDirection: TextDirection.rtl,
        ),
        color: appcolor().mediumGreyColor,
      );

AppBar appbar() {
  homeController.loadIsLoggedIn();
  homeController.fetchUnreadNotifications();
  homeController.hasUnreadNotifications();

  print(
      "unreadNotificationsCount: ${homeController.unreadNotificationsCount.value}");
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        InkWell(
          onTap: () {
            Get.offAll(() => Home_view());
          },
          child: Image(
            image:
                const AssetImage('assets/images/icon-errandia-logo-about.png'),
            width: Get.width * 0.3,
          ),
        ),
        const Spacer(),
        Obx(() => homeController.loggedIn.value
            ? Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => const NotificationsView());
                    },
                    icon: const Icon(
                      Icons.notifications,
                      size: 30,
                    ),
                    color: appcolor().mediumGreyColor,
                  ),
                  Obx(() => homeController.hasUnread.value
                      ? Positioned(
                          right: 13,
                          top: 11,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 8,
                              minHeight: 8,
                            ),
                            child: const Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container()),
                ],
              )
            : Container()),
      ],
    ),

    iconTheme: IconThemeData(
      color: appcolor().mediumGreyColor,
      size: 30,
    ),
    // actions: [
    //   // Obx(() {
    //   //  return mywidget;
    //   // }),
    //   IconButton(
    //     onPressed: () {},
    //     icon: Icon(
    //       Icons.notifications,
    //       size: 30,
    //     ),
    //     color: appcolor().mediumGreyColor,
    //   ),
    //   IconButton(
    //     onPressed: () {},
    //     icon: Icon(
    //       Icons.settings,
    //       size: 30,
    //     ),
    //     color: appcolor().mediumGreyColor,
    //   ),
    //   IconButton(
    //     onPressed: () {
    //       homecontroller.openDrawer();
    //     },
    //     icon: Icon(
    //       Icons.more_horiz_outlined,
    //       size: 30,
    //     ),
    //     color: appcolor().mediumGreyColor,
    //   ),
    // ],
  );
}

AppBar titledAppBar(String title, List<Widget>? actions) {
  return AppBar(
    backgroundColor: Colors.white,
    // automaticallyImplyLeading: false,
    elevation: 1,
    title: Text(
      title,
      style: TextStyle(
        color: appcolor().mediumGreyColor,
        fontSize: 20,
      ),
    ),
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: appcolor().mediumGreyColor,
      ),
    ),
    iconTheme: IconThemeData(
      color: appcolor().mediumGreyColor,
      size: 30,
    ),
    actions: actions,
  );
}
