import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class about_view extends StatelessWidget {
  const about_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'About Errandia',
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
      backgroundColor: appcolor().mainColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   margin: EdgeInsets.symmetric(
            //     vertical: 5,
            //   ),
            //   width: Get.width * 0.4,
            //   height: Get.height * 0.06,
            //   child: Image(
            //     image: AssetImage('assets/images/icon-errandia-logo-about.png'),
            //     fit: BoxFit.fill,
            //   ),
            // ),
            Container(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Text(
                'In a society where technology is becoming an integral part of our daily life, our daily needs and wants can easily be solved with the help of technology without any stress. ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Text(
                'ERRANDIA is a platform to help run your errands for you technologically by reaching out to all goods and service provides through a distinct search algorithm. Thus ERRANDIA is an online platform to run your errands with an extra option of allowing customers rate and review goods and service providers through our rating and review option and this will go a long way to help others understand the performances of a particular business before engaging with them',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Text(
                'App Info \nVersion : 1.0.0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: 10,
              ),
              child: Text(
                'Last Update \n23 April 2023',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 12, vertical: 15),
      ),
    );
  }
}
