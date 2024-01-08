import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class notification_setting_view extends StatelessWidget {
  notification_setting_view({super.key});
  notification_controller controller = Get.put(notification_controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notification',
          style: TextStyle(
            color: appcolor().mediumGreyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.arrow_back_ios,
            color: appcolor().mediumGreyColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            notification_widget('New Subscriber', 0),
            notification_widget('New Review', 1),
            notification_widget('New Enquiry', 2),
            notification_widget('New Errand', 3),
            notification_widget('Subscription Expiring', 4),
            Text(
              'Business Notification',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            notification_widget('New Products Added', 5),
            Container(
              width: Get.width * 0.8,
              child: Text(
                'Notify subscribers when I add new products to my shop',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontSize: 12,
                ),
              ),
            ),
            notification_widget('New Service Added', 6),
            Container(
              width: Get.width * 0.8,
              child: Text(
                'Notify subscribers when I add new services to my shop',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontSize: 12,
                ),
              ),
            ),
            notification_widget('Submitted Errands', 7),
            Container(
              width: Get.width * 0.8,
              child: Text(
                'Notify subscribers when I submit a new errand',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ).paddingSymmetric(
          horizontal: 15,
        ),
      ),
    );
  }

  Widget notification_widget(String title, int index) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        Spacer(),
        Obx(
          () => Switch(
              activeColor: appcolor().mainColor,
              splashRadius: 5,
              value: controller.buttons[index],
              onChanged: (val) {
                controller.buttons[index] = !controller.buttons[index];
              }),
        ),
      ],
    );
  }
}
