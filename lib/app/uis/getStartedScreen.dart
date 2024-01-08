import 'package:errandia/app/modules/auth/Register/register_signin_screen.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class get_started_screen extends StatelessWidget {
  const get_started_screen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.off(Home_view());
          },
          child: Text('Skip'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: Get.height * 0.65,
                width: Get.width,
                child: Image(
                  image: AssetImage('assets/images/onboarding_girl.png'),
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Container(
                  child: Text(
                    'Stay at Home and Let Errandia do the Search',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff113d6b),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              InkWell(
                onTap: () {
                  Get.off(register_signin_screen());
                },
                child: Container(
                  height: Get.height * 0.07,
                  width: Get.width * 0.9,
                  child: Center(
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff113d6b),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
