
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool showShop;

  const SearchItemWidget({
    required Key key,
    required this.item,
    this.showShop = true,
  }) : super(key: key);

  String _formatAddress(Map<String, dynamic> shop) {
    String street = shop['street'] ?? '';
    // String townName = shop['town'] != null ? shop['town']['name'] : '';
    String regionName = shop['region'] != null ? shop['region']['name'].split(' -')[0] : '';

    return capitalizeAll([street, regionName]
        .where((s) => s.isNotEmpty)
        .join(", ")
        .trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          Card(
            shadowColor: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              height: Get.height * 0.37,
              // color: Colors.blue,
              width: Get.width * 0.43,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height * 0.2,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/errandia_logo.png',
                      image: getImagePathWithSize(item['featured_image'], width: 200, height: 180),
                      fit: BoxFit.contain,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/errandia_logo.png',
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),

                  item['shop'] != null ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: appcolor().mediumGreyColor,
                        size: 15,
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: Text(
                          _formatAddress(item['shop']),
                          style: TextStyle(
                              color: appcolor().mediumGreyColor,
                              fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ).paddingOnly(
                    left: 3,
                    right: 3,
                  ): Container(),

                  SizedBox(
                    height: Get.height * 0.01,
                  ),

                  if (kDebugMode)
                    SizedBox(
                      width: Get.width * 0.4,
                      // height: 40,
                      child: Text(
                        capitalizeAll(item['name']+"lsl sslslsl slslslsl slslsls slslsls slsls slslslsls slslsls"),
                        style: TextStyle(
                          color: appcolor().mainColor,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ).paddingOnly(
                      left: 5,
                      right: 5,
                    ),

                  if (!kDebugMode)
                    SizedBox(
                      width: Get.width * 0.4,
                      // height: 40,
                      child: Text(
                        capitalizeAll(item['name']),
                        style: TextStyle(
                          color: appcolor().mainColor,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ).paddingOnly(
                      left: 5,
                      right: 5,
                    ),

                  SizedBox(
                    height: Get.height * 0.01,
                  ),

                  Row(
                    children: [
                      Text(
                        formatPrice(double.parse(item['unit_price'].toString())),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ).paddingOnly(
                    left: 4,
                    right: 4,
                  ),

                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  // contact shop button
                  // SizedBox(
                  //   width: Get.width * 0.4,
                  //   // height: 50,
                  //   child: blockButton(
                  //     title: const Padding(
                  //       padding: EdgeInsets.all(4.0),
                  //       child: Row(
                  //         mainAxisAlignment:
                  //         MainAxisAlignment.center,
                  //         children: [
                  //           Icon(
                  //             Icons.call,
                  //             color: Colors.white,
                  //             size: 15,
                  //           ),
                  //           SizedBox(
                  //             width: 7,
                  //           ),
                  //           Text(
                  //             // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
                  //             'Contact Shop',
                  //             style: TextStyle(
                  //               fontSize: 11,
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     ontap: () {
                  //       launchCaller(item['shop']['phone']);
                  //     },
                  //     color: appcolor().mainColor,
                  //   ),
                  // ).paddingOnly(
                  //   left: 4,
                  //   right: 4,
                  // ),
                ],
              ),
            ),
          ),
          //  business name and icon
          showShop ? SizedBox(
            width: Get.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/errandia_logo.png',
                    image: getImagePath(item['shop']['image']),
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/errandia_logo.png',
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),

                Flexible(
                  child: Text(
                    capitalizeAll(item['shop']['name']),
                    style: TextStyle(
                      fontSize: 12,
                      color: appcolor().mainColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
