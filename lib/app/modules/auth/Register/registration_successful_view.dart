import 'package:errandia/app/modules/auth/Register/registration_failed_view.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view_1.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../home/view/home_view.dart';

class registration_successful_view extends StatelessWidget {
  final Map<String, dynamic> userAction;
  registration_successful_view({super.key, required this.userAction});
  RxInt x = 0.obs;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.8,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 20),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            ),
                        child: Center(
                          child: Image(
                            image: const AssetImage('assets/images/success_image.png'),
                            fit: BoxFit.cover,
                            height: Get.height*0.5,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Container(
                        margin:const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            userAction['name'] == 'register' ?
                           const Text(
                              'Registration Successful',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff113d6b),
                              ),
                            ): const Text(
                              'Login Successful',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff113d6b),
                              ),
                            ),

                            SizedBox(
                              height: Get.height * 0.01,
                            ),

                            //
                            Column(
                              children: [
                                const Text(
                                  'Lorem Ipsum is simply dummy text the printing and typesetting industry',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff8ba0b7),
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                SizedBox(height: Get.height*0.02,)

                              ],
                            ),
                          ],
                        ),
                      ),

                      //button container
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (userAction['name'] == 'register') {
                    Get.to(const signin_view());
                  } else {
                    Get.to(() => Home_view());
                  }
                  //registration_failed_view(
                },
                child: Container(
                  height: Get.height * 0.09,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xffe0e6ec),
                    ),
                    color: const Color(0xff113d6b),
                  ),
                  child: const Center(
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
    );
  }
}
