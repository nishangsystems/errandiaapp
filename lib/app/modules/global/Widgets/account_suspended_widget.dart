import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color.dart';

class account_suspended_widget extends StatelessWidget {
  const account_suspended_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      scrollable: true,
      content: Container(
        // height: Get.height * 0.7,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ACCOUNT SUSPENDED',
              style: TextStyle(
                color: appcolor().mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 15),
              height: Get.height * 0.1,
              child: Image(
                image: AssetImage(
                  'assets/images/account_suspended.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
            Container(
              child: Text(
                'Sorry your account has been suspended. While your account is suspended, You cannot add products, services, businesses nor carryout transactions on Errand.\n for more details, you can contact us.',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    text: 'Contact Us',
                    style: TextStyle(
                        color: appcolor().bluetextcolor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: ' for more details',
                    style: TextStyle(
                      color: appcolor().mediumGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Get.height*0.05,),
            Column(
              children: [
                blockButton(
                  title: Text('Contact Us', style: TextStyle(color: Colors.white),),
                  ontap: () {
                    Get.back();
                  },
                  color: appcolor().redColor,
                ),
                SizedBox(height: Get.height*0.015,),
                blockButton(
                  title: Text('Back' , style: TextStyle(color: appcolor().mediumGreyColor),),
                  ontap: () {
                    Get.back();
                  },
                  color: Color(0xfffafafa),
                ),
              ],
            ).paddingSymmetric(horizontal: 10, vertical: 10,),


          ],
        ),
      ),
    );
    
  }
}
