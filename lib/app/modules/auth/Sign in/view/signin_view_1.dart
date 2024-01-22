// import 'package:errandia/app/APi/apidomain%20&%20api.dart';
// import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
// import 'package:errandia/app/modules/auth/Register/buyer/view/otp_verification_screen.dart';
// import 'package:errandia/app/modules/auth/Register/register_signin_screen.dart';
// import 'package:errandia/app/modules/auth/Register/register_ui.dart';
// import 'package:errandia/app/modules/auth/Sign%20in/view/forget_password.dart';
// import 'package:errandia/app/modules/auth/Sign%20in/view/signin_otp_verification_screen.dart';
// import 'package:errandia/app/modules/auth/Sign%20in/view/verify_otp.dart';
// import 'package:errandia/app/modules/global/Widgets/appbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

// import '../../../home/view/home_view.dart';

// class signin_view extends StatefulWidget {
//   @override
//   State<signin_view> createState() => _signin_viewState();
// }

// class _signin_viewState extends State<signin_view> {
//   TextEditingController mobileno = TextEditingController();

// TextEditingController password = TextEditingController();
//  TextEditingController email = TextEditingController();
//  TextEditingController phone = TextEditingController();
//    var number;
// bool isSelected=true;
// bool isSelected2=false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// backgroundColor: Colors.grey.shade50,
// appBar: AppBar(
//   backgroundColor: Colors.white,
//   automaticallyImplyLeading: false,
//   elevation: 0.8,
//   leading: IconButton(
//     onPressed: () {
//       Get.back();
//     },
//     icon: Icon(
//       Icons.arrow_back_ios,
//       color: Color(0xff113d6b),
//     ),
//   ),
// ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 15,
//         ),
//         child: ListView(
//           children: [

//             SizedBox(
//               height: Get.height * 0.025,
//             ),

// Container(
//   child: Column(
//     children: [
//       Text(
//         'LOGIN TO YOUR ERRANDIA ACCOUNT',
//         style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.w700,
//           color: Color(0xff113d6b),
//         ),
//         textAlign: TextAlign.center,
//       ),
//       // Text(
//       //   'ACCOUNT',
//       //   style: TextStyle(
//       //     fontSize: 26,
//       //     fontWeight: FontWeight.w700,
//       //     color: Color(0xff113d6b),
//       //   ),
//       // ),
//     ],
//   ),
// ),

//             //

//             SizedBox(
//               height: Get.height * 0.03,
//             ),

//             //
//   Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10)
//     ),
//     width: Get.width*0.8,
//     height: 50,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         InkWell(
//             onTap: (){
//                 setState(() {
//                    isSelected2=false;
//                 isSelected=true;
//                 });
//               },

//             child: Container(
//                width: 150,
//                height: 40,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   color: isSelected?Colors.blue.shade100:Colors.white
//               ),
//               child:Center(child: Text("Phone")),
//             ),
//           ),

//           InkWell(
//             onTap: (){
//                 setState(() {
//                    isSelected=false;
//                 isSelected2=true;
//                 });
//               },

//             child: Container(
//                height: 40,
//                 width: 150,
//                   decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: isSelected2?Colors.blue.shade100:Colors.white
//                          ),
//                                  child:Center(child: Text("Email")),
//             ),
//           ),
//       ],
//     ),

//     // child: Column(
//     //   children: [
//     //     Text(
//     //       'Log into your Errandia account',
//     //       style: TextStyle(
//     //         fontSize: 17,
//     //         fontWeight: FontWeight.w500,
//     //         color: Color(0xff8ba0b7),
//     //       ),
//     //     ),
//     //   ],
//     // ),
//   ),

//  isSelected?Phone(mobileno: mobileno, password: password):Email(password: password, email: email),
//   SizedBox(
//     height: Get.height * 0.03,
//   ),
//             // buiseness email

//          // SizedBox(height: Get.height*0.1,),
//             //button container

//             // InkWell(
//             //   onTap: () {
//             //     var Phone = mobileno.text.trim();
//             //     var Password = password.text.trim();
//             //     if(Phone == ''&& Password == ''){
//             //       alertBoxdialogBox(context, 'Alert', 'Please Enter Fill Field');
//             //     }else {
//             //       var value = {
//             //         "phone":Phone,
//             //         "password":Password
//             //       };
//             //       Home_view home = Home_view();
//             //       api().registration('login', value, context, home,'');
//             //       setState(() {
//             //         isLoading =true;
//             //       });
//             //       Future.delayed(Duration(seconds: 2),(){
//             //         setState(() {
//             //           isLoading = false;
//             //         });
//             //       });
//             //     }

