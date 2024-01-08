import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'dart:io';

class product_send_enquiry extends StatelessWidget {
  product_send_enquiry({super.key});
  add_product_cotroller product_controller = Get.put(add_product_cotroller());

  imagePickercontroller imageController = Get.put(imagePickercontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: appcolor().mediumGreyColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Send Enquiry',
          style: TextStyle(
            color: appcolor().mainColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              Container(
                height: Get.height * 0.12,
                child: Row(
                  children: [
                    Text(
                      'Enquiry To:',
                      style: TextStyle(
                          color: appcolor().mediumGreyColor, fontSize: 16),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rubiliams Hair Clinic',
                          style: TextStyle(
                              // color: appcolor().mediumGreyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Get.height * 0.004,
                        ),
                        Text(
                          'Hotel St.Claire Molyko, Buea',
                          style: TextStyle(
                            color: appcolor().mediumGreyColor,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'South West Region, Cameroon',
                          style: TextStyle(
                            color: appcolor().mediumGreyColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ).paddingOnly(left: 10),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
              Divider(
                color: appcolor().mediumGreyColor,
              ),
              Container(
                height: Get.height * 0.12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Get.height * 0.08,
                      child: Icon(
                        FontAwesomeIcons.solidImage,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.03,
                    ),
                    Container(
                      width: Get.width * 0.65,
                      child: Text(
                        'If you have a picture to upload to gve a better description of your enquiry, kindly attach them below',
                        style: TextStyle(
                          // color: appcolor().mediumGreyColor,
                          fontSize: 15,
                          // fontWeight: FontWeight.bold,
                        ),
                      ).paddingOnly(left: 10),
                    ),
                    Spacer(),
                    Container(
                      height: Get.height * 0.08,
                      child: Icon(
                        FontAwesomeIcons.pen,
                        color: appcolor().blueColor,
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
              Obx(
                () => Container(
                  height: imageController.imageList.isEmpty ? null : null,
                  child: imageController.imageList.isEmpty
                      ? InkWell(
                          onTap: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return AlertDialog(
                            //       insetPadding: EdgeInsets.symmetric(
                            //         horizontal: 20,
                            //       ),
                            //       contentPadding: EdgeInsets.symmetric(
                            //         horizontal: 8,
                            //         vertical: 20,
                            //       ),
                            //       scrollable: true,
                            //       content: Container(
                            //         // height: Get.height * 0.7,
                            //         width: Get.width,
                            //         child: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               'Select Images',
                            //               style: TextStyle(
                            //                 color: appcolor().mainColor,
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.bold,
                            //               ),
                            //             ),
                            //             SizedBox(
                            //               height: Get.height * 0.05,
                            //             ),
                            //             Column(
                            //               children: [
                            //                 blockButton(
                            //                   title: Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.center,
                            //                     children: [
                            //                       Icon(
                            //                         FontAwesomeIcons.image,
                            //                         color: appcolor().mainColor,
                            //                         size: 22,
                            //                       ),
                            //                       Text(
                            //                         '  Image Gallery',
                            //                         style: TextStyle(
                            //                             color: appcolor()
                            //                                 .mainColor),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                   ontap: () {
                            //                     Get.back();
                            //                     imageController
                            //                         .getmultipleImage();
                            //                   },
                            //                   color: appcolor().greyColor,
                            //                 ),
                            //                 SizedBox(
                            //                   height: Get.height * 0.015,
                            //                 ),
                            //                 blockButton(
                            //                   title: Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.center,
                            //                     children: [
                            //                       Icon(
                            //                         FontAwesomeIcons.camera,
                            //                         color: appcolor().mainColor,
                            //                         size: 22,
                            //                       ),
                            //                       Text(
                            //                         '  Take Photo',
                            //                         style: TextStyle(
                            //                           color:
                            //                               appcolor().mainColor,
                            //                         ),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                   ontap: () {
                            //                     Get.back();
                            //                     imageController
                            //                         .getimagefromCamera();
                            //                   },
                            //                   color: Color(0xfffafafa),
                            //                 ),
                            //               ],
                            //             )
                            //           ],
                            //         ).paddingSymmetric(
                            //           horizontal: 10,
                            //           vertical: 10,
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // );
                            
                            imageController.getmultipleImage();
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                            imageController
                                                .imageList[index].path
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
              Obx(
                () => Container(
                  child: imageController.imageList.isEmpty
                      ? null
                      : InkWell(
                          onTap: () {
                            imageController.getmultipleImage();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: appcolor().skyblueColor,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            height: Get.height * 0.08,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Title',
                      style: TextStyle(
                          color: appcolor().mediumGreyColor, fontSize: 18),
                    ),
                  ),
                  Container(
                    height: Get.height * 0.09,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      border: Border.all(color: appcolor().mediumGreyColor),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
                  Container(
                    child: Text(
                      'Description',
                      style: TextStyle(
                          color: appcolor().mediumGreyColor, fontSize: 18),
                    ),
                  ),
                  Container(
                    height: Get.height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      border: Border.all(color: appcolor().mediumGreyColor),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                ],
              ).paddingSymmetric(
                horizontal: 20,
                vertical: 5,
              ),
            ],
          )
        ],
      ),bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: blockButton(
        title: Text(
          'Send Enquiry',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 16),
        ),
        ontap: () {},
        color: appcolor().mainColor,
    ),
      ),
    );
  }
}
