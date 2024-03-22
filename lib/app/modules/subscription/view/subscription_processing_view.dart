import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/controller/subscription_controller.dart';
import 'package:errandia/app/modules/subscription/view/manage_subscription_view.dart';
import 'package:errandia/app/modules/subscription/view/subscription_success_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class payment_processing_view extends StatefulWidget {
  final paymentData;

  const payment_processing_view({super.key, this.paymentData});

  @override
  _payment_processing_viewState createState() => _payment_processing_viewState();
}

class _payment_processing_viewState extends State<payment_processing_view> {
  late subscription_controller subscriptionController;

  @override
  void initState() {
    super.initState();
    subscriptionController = Get.put(subscription_controller());
  }

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
                      // Get.to(const payment_success_view());
                      // Get.back();
                      Get.back(result: 'Reload Subscriptions');
                      Get.back();
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
              SizedBox(
                height: Get.height * 0.3,
                child: const Image(
                  image: AssetImage(
                    'assets/images/icon - processing-payment.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Processing Payment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),

              // to confirm subs...
              SizedBox(
                width: Get.width * 0.72,
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'A Mobile Money alert will be sent to you shortly to confirm your ${widget.paymentData['name']} subscription of ',
                    children: [
                      TextSpan(
                        text: '${
                            formatPrice(double.parse(
                                widget.paymentData['unit_price'].toString()))
                        }.',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // TextButton(
              //   onPressed: () {},
              //   child: const Text(
              //     'Dial #123#',
              //     style: TextStyle(
              //       fontSize: 18,
              //       decoration: TextDecoration.underline,
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 80,
              ),

              SizedBox(
                width: Get.width * 0.72,
                child: const Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text:
                    'If you have questions or need support contact us at ',
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
