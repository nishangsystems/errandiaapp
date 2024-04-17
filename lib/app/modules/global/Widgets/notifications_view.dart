import 'package:errandia/app/modules/global/Widgets/notification_row_widget.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          titleSpacing: 8,
          title: const Text("Notifications"),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: appcolor().mediumGreyColor,
          ),
        ),
        body: SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                height: Get.height * 0.8,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: false,
                  scrollDirection: Axis.vertical,
                  primary: false,
                  itemBuilder: (context, index) {
                    return const NotificationRowWidget(
                      title: 'Errandia Info Center',
                      body: 'Please make sure never to share your password with anyone',
                      time: '2 hours ago',
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}