import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/view/subscription_failed_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class payment_success_view extends StatelessWidget {
  const payment_success_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(payment_failed_view());
                    },
                    icon: Icon(
                      FontAwesomeIcons.xmark,
                      color: appcolor().mediumGreyColor,
                      size: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.08,
              ),
              Container(
                child: Image(
                  image: AssetImage(
                    'assets/images/icon-success.png',
                  ),
                  fit: BoxFit.fill,
                ),
                height: Get.height * 0.3,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Subscription Successful',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),

              // to confirm subs...
              Container(
                width: Get.width * 0.8,
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'You have successfully Subscribed to the Yearly Package and this cost you ',
                    children: [
                      TextSpan(
                        text: 'XAF 6,000',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: 'Your subscription will expire on January 1st, 2024')
                    ],
                  ),
                ),
              ),

              
              SizedBox(
                height: 30,
              ),

              Container(
                width: Get.width * 0.8,
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text:
                        'If you have questions or need support contact us on ',
                    children: [
                      TextSpan(
                        text: 'admin@errandia.com',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
