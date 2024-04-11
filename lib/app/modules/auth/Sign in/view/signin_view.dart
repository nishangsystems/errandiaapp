import 'dart:convert';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/modules/auth/Register/register_ui.dart';
import 'package:errandia/app/modules/auth/Register/service_Provider/view/Register_serviceprovider_view.dart';
import 'package:errandia/app/modules/auth/Sign%20in/controller/signin_controller.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/forget_password.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_otp_verification_screen.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/auth_services/firebase_auth_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signin_view extends StatefulWidget {
  const signin_view({super.key});

  @override
  State<signin_view> createState() => _signin_viewState();
}

class _signin_viewState extends State<signin_view>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late signIn_controller signInController;

  TextEditingController _phoneContoller = TextEditingController();
  TextEditingController _otpContoller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  final TextEditingController _emailPhoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool isSelected = true;
  bool isSelected2 = false;
  bool isLoading = false;
  bool isPhone = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.8,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff113d6b),
          ),
        ),
        title: Image(
          image: const AssetImage('assets/images/icon-errandia-logo-about.png'),
          width: Get.width * 0.3,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Column(
                children: [
                  Text(
                    'LOGIN TO YOUR ERRANDIA ACCOUNT',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff113d6b),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Text(
                  //   'ACCOUNT',
                  //   style: TextStyle(
                  //     fontSize: 26,
                  //     fontWeight: FontWeight.w700,
                  //     color: Color(0xff113d6b),
                  //   ),
                  // ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          height: Get.height * 0.09,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xffe0e6ec),
                            ),
                            color: Colors.white,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            child: TextFormField(
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              controller: _emailPhoneController,
                              keyboardType: isPhone
                                  ? TextInputType.number
                                  : TextInputType.emailAddress,
                              maxLength: isPhone ? 9 : 100,
                              onChanged: (value) {
                                if (kDebugMode) {
                                  print("value: $value");
                                }
                                if (isNumeric(value)) {
                                  setState(() {
                                    isPhone = true;
                                  });
                                } else if (value.contains('@') ||
                                    value.isEmpty) {
                                  setState(() {
                                    isPhone = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Phone number or email",
                                border: InputBorder.none,
                                prefixText: isPhone ? "+237 " : "",
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                alignLabelWithHint: true,
                                counter: const Offstage(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number or email';
                                }

                                if (isPhone) {
                                  if (value.length != 9) {
                                    return 'Please enter a valid phone number';
                                  }
                                } else {
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                }
                                // You can add additional validation logic here
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              var value = {"identifier": _emailPhoneController.text};
                              signin_otp_verification_screen verifyCodeView = signin_otp_verification_screen(
                                otpData: value,
                              );

                              setState(() {
                                isLoading = true;
                              });

                              if (kDebugMode) {
                                print("value: $value");
                              }

                              try {
                                await api().login(value, context ?? scaffoldKey.currentContext!, verifyCodeView, "");
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff113d6b),
                              foregroundColor: Colors.white),
                          child: isLoading == false
                              ? const Text(
                            'Continue',
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
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            color: Color(0xff8ba0b7), fontSize: 17),
                        children: [
                          const TextSpan(
                              text: 'Don\'t have an Errandia Account? '),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                debugPrint('Register View');
                                Get.to(() => const register_serviceprovider_view());
                              },
                            text: 'Register',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3c7fc6),
                            ),
                          )
                        ]),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
