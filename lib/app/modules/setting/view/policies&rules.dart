import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class policies_view extends StatelessWidget {
  const policies_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Policies & Rules',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text(
                'We take your privacy very seriously and are committed to protecting the privacy of all visitors and subscribers to our website or any application we make available via an app store (the “Platform”), and the corresponding services available through the Platform (the “Services”).',
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Text(
                'We take your privacy very seriously and are committed to protecting the privacy of all visitors and subscribers to our website or any application we make available via an app store (the “Platform”), and the corresponding services available through the Platform (the “Services”).',
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Text(
                'We take your privacy very seriously and are committed to protecting the privacy of all visitors and subscribers to our website or any application we make available via an app store (the “Platform”), and the corresponding services available through the Platform (the “Services”).',
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Text(
                'We take your privacy very seriously and are committed to protecting the privacy of all visitors and subscribers to our website or any application we make available via an app store (the “Platform”), and the corresponding services available through the Platform (the “Services”).',
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Text(
                'We take your privacy very seriously and are committed to protecting the privacy of all visitors and subscribers to our website or any application we make available via an app store (the “Platform”), and the corresponding services available through the Platform (the “Services”).',
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Text(
                'We take your privacy very seriously and are committed to protecting the privacy of all visitors and subscribers to our website or any application we make available via an app store (the “Platform”), and the corresponding services available through the Platform (the “Services”).',
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ).paddingSymmetric(
          horizontal: 12,
          vertical: 5,
        ),
      ),
    );
  }
}
