import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color.dart';

class errandia_widget extends StatelessWidget {
  errandia_widget({
    super.key,
    @required this.cost,
    @required this.imagePath,
    @required this.name,
    @required this.location,
  });
  String? name;
  String? imagePath;
  String? location;
  String? cost;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.only(
          // right: 10,
          top: 10,
          bottom: 10,
        ),
        // height: Get.height * 0.15,
        color: Colors.white,
        // width: Get.width * 0.38,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: Get.height * 0.15,
                child: Image(
                  image: AssetImage(
                    imagePath.toString(),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: appcolor().mediumGreyColor,
                  ),
                  Text(
                    location.toString(),
                    style: TextStyle(
                        color: appcolor().mediumGreyColor, fontSize: 12),
                  )
                ],
              ),
              Text(
                name.toString(),
                style: TextStyle(fontSize: 13, color: appcolor().mainColor),
                textAlign: TextAlign.center,
              ),
              Text(
                cost.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: appcolor().mainColor,
                    fontSize: 16),
              )
            ],
          ),
        ));
  }
}
