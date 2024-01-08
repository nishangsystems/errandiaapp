
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

Widget bottomSheetWidgetitem({
  required String title,
  required String imagepath,
  required Callback callback,
}) {
  return InkWell(
    // highlightColor: Colors.grey,

    hoverColor: Colors.grey,
    // focusColor: Colors.grey,
    // splashColor: Colors.grey,
    // overlayColor: Colors.grey,
    onTap: callback,
    child: Row(
      children: [
        Container(
          height: 24,
          child: Image(
            image: AssetImage(
              imagepath,
            ),
            color: Colors.black,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: 18,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 15),
  );
}
