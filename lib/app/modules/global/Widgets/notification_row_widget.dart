import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationRowWidget extends StatelessWidget {
  final String title;
  final String body;
  final String time;

  const NotificationRowWidget({
    Key? key,
    required this.title,
    required this.body,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: appcolor().mediumGreyColor.withOpacity(0.2),
              width: 1,
            ),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  'assets/images/notifications_icon.png',
                ),
              ),

              SizedBox(
                width: Get.width * 0.03,
              ),
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'New Subscriber',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),

                        // const Spacer(),
                        SizedBox(
                          width: Get.width * 0.12,
                        ),
                        Text(
                          '2 hours ago',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: appcolor().mediumGreyColor,
                          ),
                        ),
                      ]),

                  SizedBox(
                    width: Get.width * 0.7,
                    child: Text(
                      "lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      style: TextStyle(
                        fontSize: 14,
                        color: appcolor().mediumGreyColor,
                      ),
                    )
                  )
                ],
              ),


            ],
          ),
        ],
      ),
    );
  }
}
