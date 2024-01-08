import 'package:errandia/app/modules/auth/Sign%20in/view/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
      ),
      body: SingleChildScrollView(
        child: Column(
          
          children: [
            Divider(),
            SizedBox(
              height: Get.height*0.05,
            ),
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blue,
              child: Icon(Icons.lock_open_outlined,color: Colors.white,size: 50,),
            ),
            SizedBox(
              height: Get.height*0.05,
            ),
            Text("Forget Password?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color:  Color(0xff113d6b),),),
            Text("If you've lost your password or wish to \nreset it, please enter your registered email \nbelow",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.grey.shade700),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email",style: TextStyle(fontWeight: FontWeight.w500),),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade100),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                        
                          
                          decoration: InputDecoration(
                        
                            border: InputBorder.none,
                            hintText: "Enter your email"
                           
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Get.to(ResetPassword());
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
                        'SUBMIT',
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