
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class buildErrorWidget extends StatelessWidget {
  final VoidCallback? callback;
  final String? message;

  const buildErrorWidget(
      {Key? key, this.callback, this.message}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.5,
      width: Get.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Icon(
              Icons.error_outline,
              size: 50,
              color: appcolor().mediumGreyColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
             message ?? 'An error occurred, please try again later',
              style: TextStyle(
                color: appcolor().mediumGreyColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: callback ?? () {},
              style: ElevatedButton.styleFrom(
                primary: appcolor().mainColor,
              ),
              child: Text(
                'Retry',
                style: TextStyle(color: appcolor().lightgreyColor),
              ),
            ),
          ],
        ),
      )
    );
  }
}