import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class userAgreementContainer extends StatelessWidget {
  userAgreementContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "User Agreement",
        style: TextStyle(
          color: appcolor().mainColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: EdgeInsets.only(
        top: 12.0,
        left: 20,
        right: 20,
      ),
      content: SingleChildScrollView(
          child: Column(
        children: [
          Text(
            'Website or any application we make available via an app store (the “Platform”), and the corresponding services available through the Platform (the “Services”). Below we set out our privacy policy, which will govern the way in which we process any persona information that you provide to us. We will notify you if the way in which we process you information is tochange at any time.Please read this privacy policy carefully as it contains important information on who we are an how we collect, store, use and share your information. By accessing the Platform or using our Services or otherwise indicating your consent, you agree to, and where required, consent to the collection, use and transfer of your information as set out in this policy. If you do not accept th terms of this policy, you must not use the Platform and/or the Services.This privacy policy',
            textAlign: TextAlign.justify,
          ),
        ],
      ),),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialButton(
              elevation: 0,
              child: Text(
                "Accept",
                style: TextStyle(
                    color: appcolor().blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            MaterialButton(
              elevation: 0,
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ],
    );
  }
}
