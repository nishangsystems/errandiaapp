import 'package:errandia/app/modules/auth/Register/buyer/view/otp_verification_screen.dart';
import 'package:errandia/app/modules/auth/Register/register_signin_screen.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:errandia/app/modules/global/Widgets/GlobalDialogBoxtext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class buyer_register_view extends StatelessWidget {
  const buyer_register_view({super.key});

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
              Align(
                alignment: Alignment.center,
                child: Text(
                  'BUYER',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff3c7fc6),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.015,
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      'REGISTER YOUR ERRANDIA ACCOUNT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff113d6b),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              //

              SizedBox(
                height: Get.height * 0.03,
              ),

              //
              Container(
                child: Text(
                  'Create an account your Errandia account',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff8ba0b7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(
                height: Get.height * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Container(
                        height: Get.height * 0.09,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xffe0e6ec),
                          ),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: Get.width * 0.2,
                              height: Get.height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color(0xffe0e6ec),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/flag_icon.png',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: Get.width * 0.2,
                              child: Center(
                                child: Text(
                                  '+237',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 171, 173, 175),
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8,),
                                child: TextFormField(
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counter: Offstage(),
                                  ),
                                ),
                              ),
                            ),

                            // by registering
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'By registering, you agree to the Errandia\'s ',
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      // Get.defaultDialog(
                                      //   title: 'User Agreement',
                                      //   titleStyle: TextStyle(

                                      //   ),
                                      //   content: GlobalDialogBoxtext(),
                                      //   confirm: TextButton(onPressed: (){Get.back();}, child: Text('Accept',),),
                                      //   cancel: TextButton(onPressed: (){Get.back();}, child: Text('Accept',),),
                                      //   contentPadding: EdgeInsets.symmetric(horizontal: 20),

                                      // );
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return userAgreementContainer();
                                          });
                                    },
                                  text: 'User Agreement',
                                  style: TextStyle(
                                    color: Color(0xff3c7fc6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: ' and'),
                                TextSpan(
                                  text: ' Privacy Policy',
                                  style: TextStyle(
                                    color: Color(0xff3c7fc6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.15,
                      ),

                      //button container

                      InkWell(
                        onTap: () {
                          Get.to(register_otp_verification_screen());
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
                height: Get.height * 0.08,
              ),

              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Color(0xff8ba0b7), fontSize: 17),
                      children: [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              debugPrint('sign in');
                              Get.offAll(signin_view());
                            },
                          text: 'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3c7fc6),
                          ),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
