import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color.dart';

class errandia_widget extends StatelessWidget {
  errandia_widget({
    super.key,
    this.cost,
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        height: Get.height * 0.4,
        color: Colors.white70,
        width: Get.width * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // height: Get.height * 0.15,
              color: appcolor().lightgreyColor,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/errandia_logo.png', // Local asset image
                image: getImagePathWithSize(imagePath.toString(), width: 200, height: 180),
                fit: BoxFit.contain,
                width: double.infinity,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/errandia_logo.png', // Your fallback image
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: Get.height * 0.17,
                  );
                },
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            location != null && location.toString().isNotEmpty == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 13,
                        color: appcolor().mediumGreyColor,
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: Text(
                          location.toString(),
                          style: TextStyle(
                            color: appcolor().mediumGreyColor,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ),
                    ],
                  )
                : Text(
                    "No location provided",
                    style: TextStyle(
                      fontSize: 11,
                      color: appcolor().mediumGreyColor,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            SizedBox(
              width: Get.width * 0.4,
              child: Text(
                capitalizeAll(name!),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: appcolor().mainColor),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            cost.toString() != "null" && cost.toString().isNotEmpty == true
                ? // text with suffix XAF 2000
            Text(
              formatPrice(double.parse(cost!)),
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: appcolor().mainColor,
                  fontSize: 14),
            )
                : Container()
          ],
        ));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['imagePath'] = this.imagePath;
    data['location'] = this.location;
    data['cost'] = this.cost;
    return data;
  }
}
