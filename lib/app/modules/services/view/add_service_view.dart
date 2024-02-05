import 'dart:io';

import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../buiseness/controller/add_business_controller.dart';
import '../../global/Widgets/blockButton.dart';

add_product_cotroller product_controller = Get.put(add_product_cotroller());

imagePickercontroller imageController = Get.put(imagePickercontroller());

class add_service_view extends StatelessWidget {
  add_service_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 8,
        title: Text('Add Service'.tr, style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff113d6b),
        ),),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: appcolor().mediumGreyColor,
            fontSize: 18),
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xff113d6b),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'Publish',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Text(
                'New Service Detail'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            // company name
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                controller: product_controller.product_name_controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesomeIcons.buildingUser,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Service Name *',
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

            // service categories
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                controller: product_controller.category_controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    color: Colors.black,
                    Icons.category,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Categories *',
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

            //  price
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    color: Colors.black,
                    FontAwesomeIcons.dollarSign,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Unit Price *',
                  suffix: Text('XAF'),
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

            //  info
            Container(
              height: Get.height * 0.2,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    color: Colors.black,
                    FontAwesomeIcons.info,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Service Description *',
                  suffixIcon: Icon(
                    color: Colors.black,
                    Icons.edit,
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

            // cover image 
            Obx(
              () => Container(
                height: imageController.image_path.isEmpty
                    ? null
                    : Get.height * 0.28,
                child: imageController.image_path.isEmpty
                    ? InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cover Image',
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.image,
                                                  color: appcolor().mainColor,
                                                  size: 22,
                                                ),
                                                Text(
                                                  '  Image Gallery',
                                                  style: TextStyle(
                                                      color:
                                                          appcolor().mainColor),
                                                ),
                                              ],
                                            ),
                                            ontap: () {
                                              Get.back();
                                              imageController
                                                  .getImageFromGallery();
                                            },
                                            color: appcolor().greyColor,
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.015,
                                          ),
                                          blockButton(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                              imageController
                                                  .getimagefromCamera();
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
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Row(
                            children: [
                              Icon(Icons.image),
                              Text('  Cover Image *'),
                              Spacer(),
                              Icon(
                                Icons.edit,
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: Get.height * 0.15,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.image),
                                Text(
                                  '  Company Logo *',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.edit,
                                  ),
                                )
                              ],
                            ).paddingSymmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                            Divider(
                              color: appcolor().greyColor,
                              thickness: 1,
                              height: 1,
                              indent: 0,
                            ),
                            Stack(
                              children: [
                                Image(
                                  image: FileImage(
                                    File(
                                      imageController.image_path.toString(),
                                    ),
                                  ),
                                  height: Get.height * 0.19,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ).paddingSymmetric(horizontal: 20),
                                Container(
                                  height: Get.height * 0.19,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          imageController.getImageFromGallery();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 60,
                                          color: Colors.lightGreen,
                                          child: Center(
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          imageController.reset();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 60,
                                          color: appcolor().greyColor,
                                          child: Center(
                                            child: Text(
                                              'Remove',
                                              style: TextStyle(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
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
           
            // multiple image 
            Container(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.image,
                  ),
                  Text(
                    '  Service Image Gallery',
                  ),
                  Spacer(),
                  Icon(Icons.edit),
                ],
              ),
            ),

            Obx(
              () => Container(
                height: imageController.imageList.isEmpty ? null : null,
                child: imageController.imageList.isEmpty
                    ? InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.image,
                                                  color: appcolor().mainColor,
                                                  size: 22,
                                                ),
                                                Text(
                                                  '  Image Gallery',
                                                  style: TextStyle(
                                                      color:
                                                          appcolor().mainColor),
                                                ),
                                              ],
                                            ),
                                            ontap: () {
                                              Get.back();
                                              imageController
                                                  .getmultipleImage();
                                            },
                                            color: appcolor().greyColor,
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.015,
                                          ),
                                          blockButton(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                              imageController
                                                  .getimagefromCamera();
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
                            },
                          );
                        },
                        child: Container(
                            child: Column(
                          children: [
                            Container(
                              color: appcolor().greyColor,
                              height: Get.height * 0.22,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // SizedBox(height: Get.height*0.05,),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.images,
                                          size: 60,
                                          color: appcolor().mediumGreyColor,
                                        ),
                                        Text(
                                          '     Browse Images',
                                          style: TextStyle(
                                            color: appcolor().bluetextcolor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: Get.height * 0.05,
                                  // ),
                                  Text(
                                    'Other variations of the main product image',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: appcolor().mediumGreyColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                      )
                    : Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: Get.height * 0.24,
                        child: Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: imageController.imageList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    height: Get.height * 0.15,
                                    width: Get.width * 0.40,
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: Image(
                                      image: FileImage(
                                        File(
                                          imageController.imageList[index].path
                                              .toString(),
                                        ),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            imageController.edit(index);
                                          },
                                          child: Container(
                                            height: 35,
                                            width: Get.width * 0.20,
                                            color: Colors.lightGreen,
                                            child: Center(
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            imageController.removeat(index);
                                          },
                                          child: Container(
                                            height: 35,
                                            width: Get.width * 0.2,
                                            color: appcolor().greyColor,
                                            child: Center(
                                              child: Text(
                                                'Remove',
                                                style: TextStyle(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ).paddingSymmetric(horizontal: 5);
                            },
                          ),
                        ),
                      ),
              ),
            ),
            
            //  image container
            Obx(
              () => Container(
                child: imageController.imageList.isEmpty
                    ? null
                    : InkWell(
                      onTap: (){
                        imageController.getmultipleImage();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: appcolor().skyblueColor,
                          borderRadius: BorderRadius.circular(10,),
                        ),
                        height: Get.height*0.08,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                              ),
                              Text(
                                '   Add more images',
                              ),
                            ],
                          ),
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

            // product tags
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesomeIcons.tags,
                    color: Color.fromARGB(255, 108, 105, 105),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Service Tags *',
                  suffixIcon: Icon(
                    color: Colors.black,
                    Icons.edit,
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

            Text(
              'Enter words related to service separated by comma',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ).paddingSymmetric(
              horizontal: 16,
              vertical: 10,
            ),
            SizedBox(
              height: Get.height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}



