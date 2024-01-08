import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/controller/subscription_controller.dart';
import 'package:errandia/app/modules/subscription/view/renew_subscription.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class subscription_view extends StatelessWidget {
  subscription_view();
  subscription_controller controller = Get.put(subscription_controller());
  Widget build(BuildContext context) {
    // TODO: implement build
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
          'Manage Subscription',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
          size: 30,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              itemCount: controller.list.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 238, 238),
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        // height: 60,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        child: Icon(
                          Icons.file_copy,
                          color: appcolor().greenColor,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(text: 'Subscription '),
                                TextSpan(
                                  text: controller.list[index].title.toString(),
                                  style: TextStyle(
                                    color: appcolor().mainColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'XAF' + '6000',
                            style: TextStyle(
                              color: appcolor().mainColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Expires :',
                                style: TextStyle(
                                    color: appcolor().mediumGreyColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${controller.list[index].Date}',
                                style: TextStyle(
                                    color: controller.list[index].color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: appcolor().greyColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: appcolor().mediumGreyColor),
                                      padding: EdgeInsets.all(
                                        5,
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.earth,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    Text(
                                      '  Cameroon',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.bottomSheet(customBottomSheet());
                        },
                        icon: Icon(
                          Icons.more_vert,
                        ),
                      ),
                    ],
                  ),
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
          onTap: () {
            Get.back();
            Get.to(renew_subscription());
          },
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.rotate,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Renew Subscription',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 10),
        ),
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Icon(FontAwesomeIcons.rectangleXmark, color: appcolor().redColor),
              SizedBox(
                width: 20,
              ),
              Text(
                'Cancel Subscription',
                style: TextStyle(
                  fontSize: 16,
                  color: appcolor().redColor,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 15),
        ),
        Container(
          height: 15,
        ),
      ],
    ),
  );
}