//             //   },
//             //   child: Container(
//             //     height: Get.height * 0.09,
//             //     decoration: BoxDecoration(
//             //       borderRadius: BorderRadius.circular(10),
//             //       border: Border.all(
//             //         color: Color(0xffe0e6ec),
//             //       ),
//             //       color: Color(0xff113d6b),
//             //     ),
//             //     child: Center(
//             //       child:isLoading == false? Text(
//             //         'CONTINUE',
//             //         style: TextStyle(
//             //             fontSize: 18,
//             //             fontWeight: FontWeight.w600,
//             //             color: Colors.white),
//             //       ):Center(child: CircularProgressIndicator(color: Colors.white,),),
//             //     ),
//             //   ),
//             // ),
//             // SizedBox(
//             //   height: Get.height * 0.05,
//             // ),
//             //  Center(
//             //   child:Text("OR",style: TextStyle(fontSize: 17),)
//             //  ),
//             //   SizedBox(
//             //   height: Get.height * 0.015,
//             // ),
//             // Center(child: Text("Register with your social account",style: TextStyle(fontSize: 16),)),
//             // SizedBox(
//             //   height: Get.height * 0.01,
//             // ),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.center,
//             //   children: [
//             //     Container(
//             //       height: 50,
//             //       child: ElevatedButton(onPressed:(){}, child: Text("f",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 24),),
//             //       style: ElevatedButton.styleFrom(
//             //         shape:CircleBorder(

//             //         ),

//             //       ),
//             //       ),
//             //     ),
//             //       Container(
//             //         height: 50,
//             //         child: ElevatedButton(onPressed:(){
//             //           print("Hii");
//             //         }, child: Icon(Icons.email),
//             //                         style: ElevatedButton.styleFrom(
//             //         shape:CircleBorder(

//             //         )
//             //                         ),
//             //                         ),
//             //       ),
//             //     // CircleAvatar(
//             //     //   radius: 25,
//             //     //   backgroundImage: AssetImage("assets/email.png"),
//             //     // )
//             //   ],
//             // ),
//             // SizedBox(
//             //   height: Get.height * 0.05,
//             // ),

//             // Align(
//             //   alignment: Alignment.center,
//             //   child: RichText(
//             //     text: TextSpan(
//             //         style: TextStyle(color: Color(0xff8ba0b7), fontSize: 17),
//             //         children: [
//             //           TextSpan(text: 'Don\'t have an Errandia Account? '),
//             //           TextSpan(
//             //             recognizer: TapGestureRecognizer()
//             //               ..onTap = () {
//             //                 debugPrint('Register View');
//             //                 Get.off(Register_Ui());
//             //               },
//             //             text: 'Register',
//             //             style: TextStyle(
//             //               fontWeight: FontWeight.bold,
//             //               color: Color(0xff3c7fc6),
//             //             ),
//             //           )
//             //         ]),
//             //   ),
//             // ),
//             SizedBox(
//               height: Get.height * 0.03,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/modules/auth/Register/register_ui.dart';
import 'package:errandia/app/modules/auth/Register/service_Provider/view/Register_serviceprovider_view.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/forget_password.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/auth_services/firebase_auth_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phone extends StatefulWidget {
  Phone({super.key, required this.mobileno});

  // TextEditingController password=TextEditingController();
  TextEditingController mobileno = TextEditingController();

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  bool isLoading = false;
  var number;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Get.height * 0.05,
        ),
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: Get.height * 0.003,
        ),
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
                    controller: widget.mobileno,
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
                      setState(() {
                        number = phone.countryCode;
                      });
                      // print(phone.completeNumber);
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
                    controller: widget.mobileno,
                    // keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counter: Offstage(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            // var Password = widget.password.text.trim();
            // if(Phone == ''&& Password == ''){
            //   alertBoxdialogBox(context, 'Alert', 'Please Enter Fill Field');
            // }else {
            //   var value = {
            //     "phone":Phone,
            //     "password":Password
            //   };
            //   Home_view home = Home_view();
            //   api().registration('login', value, context, home,'');
            //   setState(() {
            //     isLoading =true;
            //   });
            //   Future.delayed(Duration(seconds: 2),(){
            //     setState(() {
            //       isLoading = false;
            //     });
            //   });
            //   Get.to(OTP_view());
            // }
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
        SizedBox(
          height: Get.height * 0.05,
        ),
        const Center(
            child: Text(
          "OR",
          style: TextStyle(fontSize: 17),
        )),
        SizedBox(
          height: Get.height * 0.015,
        ),
        const Center(
            child: Text(
          "Register with your social account",
          style: TextStyle(fontSize: 16),
        )),
        SizedBox(
          height: Get.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                ),
                child: const Text(
                  "f",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Hii");
                  }
                },
                style: ElevatedButton.styleFrom(shape: CircleBorder()),
                child: const Icon(Icons.email),
              ),
            ),
            // CircleAvatar(
            //   radius: 25,
            //   backgroundImage: AssetImage("assets/email.png"),
            // )
          ],
        ),
        SizedBox(
          height: Get.height * 0.05,
        ),
        Align(
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
                style: const TextStyle(color: Color(0xff8ba0b7), fontSize: 17),
                children: [
                  const TextSpan(text: 'Don\'t have an Errandia Account? '),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        debugPrint('Register View');
                        Get.off(register_serviceprovider_view());
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
    );
  }
}

class Email extends StatefulWidget {
  Email({
    super.key,
  });

