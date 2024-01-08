import 'package:errandia/app/modules/auth/Register/registration_successful_view.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Register/register_ui.dart';

class signin_otp_verification_screen extends StatelessWidget {
  signin_otp_verification_screen({super.key});
  RxInt x = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.8,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff113d6b),
          ),
        ),
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
              Container(
                child: Column(
                  children: [
                    Text(
                      'ENTER',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff113d6b),
                      ),
                    ),
                    Text(
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
                    Container(
                      child: Column(
                        children: [
                          Text(
                            'Enter the 4 - digit code you received',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff8ba0b7),
                            ),
                          ),
                          Text(
                            'on +237 678 245 693',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff8ba0b7),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff8ba0b7),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Wrong Number? ',
                                ),
                                TextSpan(
                                  text: 'Try another phone',
                                  style: TextStyle(
                                    color: Color(0xff113d6b),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            'number',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff113d6b),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //

              SizedBox(
                height: Get.height * 0.1,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
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
                            // controller: otpcontroller,
                            keyboardType: TextInputType.number,
                            autoFocus: true,
                            appContext: context,
                            length: 4,
                            onChanged: (value) {
                              x.value = value.length;
                              debugPrint(value);
                            }),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Didn\'t receive a code?',
                            style: TextStyle(
                                color: Color(0xff8ba0b7), fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Request Again',
                              style: TextStyle(
                                  color: Color(0xff35c77e), fontSize: 15),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: Get.height * 0.13,
                      ),

                      //button container

                      InkWell(
                        onTap: () {
                          Get.to(registration_successful_view());
                        },
                        child: Container(
                          height: Get.height * 0.09,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color(0xffe0e6ec),
                            ),
                            color: Color(0xff113d6b),
                          ),
                          child: Center(
                            child: Text(
                              'CONTINUE',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: Get.height * 0.08,
              ),

              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Color(0xff8ba0b7), fontSize: 17),
                      children: [
                        TextSpan(text: 'Don\'t have an Errandia Account? '),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              debugPrint('Register View');
                              Get.offAll(Register_Ui());
                            },
                          text: 'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3c7fc6),
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
