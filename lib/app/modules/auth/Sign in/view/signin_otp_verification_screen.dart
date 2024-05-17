import 'package:errandia/app/APi/firebase_api.dart';
import 'package:errandia/app/modules/auth/Register/registration_successful_view.dart';
import 'package:errandia/app/modules/auth/Register/service_Provider/view/Register_serviceprovider_view.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/common/initialize_device.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../APi/apidomain & api.dart';
import '../../Register/register_ui.dart';

class signin_otp_verification_screen extends StatefulWidget {
  final Map<String, dynamic> otpData;

  const signin_otp_verification_screen({super.key, required this.otpData});

  @override
  _signin_otp_verification_screenState createState() =>
      _signin_otp_verification_screenState();
}

class _signin_otp_verification_screenState
    extends State<signin_otp_verification_screen> {
  RxInt x = 0.obs;
  TextEditingController? otpController = TextEditingController();

  // load shared preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = false;

  // get uuid from shared preferences
  Future<String?> getUuid() async {
    final SharedPreferences prefs = await _prefs;
    final String? uuid = prefs.getString('uuid');
    return uuid;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    String otpText = "";

    print("otp data: ${widget.otpData}");

    final String identifier =
        getUuid().toString() != "" ? widget.otpData['identifier'] : '';
    final String phoneNumber = isNumeric(identifier) ? "+237 $identifier" : "";
    final String email = !isNumeric(identifier) ? identifier : "";

    // final String email = otpData['identifier'].toString();

    return Scaffold(
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
              SizedBox(
                height: Get.height * 0.025,
              ),

              SizedBox(
                height: Get.height * 0.015,
              ),
              Column(
                children: [
                  const Text(
                    'ENTER',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff113d6b),
                    ),
                  ),
                  const Text(
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
                  Column(
                    children: [
                      const Text(
                        'Enter the 4 - digit code you received',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff8ba0b7),
                        ),
                      ),
                      Text(
                        'on ${phoneNumber.isNotEmpty ? phoneNumber : email}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff8ba0b7),
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
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
                      const Text(
                        'number',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff113d6b),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              //

              SizedBox(
                height: Get.height * 0.1,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          autoFocus: true,
                          appContext: context,
                          length: 4,
                          onChanged: (value) {
                            x.value = value.length;
                            otpText = value;
                            debugPrint(value);
                          }),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Didn\'t receive a code?',
                          style:
                              TextStyle(color: Color(0xff8ba0b7), fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () async {
                            var value = {
                              "identifier":
                                  widget.otpData['identifier']?.toString(),
                            };
                            signin_otp_verification_screen verifyCodeView =
                                signin_otp_verification_screen(
                              otpData: value,
                            );

                            isLoading = true;

                            try {
                              await api().login(
                                  value,
                                  context ?? scaffoldKey.currentContext!,
                                  verifyCodeView,
                                  "");
                            } finally {
                              isLoading = false;
                            }
                          },
                          child: const Text(
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
                    SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (kDebugMode) {
                                    print("otp code: ${otpController?.text}");
                                  }
                                  final SharedPreferences prefs = await _prefs;
                                  if (prefs.getString('firebaseToken') ==
                                      null) {
                                    print("initializing firebase");
                                    await FirebaseAPI().initialize();
                                  }

                                  if (prefs.getString('deviceUuid') == null) {
                                    print("initializing device uuid");
                                    await InitializeDevice().initialize();
                                  }

                                  print(
                                      "device uuid: ${prefs.getString('deviceUuid')}");

                                  var value = {
                                    "code": otpController?.text,
                                    "uuid": await getUuid(),
                                    "device_uuid":
                                        prefs.getString('deviceUuid'),
                                    "push_token":
                                        prefs.getString('firebaseToken'),
                                  };

                                  // if (kDebugMode) {
                                    print("otp value: $value");
                                  // }

                                  // Home_view home = Home_view();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await Future.delayed(
                                      const Duration(seconds: 3));

                                  try {
                                    print("isLoading: $isLoading");
                                    await api()
                                        .validatePhoneOtp(
                                            value,
                                            context ??
                                                scaffoldKey.currentContext!,
                                            registration_successful_view(
                                                userAction: const {
                                                  "name": "login",
                                                }))
                                        .then((value) async {
                                      print("value: $value");
                                      await getActiveSubscription();
                                    });
                                  } catch (e) {
                                    print("Error: $e");
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Get.snackbar(
                                      'Error',
                                      'An error occurred, please try again later',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff113d6b),
                              foregroundColor: Colors.white),
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
                        )),
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
                              Get.off(() => const register_serviceprovider_view());
                            },
                          text: 'Register',
                          style: const TextStyle(
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
