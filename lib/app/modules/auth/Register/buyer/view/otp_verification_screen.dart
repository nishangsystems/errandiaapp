import 'package:errandia/app/modules/auth/Register/registration_successful_view.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class register_otp_verification_screen extends StatelessWidget {
  register_otp_verification_screen({super.key});
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
                      'ENTER\nVERIFICATION CODE',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff113d6b),
                      ),
                      textAlign: TextAlign.center,
                    ),
                   

                    SizedBox(
                      height: Get.height * 0.03,
                    ),

                    //
                    Container(
                      child: Column(
                        children: [
                          Text(
                            'Enter the 4 - digit code you received\non +237 678 245 693',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff8ba0b7),
                            ),
                            textAlign: TextAlign.center,
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
                            'Didn\'t receive a code? ',
                            style: TextStyle(
                                color: Color(0xff8ba0b7), fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Request Again',
                              style: TextStyle(
                                color: Color(0xff35c77e),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: Get.height * 0.15,
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
                                  fontWeight: FontWeight.w500,
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
                height: Get.height * 0.06,
              ),

              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Color(0xff8ba0b7), fontSize: 17),
                      children: [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                            recognizer: TapGestureRecognizer()..onTap=()=> {
                              Get.to(signin_view()),
                            },
                            text: 'Sign In',
                            style: TextStyle(color: Color(0xff3c7fc6)))
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


