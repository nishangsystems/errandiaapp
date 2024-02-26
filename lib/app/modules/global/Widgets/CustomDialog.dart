import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MyDialogType { error, success, info }

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final MyDialogType dialogType;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.dialogType,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getDialogColor() {
      switch (dialogType) {
        case MyDialogType.error:
          return Colors.red;
        case MyDialogType.success:
          return Colors.green;
        case MyDialogType.info:
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      scrollable: true,
      content: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: getDialogColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                message,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            blockButton(
              title: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
              ontap: onConfirm,
              color: getDialogColor(),
            ),
            SizedBox(height: Get.height * 0.015),
            blockButton(
              title: Text(
                'Cancel',
                style: TextStyle(color: getDialogColor()),
              ),
              ontap: onCancel,
              color: const Color(0xfffafafa),
            ),
          ],
        ).paddingSymmetric(horizontal: 10, vertical: 10),
      ),
    );
  }
}