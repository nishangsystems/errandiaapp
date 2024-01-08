import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/view/subscription_success_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class payment_processing_view extends StatelessWidget {
  const payment_processing_view({super.key});

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
                      Get.to(payment_success_view());
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
                    'assets/images/icon - processing-payment.png',
                  ),
                  fit: BoxFit.fill,
                ),
                height: Get.height * 0.3,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Processing Payment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),

              // to confirm subs...
              Container(
                width: Get.width * 0.72,
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'To confirm subscription to the Yearly Package of X ',
                    children: [
                      TextSpan(
                        text: 'XAF 6,000',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: 'which will expire on January 1st, 2024 ')
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 15,
              ),

              TextButton(
                onPressed: () {},
                child: Text(
                  'Dial #123#',
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              Container(
                width: Get.width * 0.72,
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
