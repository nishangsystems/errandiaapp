
import 'dart:convert';

import 'package:errandia/app/APi/business.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyBusinessOtp extends StatefulWidget {
  final Map<String, dynamic> businessData;
  const VerifyBusinessOtp({Key? key, required this.businessData}) : super(key: key);
  @override
  _VerifyBusinessOtpState createState() => _VerifyBusinessOtpState();
}

class _VerifyBusinessOtpState extends State<VerifyBusinessOtp> {
  TextEditingController? otpController = TextEditingController();
  RxInt x = 0.obs;
  bool isLoading = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late PopupBox popupBox;


  Future<String?> getShopUuid() async {
    final SharedPreferences prefs = await _prefs;
    final String? uuid = prefs.getString('shopUuid');
    return uuid;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final String identifier = widget.businessData['phone'].contains("+237") ? widget.businessData['phone'].substring(4).trim() : widget.businessData['phone'];
    final String phoneNumber = isNumeric(identifier) ? "+237 $identifier" : "";

    print("identifier: ${widget.businessData['phone']}");
    print('phone number: $phoneNumber');

    return Scaffold(
      appBar: titledAppBar(
      'Verify Business',
      []
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: ListView(
            children: [
              SizedBox(
                height: Get.height * 0.025,
              ),

              SizedBox(
                height: Get.height * 0.015,
              ),
              Column(
                children: [
                  const Text(
                    'ENTER BUSINESS',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff113d6b),
                    ),
                  ),
                  const Text(
                    'VERIFICATION CODE',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff113d6b),
                    ),
                  ),

                  SizedBox(
                    height: Get.height * 0.03,
                  ),

                  //
                  Column(
                    children: [
                      const Text(
                        'Enter the 4 - digit code you received',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff8ba0b7),
                        ),
                      ),
                      Text(
                        'on $phoneNumber',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff8ba0b7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              //

              SizedBox(
                height: Get.height * 0.1,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: PinCodeTextField(
                          pinTheme: PinTheme(
                            inactiveColor: appcolor().greyColor,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          autoFocus: true,
                          appContext: context,
                          length: 4,
                          onChanged: (value) {
                            x.value = value.length;
                            // otpText = value;
                            debugPrint(value);
                          }),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Didn\'t receive a code?',
                          style:
                          TextStyle(color: Color(0xff8ba0b7), fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () async {
                            // var value = {
                            //   "identifier": widget.businessData['identifier']?.toString(),
                            // };
                            // signin_otp_verification_screen verifyCodeView =
                            // signin_otp_verification_screen(
                            //   otpData: value,
                            // );
                            //
                            // isLoading = true;
                            //
                            // try {
                            //   await api().login(
                            //       value,
                            //       context ?? scaffoldKey.currentContext!,
                            //       verifyCodeView,
                            //       "");
                            // } finally {
                            //   isLoading = false;
                            // }
                          },
                          child: const Text(
                            'Request Again',
                            style: TextStyle(
                                color: Color(0xff35c77e), fontSize: 15),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: Get.height * 0.2,
                    ),

                    //button container
                    SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            if (kDebugMode) {
                              print("otp code: ${otpController?.text}");
                            }
                            var value = {
                              "code": otpController?.text,
                              "uuid": await getShopUuid(),
                            };

                            if (kDebugMode) {
                              print("value: $value");
                            }

                            // Home_view home = Home_view();
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              print("isLoading: $isLoading");

                              await BusinessAPI.validateBusinessOtp(widget.businessData['slug'], value).then((response) async {
                                print("validate shop otp response: $response");

                                var data = jsonDecode(response);

                                if (data != null) {
                                  if (data['status'] == "success") {
                                    print("validate shop otp data: ${data['data']['data']}");

                                    popupBox = PopupBox(
                                      title: "Success",
                                      description: "Your business has been verified successfully",
                                      type: PopupType.success,
                                      callback: () {
                                        // Get.back();
                                        Get.back(result: data['data']['data']['item']);
                                      },
                                    );

                                    popupBox.showPopup(context);

                                  } else {
                                    print("validate shop otp error: $data");
                                    Get.snackbar("Error", data['data']['data']['error'].contains('Invalid OTP') ? 'Invalid Verification code or code has expired!' : data['data']['data']['error'],
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 10),
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                }
                              });

                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff113d6b),
                              foregroundColor: Colors.white),
                          child: isLoading == false
                              ? const Text(
                            'CONTINUE',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )
                              : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
              ),

              SizedBox(
                height: Get.height * 0.03,
              ),


            ],
          ),
        ),
      ),
    );
  }
}