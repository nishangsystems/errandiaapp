import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class helpcenter_view extends StatelessWidget {
  const helpcenter_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Help Center',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: TextStyle(
                color: appcolor().mediumGreyColor,
                // fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            blockButton(
              title: TextFormField(
                maxLines: 1,
                maxLength: 20,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: InputBorder.none,
                  counter: Offstage(),
                ),
              ),
              ontap: () {},
              color: Color.fromARGB(255, 255, 254, 254),
            ).paddingOnly(
              bottom: 10,
            ),
      
            // subject
      
            Text(
              'Subject',
              style: TextStyle(
                color: appcolor().mediumGreyColor,
                // fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            blockButton(
              title: TextFormField(
                maxLines: 1,
                maxLength: 20,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: InputBorder.none,
                  counter: Offstage(),
                ),
              ),
              ontap: () {},
              color: Color.fromARGB(255, 255, 254, 254),
            ).paddingOnly(
              bottom: 10,
            ),
      
            Text(
              'Message',
              style: TextStyle(
                color: appcolor().mediumGreyColor,
                // fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Container(
              height: Get.height * 0.3,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffe0e6ec),
                  ),
                  borderRadius: BorderRadius.circular(
                    10,
                  )),
              child: TextFormField(
                maxLines: 8,
                maxLength: 20,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: InputBorder.none,
                  counter: Offstage(),
                ),
              ),
            ),
      
            SizedBox(
              height: Get.height * 0.14,
            ),
            blockButton(
              title: Text(
                'Send Message',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ontap: () {},
              color: appcolor().mainColor,
            ).paddingOnly(
              bottom: 20,
            )
          ],
        ).paddingSymmetric(horizontal: 15, vertical: 10),
      ),
    );
  }
}
