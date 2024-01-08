import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/manage_review/controller/manage_review_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/constants/color.dart';

class manage_review_view extends StatelessWidget {
  manage_review_view({super.key});
  manage_review_controller controller = Get.put(manage_review_controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            // size: 30,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Manage Reviews',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
          size: 30,
        ),
        actions: [
          Container(),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 20,
          ),
          blockButton(
            title: Container(
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    suffixIcon: Icon(
                      Icons.search,
                    ),
                    hintText: 'Search Enquiries'),
              ),
            ),
            ontap: () {},
            color: Colors.white,
          ).paddingSymmetric(horizontal: 15),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.review_list.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // if (controller.selectedCounter.value > 0) {
                        //   if (controller.allenquiry_list[index].isSelected ==
                        //       false) controller.selectedCounter.value++;
                        //   controller.allenquiry_list[index].isViewed = true;
                        //   controller.allenquiry_list[index].isSelected = true;
                        // } else {
                        //   controller.allenquiry_list[index].isViewed =
                        //       !controller.allenquiry_list[index].isViewed!;
                        // }
                        // setState(() {});
                      },
                      onLongPress: () {
                        // controller.allenquiry_list[index].isViewed = true;
                        // controller.selectedCounter.value++;
                        // controller.allenquiry_list[index].isSelected = true;

                        // setState(() {});
                      },
                      child: Container(
                        // height: Get.height * 0.2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: 10,
                                left: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                              ),
                              width: Get.width * 0.12,
                              height: Get.height * 0.06,
                              child: Image(
                                image: AssetImage(
                                  controller.review_list[index].image_url
                                      .toString(),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              controller
                                                  .review_list[index].title
                                                  .toString(),
                                              style: TextStyle(
                                                color: appcolor().mainColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                          ),
                                          Container(
                                            width: Get.width * 0.6,
                                            child: Text(
                                              controller.review_list[index]
                                                  .description
                                                  .toString(),
                                              style: TextStyle(
                                                color:
                                                    appcolor().mediumGreyColor,
                                                fontSize: 10,
                                                // fontWeight: FontWeight.w300,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        child: IconButton(
                                          icon: Icon(Icons.more_vert),
                                          onPressed: () {
                                            Get.bottomSheet(
                                                customBottomSheet());
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        controller.review_list[index].Date
                                            .toString(),
                                        style: TextStyle(
                                          color: appcolor().mediumGreyColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Color.fromARGB(
                                                255, 247, 236, 199)),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              controller
                                                      .review_list[index].rating
                                                      .toString() +
                                                  ' Rating',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    indent: 5,
                                    height: 25,
                                    color: appcolor().mediumGreyColor,
                                  ).paddingSymmetric(
                                    vertical: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8,
                                        ),
                                        color: appcolor().greyColor),
                                    child: Wrap(
                                      children: [
                                        Container(
                                          height: 15,
                                          child: Image(
                                            image: AssetImage(
                                              controller
                                                  .review_list[index].image_url
                                                  .toString(),
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Text(
                                          '  Universal Laptop Charger',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget customBottomSheet() {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 15,
    ),
    color: Colors.white,
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        Icon(
          Icons.horizontal_rule_outlined,
          size: 30,
        ),
        SizedBox(
          height: Get.height * 0.06,
        ),
        InkWell(
          onTap: (){},
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.eye,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'View Detail',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 10),
        ),
        InkWell(
          onTap: (){},
          child: Row(
            children: [
              Icon(FontAwesomeIcons.fileCircleExclamation,
                  color: appcolor().redColor),
              SizedBox(
                width: 20,
              ),
              Text(
                'Report Review',
                style: TextStyle(
                  fontSize: 16,
                  color: appcolor().redColor,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 15),
        ),
        Container(height: 15,),
      ],
    ),
  );
}
