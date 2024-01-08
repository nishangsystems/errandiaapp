import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class review_view extends StatelessWidget {
  const review_view({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Review Errandia',
          style: TextStyle(
            color: Colors.black,
            // fontWeight: FontWeight.w600,
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
              'Rate Errandia *',
              style: TextStyle(
                // color: appcolor().mediumGreyColor,
                // fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),

            RatingBar.builder(
              glow: true,
              allowHalfRating: true,
              initialRating: 4,
              minRating: 1,
              itemCount: 5,
              tapOnlyMode: true,
              unratedColor: appcolor().greyColor,
              itemBuilder: (context, index) {
                return Icon(
                  Icons.star_rounded,
                  size: 35,
                  color: Colors.amber,
                );
              },
              onRatingUpdate: (val) {},
            ).paddingOnly(
              bottom: 15,
              top: 10
            ),

            // subject

            Text(
              'Title *',
              style: TextStyle(
                // color: appcolor().mediumGreyColor,
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
              'Review *',
              style: TextStyle(
                // color: appcolor().mediumGreyColor,
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
          ],
        ).paddingSymmetric(horizontal: 15, vertical: 10),
      ),
    );
  }
}
