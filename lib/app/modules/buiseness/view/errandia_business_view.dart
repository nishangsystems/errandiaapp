import 'dart:convert';

import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/view/visit_shop.dart';
import 'package:errandia/app/modules/categories/CategoryData.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:errandia/app/modules/reviews/views/review_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../errands/view/Product/serivces.dart';
import '../../global/Widgets/bottomsheet_item.dart';

class errandia_business_view extends StatelessWidget {
  final Map<String, dynamic> businessData;
  final business_controller controller = Get.put(business_controller());
  errandia_business_view({super.key, required this.businessData});

  @override
  Widget build(BuildContext context) {
    print("bz data: ${businessData}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
        Icons.arrow_back_ios,
          ),
          onPressed: () {
        Get.back();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              businessData['name'],
              style: TextStyle(color: appcolor().bluetextcolor, fontSize: 15),
            ),
          ],
        ),
        actions: [
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
            color: appcolor().mediumGreyColor,
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(right: 10),
            onPressed: () {
              errandia_view_bottomsheet();
            },
            icon: const Icon(
              Icons.more_vert,
              size: 30,
            ),
            color: appcolor().mediumGreyColor,
          ),
        ],
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
          size: 30,
        ),
      ),
      endDrawer: customendDrawer(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: Get.width * 0.45,
                height: 50,
                child: blockButton(
                  title: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                        ),
                        Text(
                          '  Chat on Whatsapp',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10
                          ),
                        ),
                      ],
                    ),
                  ),
                  ontap: () async
                  {

                  },
                  color: appcolor().mainColor,
                ),
              ),
              SizedBox(
                width: Get.width * 0.45,
                height: 50,
                child: blockButton(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call,
                          color: appcolor().mainColor,
                        ),
                        Text(
                          'Call ${businessData['phone']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: appcolor().mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ontap: () {
                    launchCaller(businessData['phone']);
                  },
                  color: appcolor().skyblueColor,
                ),
              ),

            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        // physics: AlwaysScrollableScrollPhysics(),
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.sta,
          children: [
            Container(
              // padding: EdgeInsets.symmetric(
              //   horizontal: 15,
              //   vertical: 10,
              // ),
              height: Get.height * 0.3,
              width: Get.width,
              child: Image.network(
                getImagePath(businessData['image'].toString()),
                fit: BoxFit.cover,
              )
            ),

            // shop name

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        businessData['name'] ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.04,
                      ),
                      Icon(
                        Icons.verified_outlined,
                        color: appcolor().blueColor,
                      )
                    ],
                  ),
                ),
                businessData['street'] != null ? Text(
                  businessData['street'],
                  style: const TextStyle(),
                ): const Text(
                  'No street provided',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 18,
                      color: appcolor().mediumGreyColor,
                    ),
                    Text(
                      'Member Since 2010',
                      style: TextStyle(
                        fontSize: 12,
                        color: appcolor().mediumGreyColor,
                      ),
                    ),
                    const Spacer(),
                    RatingBar.builder(
                      initialRating: 3.5,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemSize: 18,
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star_rate_rounded,
                          color: Colors.amber,
                        );
                      },
                      onRatingUpdate: (val) {},
                    ),
                    Text(
                      '10 Reviews',
                      style: TextStyle(
                        fontSize: 11,
                        color: appcolor().mediumGreyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.025,
                ),
                // blockButton(
                //   title: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(
                //         FontAwesomeIcons.whatsapp,
                //         color: Colors.white,
                //       ),
                //       Text(
                //         '  Chat on Whatsapp',
                //         style: TextStyle(
                //           color: Colors.white,
                //         ),
                //       ),
                //     ],
                //   ),
                //   ontap: () async
                //   {
                //
                //   },
                //   color: appcolor().mainColor,
                // ),
                // SizedBox(
                //   height: Get.height * 0.01,
                // ),
                // blockButton(
                //   title: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(
                //         Icons.call,
                //         color: appcolor().mainColor,
                //       ),
                //       Text(
                //         '  Call 999999999',
                //         style: TextStyle(
                //           color: appcolor().mainColor,
                //         ),
                //       ),
                //     ],
                //   ),
                //   ontap: () {},
                //   color: appcolor().skyblueColor,
                // ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    errandia_view_bottomsheet();
                  },
                  child: Container(
                    height: Get.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: appcolor().bluetextcolor,
                      ),
                      color: Colors.white10,
                    ),
                    child: Center(
                      child: Text(
                        'Follow Shop',
                        style: TextStyle(
                            fontSize: 16, color: appcolor().bluetextcolor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.025,
                ),

                // follow us on social media
                (businessData['facebook']!="" && businessData['instagram']!="") ? Row(
                  children: [
                    const Text('Follow us on social media'),
                    // fb
                    businessData['facebook'] != "" ? InkWell(
                      onTap: ()async{
                        mlaunchUrl(businessData['facebook']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: 5,
                        ),
                        child: Icon(
                          FontAwesomeIcons.squareFacebook,
                          color: appcolor().bluetextcolor,
                        ),
                      ),
                    ): Container(),

                    // insta
                    businessData['instagram'] != "" ? InkWell(
                      onTap: () async {
                        mlaunchUrl(businessData['instagram']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.pink,
                        ),
                      ),
                    ): Container(),
                  ],
                ): Container(),
              ],
            ).paddingSymmetric(
              horizontal: 15,
              vertical: 5,
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Divider(),
            // visit shop

            Container(
              height: Get.height * 0.08,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: appcolor().greyColor,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
              child: InkWell(
                onTap: () {
                  var data = controller.businessList[2].toJson();
                  print("bz data: ${data}");

                  Get.to(() =>  VisitShop(
                    businessData: data
                  ));
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.shop,
                      color: appcolor().blueColor,
                      size: 18,
                    ),
                    Text(
                      '   Visit Shop',
                      style:
                          TextStyle(color: appcolor().blueColor, fontSize: 16),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: appcolor().bluetextcolor,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: Get.height * 0.025,
            ),
            Divider(),
            // business branches
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.buildingUser,
                      size: 20,
                    ),
                    SizedBox(
                      width: Get.width * 0.05,
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        children: [
                          TextSpan(text: 'Business Branches  '),
                          TextSpan(
                            text: controller.businessList[2]
                                .BusinessBranch_location!.length
                                .toString(),
                            style: TextStyle(color: appcolor().mediumGreyColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: appcolor().mainColor,
                  thickness: 1.5,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  height: 280,
                  child: ListView.builder(
                    itemCount: controller.businessList[2]
                        .BusinessBranch_location!.length,
                    // physics: const NeverScrollableScrollPhysics(),

                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => VisitShop(businessData: controller.businessList[index].toJson()));
                        },
                        child: Container(
 padding: const EdgeInsets.symmetric( horizontal: 10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: appcolor().greyColor,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        controller.businessList[index].imagepath,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.businessList[index].name,
                                      ),
                                      Text(
                                        controller.businessList[index]
                                            .BusinessBranch_location![0]
                                            .toString(),
                                      ),
                                    ],
                                  ).paddingOnly(left: 10),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: appcolor().bluetextcolor,
                                    ),
                                  ),
                                ],
                              ).paddingOnly(bottom: 10, top: 5),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ).paddingSymmetric(
              horizontal: 15,
              vertical: 3,
            ),

            //supplier review
            Container(
              height: Get.height * 0.08,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: appcolor().greyColor,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
              child: Row(
                children: [
                  const Text(
                    'Supplier Review',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(() => Review_view());
                    },
                    child: const Text(
                      'See All',
                    ),
                  ),
                ],
              ),
            ),

            Container(
              // height: Get.height * 0.3,
              width: Get.width,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: appcolor().greyColor,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(left: 20, right: 15, top: 15, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: Get.height * 0.05,
                            width: Get.width * 0.1,
                            color: Colors.white,
                            child: Image.asset(Recently_item_List[2].avatarImage.toString()),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name of supplier',
                              ),
                              Text('location'),
                            ],
                          ),
                          // Spacer(),
                          SizedBox(
                            width: Get.width * 0.13,
                          ),
                          RatingBar.builder(
                            itemCount: 5,
                            direction: Axis.horizontal,
                            initialRating: 1,
                            itemSize: 22,
                            maxRating: 5,
                            allowHalfRating: true,
                            glow: true,
                            itemBuilder: (context, _) {
                              return const Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                            onRatingUpdate: (value) {
                              debugPrint(value.toString());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ui_23_item_list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                          height: Get.height * 0.2,
                          color: Colors.white,
                          width: Get.width * 0.2,
                          child: Center(
                            child: Image.asset(ui_23_item_list[index].imagePath.toString())
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      'Praesentium quo impedit eaque ut. Aperiam qui illum. Porro quis autem dolorum saepe dolor ipsa ut.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).paddingOnly(
          top: 10,
          bottom: 20,
        ),
      ),
    );
  }
}

