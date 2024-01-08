import 'dart:io';

import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/view/update_business_location.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:errandia/app/modules/profile/view/edit_profile_view.dart';
import 'package:errandia/app/modules/setting/controller/setting_controller.dart';
import 'package:errandia/app/modules/setting/view/about.dart';
import 'package:errandia/app/modules/setting/view/helpcenter_view.dart';
import 'package:errandia/app/modules/setting/view/invite_friends_view.dart';
import 'package:errandia/app/modules/setting/view/notification_setting_view.dart';
import 'package:errandia/app/modules/setting/view/policies&rules.dart';
import 'package:errandia/app/modules/setting/view/review_view.dart';
import 'package:errandia/app/modules/setting/view/update_password_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../buiseness/controller/add_business_controller.dart';
import '../../global/Widgets/blockButton.dart';

add_product_cotroller product_controller = Get.put(add_product_cotroller());

imagePickercontroller imageController = Get.put(imagePickercontroller());

setting_controller controller = Get.put(setting_controller());

class setting_view extends StatelessWidget {
  setting_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        titleSpacing: 8,
        title: Text('Settings'.tr),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: appcolor().mediumGreyColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            // Edit profile
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            mywidget(() {
              Get.to(() => edit_profile_view());
            }, Icons.person, 'Edit Profile'),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            //Business location

            mywidget(() {
              Get.to(() => update_business_location_view());
            }, Icons.location_on, 'Business Location'),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            // change password

            mywidget(() {
              Get.to(() => update_password_view());
            }, Icons.lock_reset, 'Change Password'),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            // notification

            mywidget(() {
              Get.to(() => notification_setting_view());
            }, Icons.notifications, 'Notification'),

            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            SizedBox(
              height: 15,
            ),

            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            //about
            mywidget(() {
              Get.to(() => about_view());
            }, Icons.person, 'About Errandia'),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            //help center

            mywidget(() {
              Get.to(() => helpcenter_view());
            }, Icons.location_on, 'Help Center'),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            // review

            mywidget(() {
              Get.to(() => review_view());
            }, Icons.lock_reset, 'Review Errandia'),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            // invite
            mywidget(() {
              Get.to(() => invite_friends_view());
            }, Icons.notifications, 'Invite Friends'),

            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            // policies
            mywidget(() {
              Get.to(() => policies_view());
            }, Icons.notifications, 'Policies & Rules'),

            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            // language
            Container(
              height: Get.height * 0.075,

              // margin: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              decoration: BoxDecoration(
                  // color: Colors.white,
                  ),
              child: InkWell(
                onTap: () {
                  Get.bottomSheet(changeLanguage());
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      FontAwesomeIcons.earth,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Language'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Obx(
                      () => Text(
                        '${controller.language.value}',
                        style: TextStyle(
                          color: appcolor().blueColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget changeLanguage() {
    return Container(
      // height: Get.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            child: Text(
              'App Language',
              style: TextStyle(
                color: appcolor().mainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                'English',
                style: TextStyle(
                  color: appcolor().darkBlueColor,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              Obx(
                () => Radio(
                  value: 'English',
                  groupValue: controller.language.value,
                  onChanged: (val) {
                    controller.language.value = val.toString();
                    Get.back();
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'French',
                style: TextStyle(
                  color: appcolor().darkBlueColor,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              Obx(
                () => Radio(
                  value: 'French',
                  groupValue: controller.language.value,
                  onChanged: (val) {
                    controller.language.value = val.toString();
                    Get.back();
                  },
                ),
              )
            ],
          )
        ],
      ).paddingSymmetric(
        horizontal: 15,
        vertical: 10,
      ),
    );
  }
}

Widget mywidget(
  VoidCallback ontap,
  IconData leadingIcon,
  String title,
) {
  return Container(
    height: Get.height * 0.075,

    // margin: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
    decoration: BoxDecoration(
        // color: Colors.white,
        ),
    child: InkWell(
      onTap: ontap,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Icon(
            leadingIcon,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    ),
  );
}
