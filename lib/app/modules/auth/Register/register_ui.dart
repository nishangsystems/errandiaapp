import 'package:errandia/app/modules/auth/Register/buyer/view/buyer_register_view.dart';
import 'package:errandia/app/modules/auth/Register/service_Provider/view/Register_serviceprovider_view.dart';
import 'package:errandia/app/modules/auth/Register/vendor/view/register_vendor_view.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class Register_Ui extends StatelessWidget {
  const Register_Ui({super.key});

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
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.05,
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

              SizedBox(
                height: Get.height * 0.03,
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      'Create an account to continue by selecting\none of the options below',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff8ba0b7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Text(
                    //   'one of the options below',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w500,
                    //     color: Color(0xff8ba0b7),
                    //   ),
                    // ),
                  ],
                ),
              ),

              SizedBox(
                height: Get.height * 0.1,
              ),

              // buttons for signup

           //   sign up as buyer
           //    button(Icons.person, () {
           //      Get.to(buyer_register_view());
           //    }, 'Sign up as Buyer'),
           //    SizedBox(
           //      height: Get.height * 0.025,
           //    ),

              // sign up as vendor
              button(Icons.person, () {
                Get.to(register_vendor_view());
              }, 'Sign Up as a Vendor'),
              SizedBox(
                height: Get.height * 0.025,
              ),

              // sign up as service provider
              button(
                Icons.person,
                () {
                  Get.to(register_serviceprovider_view());
                },
                'Sign up',
              ),
              Spacer(),

              RichText(
                text: TextSpan(
                    style: TextStyle(color: Color(0xff8ba0b7), fontSize: 17),
                    children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              debugPrint('sign in');
                              Get.off(signin_view());
                            },
                          text: 'Sign In',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3c7fc6)))
                    ]),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget button(IconData icon, var fun, String text) {
  return GestureDetector(
    onTap: fun,
    child: Container(
      height: Get.height * 0.09,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xffe0e6ec),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Color(0xff8ba0b7),
            ),
            SizedBox(
              width: Get.width * 0.015,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 13, color: Color(0xff113d6b)),
            ),
            Spacer(),
            IconButton(onPressed: fun, icon: Icon(Icons.arrow_forward_outlined))
          ],
        ),
      ),
    ),
  );
}
