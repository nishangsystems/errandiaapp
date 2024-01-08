
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


Future alertBoxdialogBox(context,String title,content){
  return
    showDialog(
        context: context, builder: (BuildContext contex){
      return AlertDialog(
        title: Text(title, style: TextStyle(color:Color(0xff113d6b),fontWeight: FontWeight.bold),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image.asset('assets/img_10.png',),
            Text(content) ,
          ],
        ),
        actions: [
          Container(
            height: Get.height * 0.055,
            width: Get.width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },

              child: Text(
                'Ok',
                style: TextStyle(
                    color: Color(0xff113d6b),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),

            ),
          ),
        ],
      );
    });

}