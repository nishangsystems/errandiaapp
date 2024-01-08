import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/view/subscription_processing_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class renew_subscription extends StatelessWidget {
  renew_subscription();
  RxString payment_group_value = 'mtn'.obs;
  RxString subscription_type_group_value = 'yearly'.obs;
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          'Renew Subscription',
          style: TextStyle(color: appcolor().mediumGreyColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // subscription type
            Container(
              width: Get.width,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              child: Text(
                'Subscription Type',
                style: TextStyle(
                  color: appcolor().darkBlueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // yearly
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: appcolor().mediumGreyColor,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Text(
                    'Yearly',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Obx(
                    () => Radio(
                      value: 'yearly',
                      activeColor: appcolor().mainColor,
                      groupValue: subscription_type_group_value.value,
                      onChanged: (val) {
                        subscription_type_group_value.value = val.toString();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Monthly
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: appcolor().mediumGreyColor,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Text(
                    'Monthly',
                    style: TextStyle(
                      // color: appcolor().mainColor,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Obx(
                    () => Radio(
                      activeColor: appcolor().mainColor,
                      value: 'monthly',
                      groupValue: subscription_type_group_value.value,
                      onChanged: (val) {
                        subscription_type_group_value.value = val.toString();
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 15,
            ),

            // Select Payment Method
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: appcolor().mediumGreyColor,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              child: Text(
                'Select Payment Method',
                style: TextStyle(
                  color: appcolor().darkBlueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // MTN Mobile money
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: appcolor().mediumGreyColor,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    child: Image(
                      image: AssetImage(
                        'assets/images/icon-payment-mtnMomo.png',
                      ),
                    ),
                  ),
                  Text(
                    '  MTN Mobile money',
                    style: TextStyle(
                      // color: appcolor().mainColor,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Obx(
                    () => Radio(
                      activeColor: appcolor().mainColor,
                      value: 'mtn',
                      groupValue: payment_group_value.value,
                      onChanged: (val) {
                        payment_group_value.value = val.toString();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // mobile number container

            Obx(
              () => payment_group_value.value == 'mtn'
                  ? Container(
                      decoration: BoxDecoration(
                        color: appcolor().skyblueColor,
                        border: Border(
                          bottom: BorderSide(
                            color: appcolor().mediumGreyColor,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 38),
                          border: InputBorder.none,
                          hintText: 'Enter Mobile Money no.',
                        ),
                      ),
                    )
                  : Container(),
            ),
            // Orange Money
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: appcolor().mediumGreyColor,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    child: Image(
                      image: AssetImage(
                        'assets/images/icon-payment-mtnMomoorange-money.png',
                      ),
                    ),
                  ),
                  Text(
                    '  Orange Money',
                    style: TextStyle(
                      // color: appcolor().mainColor,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Obx(
                    () => Radio(
                      activeColor: appcolor().mainColor,
                      value: 'orange',
                      groupValue: payment_group_value.value,
                      onChanged: (val) {
                        payment_group_value.value = val.toString();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // cash
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: appcolor().mediumGreyColor,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    child: Image(
                      image: AssetImage(
                        'assets/images/icon-payment-cash.png',
                      ),
                    ),
                  ),
                  Text(
                    '  Cash',
                    style: TextStyle(
                      // color: appcolor().mainColor,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Obx(
                    () => Radio(
                      activeColor: appcolor().mainColor,
                      value: 'cash',
                      groupValue: payment_group_value.value,
                      onChanged: (val) {
                        payment_group_value.value = val.toString();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // cash renew
            Obx(
              () => payment_group_value.value == 'cash'
                  ? Container(
                      decoration: BoxDecoration(
                        color: appcolor().skyblueColor,
                        border: Border(
                          bottom: BorderSide(
                            color: appcolor().mediumGreyColor,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: appcolor().mainColor,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Tap the ',
                            ),
                            TextSpan(
                              text: 'Renew Subscription',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                text:
                                    ' button below and we\'ll contact you as soon as possible to complete the procedure of renewing your subscription.'),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),

            // total subscription
            SizedBox(
              height: 15,
            ),

            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: appcolor().mediumGreyColor,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              child: Text(
                'Total Subscription',
                style: TextStyle(
                  color: appcolor().darkBlueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Price

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: appcolor().mediumGreyColor,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'XAF 6000',
                    style: TextStyle(
                      color: appcolor().mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: Get.height * 0.05,
            ),

            blockButton(
              title: Text(
                'Renew Susbscription',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ontap: () {
                Get.to(payment_processing_view());
              },
              color: appcolor().mainColor,
            ).paddingSymmetric(horizontal: 15, vertical: 30),
          ],
        ),
      ),
    );
  }
}
