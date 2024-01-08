import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class payment_failed_view extends StatelessWidget {
  const payment_failed_view({super.key});

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
                    onPressed: () {},
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
                    'assets/images/icon-failed.png',
                  ),
                  fit: BoxFit.fill,
                ),
                height: Get.height * 0.3,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Subscription Failed',
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
                    text:
                        'Sorry we could not process your payment at this time',
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
              SizedBox(
                height: 30,
              ),
              blockButton(
                      title: Text(
                        'Try Again',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      ontap: () {},
                      color: appcolor().redColor)
                  .paddingSymmetric(horizontal: 20)
            ],
          ),
        ),
      ),
    );
  }
}
