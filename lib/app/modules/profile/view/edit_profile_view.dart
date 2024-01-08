import 'dart:io';

import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/bottomsheet_item.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class edit_profile_view extends StatelessWidget {
  imagePickercontroller imageController = Get.put(imagePickercontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: appcolor().mediumGreyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: appcolor().mediumGreyColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'UPDATE',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image container
            Container(
              height: Get.height * 0.26,
              margin: EdgeInsets.only(bottom: 15),
              child: Stack(
                children: [
                  Obx(
                    () => imageController.image_path.value == ""
                        ? Container(
                            height: Get.height * 0.23,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/setting-editProfile-imgPlaceholder.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ).marginOnly(
                                left: 15,
                                bottom: 15,
                              ),
                            ),
                          )
                        : Container(
                            height: Get.height * 0.23,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                image: FileImage(
                                  File(
                                    imageController.image_path.value,
                                  ),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      child: InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.white,
                              child: Wrap(
                                children: [
                                  Center(
                                    child: Icon(
                                      Icons.horizontal_rule,
                                      size: 25,
                                    ),
                                  ),
                                  bottomSheetWidgetitem(
                                    title: 'Edit Image',
                                    imagepath:
                                        'assets/images/sidebar_icon/icon-edit.png',
                                    callback: () {
                                      Get.back();
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return customDialogBox();
                                        },
                                      );
                                    },
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      imageController.reset();
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 24,
                                          child: Icon(
                                            Icons.image,
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 18,
                                        ),
                                        Text(
                                          'Remove Photo',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ).paddingSymmetric(vertical: 15),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: Get.height * 0.07,
                          width: Get.width * 0.18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Color.fromARGB(255, 250, 250, 250),
                          ),
                          child: Icon(
                            FontAwesomeIcons.camera,
                            color: appcolor().mediumGreyColor,
                            size: 35,
                          ),
                        ),
                      ),
                    ).marginOnly(right: 15),
                  ),
                ],
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            // first name
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesomeIcons.user,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'First Name ',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            // last name
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 45, top: 12),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Last Name ',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            // email
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Email ',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            // whatsapp number
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                maxLength: 10,
                maxLines: 1,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  counter: Offstage(),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'WhatsApp Number *',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                maxLength: 10,
                maxLines: 1,
                decoration: InputDecoration(
                  counter: Offstage(),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.call,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: '+94 8478538989*',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
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

  Widget customDialogBox() {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 20,
      ),
      scrollable: true,
      content: Container(
        // height: Get.height * 0.7,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Images',
              style: TextStyle(
                color: appcolor().mainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: Get.height * 0.05,
            ),
            Column(
              children: [
                blockButton(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.image,
                        color: appcolor().mainColor,
                        size: 22,
                      ),
                      Text(
                        '  Image Gallery',
                        style: TextStyle(color: appcolor().mainColor),
                      ),
                    ],
                  ),
                  ontap: () {
                    Get.back();
                    imageController.getImagefromgallery();
                  },
                  color: appcolor().greyColor,
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                blockButton(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.camera,
                        color: appcolor().mainColor,
                        size: 22,
                      ),
                      Text(
                        '  Take Photo',
                        style: TextStyle(
                          color: appcolor().mainColor,
                        ),
                      ),
                    ],
                  ),
                  ontap: () {
                    Get.back();
                    imageController.getimagefromCamera();
                  },
                  color: Color(0xfffafafa),
                ),
              ],
            )
          ],
        ).paddingSymmetric(
          horizontal: 10,
          vertical: 10,
        ),
      ),
    );
  }
}
