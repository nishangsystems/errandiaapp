import 'package:errandia/app/modules/auth/Register/register_ui.dart';
import 'package:errandia/app/modules/auth/Register/service_Provider/view/Register_serviceprovider_view.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class register_signin_screen extends StatelessWidget {
  const register_signin_screen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Errandia App is Online 😊');
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 97, 165),
      body: SafeArea(
        child: Stack(
          children: [
            Image(
              image: AssetImage(
                'assets/images/register_bg.png',
              ),
              height: Get.height,
              fit: BoxFit.fill,
              width: Get.width,
            ),
           
            // main screen 
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.15,
                ),
                Image(
                  image: AssetImage(
                    'assets/errandia logo.png',
                  ),
                  height: Get.height*0.125,
                  width: Get.width * 0.6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Column(
                      children: const [
                        Text(
                          'To start running errands with Errandia, you need to have an Errandia',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Text(
                        //   'need to have an Errandia',
                        //   style: TextStyle(
                        //     fontSize: 17,
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),

                // register button
                InkWell(
                  onTap: (){
                    Get.to(register_serviceprovider_view());
                  },
                  child: Container(
                    width: Get.width * 0.9,
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0XFF113d6b),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height*0.02,
                ),
                // sign in button
                InkWell(
                  onTap: (){
                    Get.to(signin_view());
                  },
                  child: Container(
                    width: Get.width * 0.9,
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      color: Color(0xff3c7fc6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
