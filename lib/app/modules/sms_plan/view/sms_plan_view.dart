import 'dart:developer';
import 'package:errandia/app/modules/Billing/controller/Billing_controller.dart';
import 'package:errandia/app/modules/buiseness/view/add_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/manage_review/controller/manage_review_controller.dart';
import 'package:errandia/app/modules/sms_plan/controller/sms_plan_controller.dart';
import 'package:errandia/app/modules/sms_plan/view/extend_sms_plan.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/constants/color.dart';

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
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            // size: 30,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Manage SMS Plan',
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
                                        Get.to(extend_sms_plan_view());
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
