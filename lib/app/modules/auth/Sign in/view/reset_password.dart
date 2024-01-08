import 'package:errandia/app/modules/auth/Sign%20in/view/forget_password.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/password_change_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
   bool isSelected1=true;
  bool isSelected2=true;
     final textFieldFocusNode = FocusNode();
          final textFieldFocusNode1 = FocusNode();
  TextEditingController t1=TextEditingController();
    TextEditingController t2=TextEditingController();
   
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
              child: Icon(Icons.key_outlined,color: Colors.white,size: 50,),
            ),
            SizedBox(
              height: Get.height*0.05,
            ),
            Text("Set Your New Password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color:  Color(0xff113d6b),),),
            Text("Your new password should be different\n from your previously used password",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.grey.shade800),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("New Password",style: TextStyle(fontWeight: FontWeight.w500),),
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
                          controller: t1,
                          obscureText: isSelected1,
                          decoration: InputDecoration(
                             suffixIcon:  Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: (){
              setState(() {
                isSelected1=!isSelected1;
      if (textFieldFocusNode1.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode1.canRequestFocus = false;  
              });
            },
            child: Icon(
              isSelected1
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 24,
            ),
          ),
        ),
                            border: InputBorder.none,
                            hintText: "Enter new password"
                           
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                   Text("Repeat New Password",style: TextStyle(fontWeight: FontWeight.w500),),
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
                          controller: t2,
                          obscureText: isSelected2,
                          decoration: InputDecoration(
                          suffixIcon:  Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: (){
              setState(() {
                isSelected2=!isSelected2;
          if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;  
              });
            },
            child: Icon(
              isSelected2
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 24,
            ),
          ),
        ),
                            border: InputBorder.none,
                            hintText: "Re-Enter your Password"
                           
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
              child:
                GestureDetector(
                  onTap: (){
                    t1.text.toString()==t2.text.toString()?Get.to(ResetPasswordFailed()):showDialog(context: context, builder:(context){
                      return AlertDialog(
                       content: Container(
                        height: 100,
                        width: 200,
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Text("Password and Repeat Passwords are not same"),
                             TextButton(onPressed: (){
                              Get.back();
                             }, child: Text("Ok"))
                           ],
                         ),
                       ),

                      );
                    });
                    print("hii");
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
                          'CONFIRM PASSWORD',
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