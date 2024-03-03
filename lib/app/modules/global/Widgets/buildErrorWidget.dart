
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
          children: [
            const Icon(
              Icons.error,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
             message ?? 'An error occurred, please try again later',
              style: TextStyle(
                color: appcolor().greyColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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