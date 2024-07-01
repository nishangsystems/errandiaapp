import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MyDialogType { error, success, info }

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String message;
  final MyDialogType dialogType;
  final Future<void> Function() onConfirm;
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
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  bool isLoading = false;

  Color getDialogColor() {
    switch (widget.dialogType) {
      case MyDialogType.error:
        return Colors.red;
      case MyDialogType.success:
        return Colors.green;
      case MyDialogType.info:
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  void handleConfirm() async {
    setState(() {
      isLoading = true;
    });
    await widget.onConfirm();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              widget.title,
              style: TextStyle(
                color: getDialogColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                widget.message,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            blockButton(
              title: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
              ontap: isLoading ? () {} : handleConfirm,
              color: getDialogColor(),
            ),
            SizedBox(height: Get.height * 0.015),
            blockButton(
              title: Text(
                'Cancel',
                style: TextStyle(color: getDialogColor()),
              ),
              ontap: isLoading ? () {} : handleConfirm,
              color: const Color(0xfffafafa),
            ),
          ],
        ).paddingSymmetric(horizontal: 10, vertical: 10),
      ),
    );
  }
}
