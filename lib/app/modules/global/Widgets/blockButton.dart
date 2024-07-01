import 'package:flutter/material.dart';
import 'package:get/get.dart';

class blockButton extends StatelessWidget {
  blockButton({
    Key? key,
    required this.title,
    required this.ontap,
    required this.color,
    this.textcolor,
    this.bordercolor,
  }) : super(key: key);

  final Widget title;
  final VoidCallback ontap;
  final Color color;
  final Color? textcolor;
  final Color? bordercolor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: bordercolor ?? Color(0xffe0e6ec),
          ),
          color: color,
        ),
        child: Center(
          child: title,
        ),
      ),
    );
  }
}
