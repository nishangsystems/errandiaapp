import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordChangeConfirmation extends StatefulWidget {
  const PasswordChangeConfirmation({super.key});

  @override
  State<PasswordChangeConfirmation> createState() => _PasswordChangeConfirmationState();
}

class _PasswordChangeConfirmationState extends State<PasswordChangeConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blue.shade300,
              child: CircleAvatar(
                child: Icon(Icons.check,color: Colors.white,size: 40,),
                radius: 35,
                backgroundColor: Colors.green,

              )
            ),
             SizedBox(
              height: Get.height*0.05,
            ),
            Text("Set Your New Password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color:  Color(0xff113d6b),),),
            Text("Your new password has been sucessfully\n reset. Login to acsess your account",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.grey.shade800),),
    SizedBox(
      height: Get.height*0.1,
    ),

              Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                GestureDetector(
                  onTap: (){
                    // setState(() {
                    //   Get.to(signin_view());
                    // });
                    
                  },
                  child: Container(
                      height: Get.height * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xffe0e6ec),
                        ),
                        color: Color(0xff113d6b),
                      ),
                      child: Center(
                        child:Text(
                          'LOGIN NOW',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      ),
                    ),
                ),
              
            ),
          ],
        ),
      ),
    );
  }
}







class ResetPasswordFailed extends StatefulWidget {
  const ResetPasswordFailed({super.key});

  @override
  State<ResetPasswordFailed> createState() => _ResetPasswordFailedState();
}

class _ResetPasswordFailedState extends State<ResetPasswordFailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           CircleAvatar(
              radius: 70,
              backgroundColor: Colors.red,
              child: CircleAvatar(
                child: Icon(Icons.close,color: Colors.red,size: 40,),
                radius: 35,
                backgroundColor: Colors.white,

              )
            ),
             SizedBox(
              height: Get.height*0.05,
            ),
            Text("Password Reset Failed",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color:  Color(0xff113d6b),),),
            Text("Sorry, we are unable to reset your\n password.please try again or",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.grey.shade800),),
            InkWell(
              onTap: (){
               
              },
              child: Text("Contact Support",style: TextStyle(fontSize: 16,color: Colors.blue),)),
    SizedBox(
      height: Get.height*0.1,
    ),

              Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                GestureDetector(
                  onTap: (){
                    // setState(() {
                    //   Get.to(signin_view());
                    // });
                    
                  },
                  child: Container(
                      height: Get.height * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xffe0e6ec),
                        ),
                        color: Colors.red,
                      ),
                      child: Center(
                        child:Text(
                          'RESET MY PASSWORD',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      ),
                    ),
                ),
              
            ),
          ],
        ),
      ),
    );
  }
}

