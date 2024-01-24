import 'dart:developer';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/modules/auth/Register/register_ui.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/forget_password.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OTP_view extends StatefulWidget {
  final String verificationid;

  const OTP_view({super.key, required this.verificationid});
  @override
  State<OTP_view> createState() => _OTP_viewState();
}

class _OTP_viewState extends State<OTP_view> {
  TextEditingController mobileno = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  bool isSelected=true;
  bool isSelected2=false;
  var pinMatch ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: ListView(
          children: [
            SizedBox(
              height: Get.height * 0.025,
            ),
            Container(
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
            SizedBox(
              height: Get.height * 0.03,
            ),
      
            //
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              width: Get.width*0.8,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      onTap: (){
                          setState(() {
                             isSelected2=false;
                          isSelected=true;
                          });
                        },
                      child: Container(
                         width: 150,
                         height: 40,
                                   decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: isSelected?Colors.blue.shade100:Colors.white
                                   ),   
                                           child:Center(child: Text("Phone")),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                          setState(() {
                             isSelected=false;
                          isSelected2=true;
                          });
                        },
                      child: Container(
                         height: 40,
                          width: 150,
                            decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: isSelected2?Colors.blue.shade100:Colors.white
                                   ),                              
                                           child:Center(child: Text("Email")),
                      ),
                    ),
                ],
              ),
            ),
           isSelected?OTPFields(value: widget.verificationid,):Email(password: password, email: email),
            SizedBox(
              height: Get.height * 0.03,
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}



class OTPFields extends StatefulWidget {

  final String value;
 OTPFields({super.key,required this.value});

  @override
  State<OTPFields> createState() => _OTPFieldsState();
}

class _OTPFieldsState extends State<OTPFields> {
  var pinMatch;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 50,),
          Text("Enter the verification code we just sent to\n your phone number",textAlign:TextAlign.center ,style: TextStyle(fontSize: 16,color: Colors.black),),
          Pinput(
            length: 6,
            showCursor: true,
            onCompleted: (pin) {
              setState(() {
                pinMatch = pin;
              });

            },
          ),
          ElevatedButton(onPressed: ()async{
            try{
            PhoneAuthCredential crediental = await PhoneAuthProvider.credential(verificationId: widget.value, smsCode: pinMatch);
           FirebaseAuth.instance.signInWithCredential(crediental).then((value) {
             print(value);
             Get.offAll(Home_view());
           });

            }catch(e){
              log(e.toString());
            }
          }, child: Text('jhasdf'))

          // OtpTextField(
          //   numberOfFields: 4,
          //   borderColor: Color(0xFF512DA8),
          //   showFieldAsBox: true,
          //   onCodeChanged: (String code) {
          //   },
          //   onSubmit: (String verificationCode){
          //     showDialog(
          //         context: context,
          //         builder: (context){
          //           return AlertDialog(
          //             title: Text("Verification Code"),
          //             content: Text('Code entered is $verificationCode'),
          //           );
          //         }
          //     );
          //   }, // end onSubmit
          // ),
        ],
      ),
    );
  }
}


class Email extends StatefulWidget {
   Email({super.key,required this.password,required this.email});
  TextEditingController password=TextEditingController();
   TextEditingController email=TextEditingController();
   // TextEditingController =TextEditingController();

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
              Text(
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
                    color: Color(0xffe0e6ec),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    child: TextFormField(
                      obscureText: false,
                      controller:widget.email,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration:
                      InputDecoration(border: InputBorder.none,
                     // hintText: 'Enter Passwor'
                      ),
                    ),
                  ),
                ),
              ),
        
              SizedBox(
                height: Get.height * 0.003,
              ),
             
          Text(
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
                    color: Color(0xffe0e6ec),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    child: TextFormField(
                      obscureText: true,
                      controller: widget.password,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      decoration:
                      InputDecoration(border: InputBorder.none,
                    //  hintText: 'Enter Password'
                      ),
                    ),
                  ),
                ),
              ),
            Center(child: TextButton(onPressed: (){
              Get.to(ForgetPassword());
            }, child: Text("Forgot your password ?",style: TextStyle(color: Colors.blue),))),
                InkWell(
              onTap: () {
                var Email = widget.email.text.trim();
                var Password = widget.password.text.trim();
                if(Email == ''&& Password == ''){
                  alertDialogBox(context, 'Alert', 'Please Enter Fill Field');
                }else {
                  var value = {
                    "email":Email,
                    "password":Password
                  };
                  Home_view home = Home_view();
                  api().registration( value, context, home,'');
                  setState(() {
                    isLoading =true;
                  });
                  Future.delayed(Duration(seconds: 2),(){
                    setState(() {
                      isLoading = false;
                    });
                  });
                //  Get.to(Home_view());
                }
      
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
                  child:isLoading == false? Text(
                    'CONTINUE',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ):Center(child: CircularProgressIndicator(color: Colors.white,),),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.05,
            ),
             Center(
              child:Text("OR",style: TextStyle(fontSize: 17),)
             ),
              SizedBox(
              height: Get.height * 0.015,
            ),
            Center(child: Text("Register with your social account",style: TextStyle(fontSize: 16),)),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  child: ElevatedButton(onPressed:(){}, child: Text("f",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 24),),
                  style: ElevatedButton.styleFrom(
                    shape:CircleBorder(
                    
                    ),
                   
                  ),
                  ),
                ),
                  Container(
                    height: 50,
                    child: ElevatedButton(onPressed:(){
                      print("Hii");
                    }, child: Icon(Icons.email),
                                    style: ElevatedButton.styleFrom(
                    shape:CircleBorder(
                    
                    )
                                    ),
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
                    style: TextStyle(color: Color(0xff8ba0b7), fontSize: 17),
                    children: [
                      TextSpan(text: 'Don\'t have an Errandia Account? '),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            debugPrint('Register View');
                            Get.off(Register_Ui());
                          },
                        text: 'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3c7fc6),
                        ),
                      )
                    ]),
              ),
            ),
        
      ],
    ),
  ) ;
}
}