void errandia_view_bottomsheet() {
  Get.bottomSheet(
    isScrollControlled: true,
    // backgroundColor: Colors.white,
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: const Color(0xFFFFFFFF),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Icon(
            Icons.horizontal_rule,
            size: 25,
          ),
          // Text(index.toString()),
          bottomSheetWidgetitem(
            title: 'Follow this shop',
            imagepath: 'assets/images/sidebar_icon/icon-profile-following.png',
            callback: () async {
              print('tapped');
              Get.back();
            },
          ),
          bottomSheetWidgetitem(
            title: 'Call Suplier',
            imagepath: 'assets/images/sidebar_icon/icon-move.png',
            callback: () async {
              print('tapped');
              Get.back();
            },
          ),
          bottomSheetWidgetitem(
            title: 'Write a Review',
            imagepath: 'assets/images/sidebar_icon/icon-move.png',
            callback: () async {
              print('tapped');
              Get.back();
            },
          ),
          InkWell(
            hoverColor: Colors.grey,
            onTap: () {
              Get.back();
              Get.bottomSheet(
                isScrollControlled: true,
                Container(
                  color: Colors.white,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      const Icon(
                        Icons.horizontal_rule,
                        size: 25,
                      ),
                      Text(
                        'Report Shop'.tr,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: appcolor().mediumGreyColor,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            height: Get.height * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: appcolor().mediumGreyColor,
                              ),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'This is My Product'.tr,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                disabledBorder: InputBorder.none,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Why are you reporting this business'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            height: Get.height * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: appcolor().mediumGreyColor,
                              ),
                            ),
                            child: TextFormField(
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: ''.tr,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                disabledBorder: InputBorder.none,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width * 0.5,
                                height: Get.height * 0.06,
                                decoration: BoxDecoration(
                                  color: appcolor().redColor,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Submit Report'.tr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.09,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Cancel'.tr,
                                  style: TextStyle(
                                    color: appcolor().mediumGreyColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            ],
                          ).paddingOnly(
                            top: 10,
                            bottom: 10,
                            right: 10,
                          ),
                        ],
                      ).paddingSymmetric(
                        horizontal: 15,
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Row(
              children: [
                SizedBox(
                  height: 24,
                  child: Image(
                    image: const AssetImage(
                      'assets/images/sidebar_icon/icon-trash.png',
                    ),
                    color: appcolor().redColor,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  'Report this shop',
                  style: TextStyle(fontSize: 16, color: appcolor().redColor),
                ),
              ],
            ).paddingSymmetric(vertical: 15),
          ),
        ],
      ).paddingSymmetric(horizontal: 15, vertical: 15,),
    ),

    enableDrag: true,
  );
}
