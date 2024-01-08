import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class registration_failed_view extends StatelessWidget {
  registration_failed_view({super.key});
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 35),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Get.height*0.45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            ),
                        child: Center(
                          child: Image(
                            image: AssetImage('assets/images/failed_image.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                'Registration Failed',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xffff0000),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: Get.height * 0.01,
                            ),

                            //
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff8ba0b7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                 
                                  SizedBox(
                                    height: Get.height * 0.02,
                                  )
                                ],
                              ),
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
                  Get.offAll(Home_view());
                },
                child: Container(
                  height: Get.height * 0.09,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xffe0e6ec),
                    ),
                    color: Color(0xffff0000),
                  ),
                  child: Center(
                    child: Text(
                      'TRY AGAIN',
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
