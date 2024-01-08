import 'package:flutter/material.dart';
import 'package:get/get.dart';

class blockButton extends StatelessWidget {
  blockButton(
      {super.key,
      required this.title,
      required this.ontap,
      required this.color,
      this.textcolor,
      this.bordercolor});
  Widget title;
  VoidCallback ontap;
  Color color;
  Color? textcolor= Colors.white;
  Color? bordercolor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: bordercolor==null?Color(0xffe0e6ec):bordercolor!,
          ),
          color: color,
        ),
        child: Center(
          child: title
        ),
      ),
    );
  }
}
