
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ErrandWidgetCard extends StatelessWidget {
  final data;

  const ErrandWidgetCard({
    super.key,
    this.data,
  });

  String _formatAddress(Map<String, dynamic> item) {
    print("item: $item");
    // String street = item['street'].toString() != '[]' && '';
    String townName =
    item['town'].toString() != 'null' && item['town'].toString() != '[]'  ? item['town']['name'] : '';
    String regionName = item['region'].toString() != 'null' && item['region'].toString() != '[]'
        ? item['region']['name'].split(" -")[0]
        : '';

    return [townName, regionName].where((s) => s.isNotEmpty).join(", ").trim();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: Get.width * 0.5,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height * 0.09,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: appcolor().mainColor,
                    backgroundImage: data['user']['photo'] == ""
                        ? const AssetImage(
                        'assets/images/errandia_logo.png') // Fallback image
                        : NetworkImage(getImagePath(
                        data['user']['photo'].toString()))
                    as ImageProvider,
                  ),
                  SizedBox(
                    width: Get.width * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.33,
                        child: Text(
                          capitalizeAll(data['user']['name']),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy').format(
                            DateTime.parse(
                                data['created_at'].toString())),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: appcolor().mediumGreyColor,
            ),
            Container(
              height: Get.height * 0.2,
              margin: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 0),
              color: appcolor().lightgreyColor,
              child: Center(
                child: data['images'].length > 0
                    ? FadeInImage.assetNetwork(
                  placeholder:
                  'assets/images/errandia_logo.png',
                  image: getImagePathWithSize(
                      data['images'][0]['image_path']
                          .toString(),
                      width: 200,
                      height: 180),
                  fit: BoxFit.cover,
                  imageErrorBuilder:
                      (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/errandia_logo.png',
                      // Your fallback image
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : Image.asset(
                  'assets/images/errandia_logo.png',
                  // Your fallback image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Divider(
              color: appcolor().mediumGreyColor,
            ),
            SizedBox(
              height: Get.height * 0.009,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   Featured_Businesses_Item_List[index]
                  //       .servicetype
                  //       .toString(),
                  //   style: TextStyle(
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.bold,
                  //       color: appcolor().mediumGreyColor),
                  // ),
                  // SizedBox(
                  //   height: Get.height * 0.001,
                  // ),
                  SizedBox(
                    width: Get.width * 0.42,
                    child: Text(
                      capitalizeAll(data['title'].toString()),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: appcolor().mainColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.001,
                  ),
                  data['region'].toString() != '[]' ||
                      data['town'].toString() != '[]'
                      ? Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 13,
                        color: appcolor().mediumGreyColor,
                      ),
                      SizedBox(
                        width: Get.width * 0.35,
                        child: Text(
                          _formatAddress(data),
                          style: TextStyle(
                            color:
                            appcolor().mediumGreyColor,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}