import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';

import 'package:errandia/app/modules/auth/Register/service_Provider/view/service_category_screen_service_provider.dart';

import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:errandia/app/modules/global/Widgets/GlobalDialogBoxtext.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../registration_failed_view.dart';
import '../../registration_successful_view.dart';

class register_serviceprovider_view extends StatefulWidget {
  const register_serviceprovider_view({super.key});

  @override
  State<register_serviceprovider_view> createState() =>
      _register_serviceprovider_viewState();
}

class _register_serviceprovider_viewState
    extends State<register_serviceprovider_view> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNo = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController cPassword_ = TextEditingController();

  bool isSelected = false;
  bool isLoading = false;

  void _showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  '1. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                ),
                Text(
                  '2. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                ),
                Text(
                  '3. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                ),
                Text(
                  '4. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                ),
                Text(
                  '5. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                ),
                Text(
                  '6. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                ),
                // Add more terms and conditions as needed
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  //termsAccepted = true; // Set termsAccepted to true on Accept
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  imagePickercontroller image_pick_controller =
      Get.put(imagePickercontroller());
  final textFieldFocusNode = FocusNode();
  final textFieldFocusNode1 = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  bool _obscured1 = true;

  void _toggleObscured1() {
    setState(() {
      _obscured1 = !_obscured1;
      if (textFieldFocusNode1.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode1.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image(
          image: const AssetImage('assets/images/icon-errandia-logo-about.png'),
          width: Get.width * 0.3,
        ),
        // elevation: 0.8,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: ListView(
          children: [
            Divider(
              color: Colors.grey.shade300,
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),

            const Column(
              children: [
                Text(
                  'Register your\n Errandia Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff113d6b),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            //

            SizedBox(
              height: Get.height * 0.01,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(
                    height: Get.height * 0.001,
                  ),

                  // text form field
                  Container(
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xffe0e6ec),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: name,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: Get.height * 0.02,
                  ),

                  // buiseness phone number
                  const Text(
                    'Phone',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(
                    height: Get.height * 0.001,
                  ),

                  // phone number text field
                  Container(
                    height: Get.height * 0.09,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xffe0e6ec),
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: Get.width * 0.86,
                            child: IntlPhoneField(
                              controller: phoneNo,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 22),
                                  border: InputBorder.none),
                              initialCountryCode: 'CM',
                              validator: (value) {
                                if (value == null) {
                                  print(value);
                                }
                                return null;
                              },
                              onChanged: (phone) {
                                if (kDebugMode) {
                                  print("phone: $phone");
                                }
                              },
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        // by registering
                      ],
                    ),
                  ),

                  SizedBox(
                    height: Get.height * 0.02,
                  ),

                  // buiseness email

                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(
                    height: Get.height * 0.001,
                  ),

                  // text form field
                  Container(
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xffe0e6ec),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ),

                  // by registering you agree
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Checkbox(
                      //   checkColor: Colors.white,
                      //   // fillColor: Colors.red,
                      //   value: isSelected,
                      //   onChanged: (bool? value) {
                      //     setState(() {
                      //       isSelected = value!;
                      //     });
                      //   },
                      // ),
                      const Text(
                        "By registering, you agree to the Errandia's ",
                        style: TextStyle(fontSize: 12),
                      ),
                      InkWell(
                          onTap: () {
                            _showTermsAndConditionsDialog(context);
                          },
                          child: const Text(
                            "User's ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            _showTermsAndConditionsDialog(context);
                          },
                          child: const Text(
                            "Agreement ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blue),
                          )),
                      const Text("and "),
                      const Text(
                        "Privacy Policy",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: Get.height * 0.04,
                  ),

                  //button container

                  InkWell(
                    onTap: () async {
                      var Name = name.text.trim().toString();
                      var Phone = phoneNo.text.trim().toString();
                      var Email = email.text.trim().toString();

                      if (name == '' &&
                          email == '' &&
                          Phone == '') {
                        alertDialogBox(
                            context, 'Alert', 'Please Fill Fields');
                      }
                      // }else if(isSelected == false){
                      //   alertBoxdialogBox(context, 'Alert', 'Please agree Terms and Conditon');
                      else {
                        var value = {
                          "name": Name,
                          "email": Email,
                          // "country": phone.,
                          "phone": Phone,
                        };
                        print("value: $value");
                        registration_successful_view home =
                            registration_successful_view(userAction: const {
                          "name": "register",
                            });
                        registration_failed_view failed =
                            registration_failed_view();
                        setState(() {
                          isLoading = true;
                        });
                        // api().registration('register', value, context,home,failed);
                        try {
                          await api().registration(value, context, home, failed);
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                        // Future.delayed(const Duration(seconds: 3),(){
                        //   setState(() {
                        //     isLoading = false;
                        //   });
                        // });
                      }
                      // Get.to(Home_view());
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
                      child: Center(
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xff8ba0b7),
                      fontSize: 17,
                    ),
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            debugPrint('sign in');
                            Get.off(() => signin_view());
                          },
                        text: 'Sign In',
                        style: const TextStyle(
                          color: Color(0xff3c7fc6),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]),
              ),
            ),

            SizedBox(
              height: Get.height * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