  // TextEditingController =TextEditingController();

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  bool isLoading = false;
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Container(
            height: Get.height * 0.08,
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
                obscureText: false,
                controller: email,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  // hintText: 'Enter Passwor'
                ),
              ),
            ),
          ),

          SizedBox(
            height: Get.height * 0.003,
          ),

          const Text(
            'Password',
            style: TextStyle(
              fontSize: 16,
            ),
          ),

          SizedBox(
            height: Get.height * 0.003,
          ),

          // text form field
          Container(
            height: Get.height * 0.08,
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
                obscureText: true,
                controller: password,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  //  hintText: 'Enter Password'
                ),
              ),
            ),
          ),
          Center(
              child: TextButton(
                  onPressed: () {
                    Get.to(const ForgetPassword());
                  },
                  child: const Text(
                    "Forgot your password ?",
                    style: TextStyle(color: Colors.blue),
                  ))),
          InkWell(
            onTap: () async {
              var email_ = email.text.trim();
              var password_ = password.text.trim();
              if (email_ == '' && password_ == '') {
                alertDialogBox(context, 'Alert', 'Please Enter Fill Field');
              } else {
                var value = {"email": email_, "password": password_};
                Home_view home = Home_view();
                // api().registration('email/login', value, context, home, '');
                setState(() {
                  isLoading = true;
                });

                try {
                  await api().login(value, context, home, "");
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
                //  Get.to(Home_view());
              }
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
          SizedBox(
            height: Get.height * 0.03,
          ),

          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                  style:
                      const TextStyle(color: Color(0xff8ba0b7), fontSize: 17),
                  children: [
                    const TextSpan(text: 'Don\'t have an Errandia Account? '),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          debugPrint('Register View');
                          Get.off(register_serviceprovider_view());
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
    );
  }
}

class signin_view_1 extends StatefulWidget {
  const signin_view_1({super.key});

  @override
  State<signin_view_1> createState() => _signin_viewState();
}

class _signin_viewState extends State<signin_view_1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final TextEditingController _phoneContoller = TextEditingController();
  TextEditingController _otpContoller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool isSelected = true;
  bool isSelected2 = false;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 35, bottom: 20),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: Get.width * 0.9,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSelected2 = false;
                          isSelected = true;
                        });
                      },
                      child: Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isSelected
                                ? Colors.blue.shade100
                                : Colors.white),
                        child: const Center(child: Text("Phone")),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSelected = false;
                          isSelected2 = true;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isSelected2
                                ? Colors.blue.shade100
                                : Colors.white),
                        child: const Center(child: Text("Email")),
                      ),
                    ),
                  ],
                ),

                // child: Column(
                //   children: [
                //     Text(
                //       'Log into your Errandia account',
                //       style: TextStyle(
                //         fontSize: 17,
                //         fontWeight: FontWeight.w500,
                //         color: Color(0xff8ba0b7),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
            isSelected
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
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
                                      left: 10, right: 10, top: 10),
                                  child: TextFormField(
                                    controller: _phoneContoller,
                                    maxLength: 9,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      prefixText: "+237 ",
                                      hintText: "Enter your phone number",
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value!.length != 9) {
                                        return "Invalid phone number";
                                      }
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
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    var value = {"phone": _phoneContoller.text};
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    await api()
                                        .loginWithPhone(value, scaffoldKey.currentContext)
                                        .then((response) => {
                                              if (response['data']['uuid'] !=
                                                      null ||
                                                  response['data']['uuid'] !=
                                                      "")
                                                {
                                                  print(
                                                      "showing popup: $response"),
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              AlertDialog(
                                                                title: const Text(
                                                                    "OTP Verification"),
                                                                content: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                        "Enter 4 digit code"),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    Form(
                                                                      key:
                                                                          _formKey1,
                                                                      child:
                                                                          TextFormField(
                                                                        maxLength:
                                                                            4,
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        controller:
                                                                            _otpContoller,
                                                                        decoration: InputDecoration(
                                                                            labelText:
                                                                                "Enter you phone number",
                                                                            border:
                                                                                OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
                                                                        validator:
                                                                            (value) {
                                                                          if (value!.length !=
                                                                              4) {
                                                                            return "Invalid OTP";
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (_formKey1
                                                                            .currentState!
                                                                            .validate()) {
                                                                          var value =
                                                                              {
                                                                            "code":
                                                                                _otpContoller.text,
                                                                            "uuid":
                                                                                prefs.getString("uuid"),
                                                                          };

                                                                          Home_view
                                                                              home =
                                                                              Home_view();

                                                                          await api().validatePhoneOtp(
                                                                              value,
                                                                              context,
                                                                              home);
                                                                        }
                                                                      },
                                                                      child: const Text(
                                                                          "Submit"))
                                                                ],
                                                              ))
                                                }
                                              else
                                                {
                                                  ScaffoldMessenger.of(
                                                          scaffoldKey
                                                              .currentContext!)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                      "Error in sending OTP",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ))
                                                }
                                            });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff113d6b),
                                    foregroundColor: Colors.white),
                                child: const Text("Continue"),
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
                                      Get.off(register_serviceprovider_view());
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
                : Email()
          ],
        ),
      ),
    );
  }
}
