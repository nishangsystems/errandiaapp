import 'dart:developer';

import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/snackBar.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/setting/controller/setting_controller.dart';
import 'package:errandia/app/modules/sms_plan/controller/sms_plan_controller.dart';
import 'package:errandia/app/modules/sms_plan/view/sms_plan_view.dart';
import 'package:errandia/app/modules/subscribers/view/subscriber_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class invite_friends_view extends StatelessWidget {
  invite_friends_view({super.key});
  invite_friends_controller controller = Get.put(invite_friends_controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => controller.tabnum.value == 0
            ? blockButton(
                title: Text(
                  'Send Invites ${controller.selected.value}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ontap: () {},
                color: appcolor().mainColor,
              ).marginOnly(left: 35)
            : Container(),
      ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: appcolor().greyColor,
            thickness: 1,
            height: 1,
            indent: 0,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Row(
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Text(
                  'Share Links',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                  color: appcolor().mediumGreyColor,
                )
              ],
            ),
          ),
          Divider(
            color: appcolor().greyColor,
            thickness: 1,
            height: 1,
            indent: 0,
          ),
          Container(
            decoration: BoxDecoration(
                // color: Colors.white,
                ),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 18,
            ),
            child: Row(
              children: [
                Text(
                  'Invite Friends to subscribe to your shop',
                  style: TextStyle(
                    fontSize: 12,
                  ),
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

          // tab bar
          Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: appcolor().greyColor,
                ),
              ),
            ),
            child: Container(
              color: Colors.white,
              // height: Get.height * 0.07,
              child: TabBar(
                // isScrollable: true,
                dividerColor: appcolor().mediumGreyColor,
                unselectedLabelColor: appcolor().mediumGreyColor,
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                indicatorColor: appcolor().mainColor,

                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: appcolor().mainColor,
                  fontSize: 16,
                ),
                controller: controller.tabController,
                labelColor: appcolor().darkBlueColor,
                tabs: [
                  Tab(
                    text: 'Friends on Errandia',
                  ),
                  Tab(
                    text: "Phone Contacts",
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
                child: TabBarView(
              controller: controller.tabController,
              children: [
                // friends on errandia

                Friends_widget(),

                //   children: [
                //     Container(
                //       child: Column(
                //         children: [
                //           SizedBox(
                //             height: Get.height * 0.05,
                //           ),
                //           Text(
                //             'Find Contacts on Errandia',
                //             style: TextStyle(
                //               color: appcolor().mainColor,
                //               fontSize: 18,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //           Text(
                //             'Find and invite your friends currently using Errandia',
                //             style: TextStyle(
                //               fontSize: 12,
                //             ),
                //           ),
                //           SizedBox(
                //             height: Get.height * 0.04,
                //           ),
                //           blockButton(
                //             title: Text(
                //               'Sync Contact',
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w600,
                //               ),
                //             ),
                //             ontap: () {},
                //             color: appcolor().mainColor,
                //           ).paddingSymmetric(
                //             horizontal: 20,
                //           )
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // phone_contact_widget(),
                // phone contact
                ListView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                          Text(
                            'Invite Phone Contact Via SMS',
                            style: TextStyle(
                              color: appcolor().mainColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'To invite friends from your phone\'s contact list, you must purchase an SMS Bundle',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                          blockButton(
                            title: Text(
                              'Buy SMS Bundle',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ontap: () {
                              Get.bottomSheet(buySmsBundle());
                            },
                            color: appcolor().mainColor,
                          ),
                        ],
                      ).paddingSymmetric(
                        horizontal: 20,
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget Friends_widget() {
    return Column(
      children: [
        Row(
          children: [
            Obx(
              () => Text(
                '${controller.selected.value} friends selected',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            Text(
              'select all',
              style: TextStyle(
                  color: appcolor().mainColor, fontWeight: FontWeight.w600),
            ),
            Obx(
              () => IconButton(
                onPressed: () {
                  controller.selectAll();
                },
                icon: Icon(
                  controller.selected.value == controller.list.length
                      ? FontAwesomeIcons.squareCheck
                      : Icons.square_outlined,
                  color: appcolor().mainColor,
                ),
              ),
            ),
          ],
        ).paddingOnly(left: 10, right: 0),
        Expanded(
          child: ListView.builder(
            itemCount: controller.list.length,
            padding: EdgeInsets.only(
              left: 15,
            ),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: appcolor().greyColor,
                      ),
                      child: Icon(
                        Icons.person,
                        // size: ,
                      ),
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.list[index].title.toString(),
                          style: TextStyle(
                            color: appcolor().mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Number',
                          style: TextStyle(
                              color: appcolor().mediumGreyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )
                      ],
                    ).marginOnly(
                      left: 10,
                    ),
                    Spacer(),
                    Obx(
                      () => IconButton(
                        onPressed: () {
                          controller.select_deselect(index);
                          // log( controller.list[index].isSelected.toString());
                        },
                        icon: Icon(
                          controller.list[index].isSelected.value == false
                              ? Icons.square_outlined
                              : FontAwesomeIcons.squareCheck,
                          color: appcolor().mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget phone_contact_widget() {
    return Column(
      children: [
        Row(
          children: [
            Obx(
              () => Text(
                '${controller.selected.value} friends selected',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            Text(
              'select all',
              style: TextStyle(
                  color: appcolor().mainColor, fontWeight: FontWeight.w600),
            ),
            Obx(
              () => IconButton(
                onPressed: () {
                  controller.selectAll();
                },
                icon: Icon(
                  controller.selected.value == controller.list.length
                      ? FontAwesomeIcons.squareCheck
                      : Icons.square_outlined,
                  color: appcolor().mainColor,
                ),
              ),
            ),
          ],
        ).paddingOnly(left: 10, right: 0),
        Expanded(
          child: ListView.builder(
            itemCount: controller.list.length,
            padding: EdgeInsets.only(
              left: 15,
            ),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: appcolor().greyColor,
                      ),
                      child: Icon(
                        Icons.person,
                        // size: ,
                      ),
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.list[index].title.toString(),
                          style: TextStyle(
                            color: appcolor().mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Number',
                          style: TextStyle(
                              color: appcolor().mediumGreyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )
                      ],
                    ).marginOnly(
                      left: 10,
                    ),
                    Spacer(),
                    Obx(
                      () => IconButton(
                        onPressed: () {
                          controller.select_deselect(index);
                          // log( controller.list[index].isSelected.toString());
                        },
                        icon: Icon(
                          controller.list[index].isSelected.value == false
                              ? Icons.square_outlined
                              : FontAwesomeIcons.squareCheck,
                          color: appcolor().mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buySmsBundle() {
    return sms_plan_view();
  }
}

class sms_plan_view extends StatefulWidget {
  sms_plan_view({super.key});

  @override
  State<sms_plan_view> createState() => _sms_plan_viewState();
}

class _sms_plan_viewState extends State<sms_plan_view> {
  sms_plan_controller controller = Get.put(sms_plan_controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Buy SMS Plan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
          size: 30,
        ),
        actions: [
          Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.list.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 0, right: 0, bottom: 5, top: 0),
                  margin: EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 8,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.list[index].currentPlan == true
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: appcolor().greenColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Current Plan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        padding: EdgeInsets.only(
                            left: 6, right: 6, bottom: 5, top: 0),
                        margin: EdgeInsets.only(left: 8, right: 8, top: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 245, 248, 241),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 0,
                              ),
                              child: Text(
                                controller.getPlan_type(
                                  controller.list[index].dailyPlan,
                                  controller.list[index].weekPlan,
                                  controller.list[index].monthlyPlan,
                                ),
                                style: TextStyle(
                                    color: controller.list[index].color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Plan ',
                                      style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Daily Package',
                                      style: TextStyle(
                                        // color: appcolor().mediumGreyColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'XAF 1600',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "XAF 32 per SMS ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: appcolor().mediumGreyColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: appcolor().lightgreyColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                          text: 'Total : ',
                                          children: [
                                            TextSpan(
                                              text: '50 SMS',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: controller
                                                    .list[index].color,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                controller.list[index].extend == false
                                    ? Text(
                                        controller.list[index].currentPlan ==
                                                true
                                            ? 'Extend'
                                            : 'Activate',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: controller.list[index].color,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : Container(),
                                InkWell(
                                  onTap: () {
                                    controller.list[index].extend =
                                        !controller.list[index].extend!;
                                    log('tapped');
                                    log(controller.list[index].extend
                                        .toString());
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: appcolor().greyColor,
                                      borderRadius: BorderRadius.circular(
                                        4,
                                      ),
                                    ),
                                    child: Icon(
                                      controller.list[index].extend == false
                                          ? Icons.arrow_drop_down
                                          : Icons.arrow_drop_up,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      controller.list[index].extend == true
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                  color: appcolor().mediumGreyColor,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: appcolor().mediumGreyColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    text: 'Total SMS : ',
                                    children: [
                                      TextSpan(
                                        text: controller.list[index].msgcount
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: appcolor().mediumGreyColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    text: 'Sent SMS : ',
                                    children: [
                                      TextSpan(
                                        text: controller.list[index].setsms
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: appcolor().mediumGreyColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        text: 'Remaining SMS : ',
                                        children: [
                                          TextSpan(
                                            text: '30',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                        Get.showSnackbar(
                                          customsnackbar(
                                            Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.circleCheck,
                                                  color: appcolor().greenColor,
                                                ),
                                                Text(
                                                  ' SMS Bundle purchase successful',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        controller.list[index].currentPlan ==
                                                true
                                            ? 'EXTEND PLAN'
                                            : 'ACTIVATE PLAN',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: controller.list[index].color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ).paddingSymmetric(horizontal: 12, vertical: 5)
                          : Container(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
