
// notification detail view
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/notifications/notifications_controller.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationDetailView extends StatefulWidget {
  final notifId;
  final String title;
  final String date;
  final message;

  const NotificationDetailView({Key? key, this.notifId, required this.title, required this.date, this.message}) : super(key: key);

  @override
  _NotificationDetailViewState createState() => _NotificationDetailViewState();
}

class _NotificationDetailViewState extends State<NotificationDetailView> with WidgetsBindingObserver {
  late notifications_controller notifController;

  @override
  void initState() {
    notifController = Get.put(notifications_controller());

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifController.fetchNotificationDetail(widget.notifId);
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
      notifController.fetchNotificationDetail(widget.notifId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 2,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: appcolor().mediumGreyColor,
            fontSize: 20),
        automaticallyImplyLeading: false,

        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: appcolor().mediumGreyColor,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Message:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: appcolor().mediumGreyColor,
              ),
            ),
            RichText(
              text: TextSpan(
                text: widget.message,
                style: TextStyle(
                  color:  appcolor().darkBlueColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // published on
            Text(
              'Publish Date:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: appcolor().mediumGreyColor,
              ),
            ),
            Text(
              formatDateString(widget.date),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: appcolor().darkBlueColor
              ),
            ),
          ]
        )
      ),
    );
  }
}