import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/Widgets/notification_row_widget.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/notifications/notifications_controller.dart';
import 'package:errandia/app/modules/notifications/notifications_view.dart';
import 'package:errandia/modal/Notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView>
    with WidgetsBindingObserver {
  late notifications_controller notifController;
  late home_controller homeController;

  @override
  void initState() {
    notifController = Get.put(notifications_controller());
    homeController = Get.put(home_controller());

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifController.fetchNotifications();
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      notifController.fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        homeController.fetchUnreadNotifications().then((_) {
          if (homeController.unreadNotificationsCount.value > 0) {
            notifController.fetchNotifications();
          }
        });
        Get.back();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            titleSpacing: 8,
            title: const Text("Notifications"),
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: appcolor().mediumGreyColor,
                fontSize: 20),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                homeController.fetchUnreadNotifications().then((_) {
                  if (homeController.unreadNotificationsCount.value > 0) {
                    notifController.fetchNotifications();
                  }
                });
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: appcolor().mediumGreyColor,
            ),
            actions: [
              // refresh button
              IconButton(
                onPressed: () {
                  notifController.reloadNotifications();
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 30,
                ),
                color: appcolor().mediumGreyColor,
              ),
            ],
          ),
          body: SafeArea(
            child: Obx(() {
              if (notifController.isNotificationLoading.isTrue &&
                  notifController.notificationList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (notifController.isNotificationError.isTrue &&
                  notifController.notificationList.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  child: buildErrorWidget(
                      message: "Error fetching notifications",
                      callback: () {
                        notifController.reloadNotifications();
                      }),
                );
              } else if (notifController.notificationList.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  child: buildErrorWidget(
                      message: "No notifications found",
                      callback: () {
                        notifController.reloadNotifications();
                      }),
                );
              } else {
                return ListView.separated(
                  itemCount: notifController.notificationList.length,
                  itemBuilder: (context, index) {
                    var notification = notifController.notificationList[index];
                    NotificationItem notif = NotificationItem(
                        title: notification['title'],
                        message: notification['message'],
                        date: notification['created_at'],
                        read: notification['read']);
                    return GestureDetector(
                        onTap: () {
                          Get.to(() => NotificationDetailView(
                              notifId: notification['id'],
                              title: notification['title'],
                              date: notification['created_at'],
                              message: notification['message']));
                        },
                        child: NotificationRowWidget(item: notif));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ).marginOnly(top: 10, bottom: 15);
              }
            }),
          )),
    );
  }
}
