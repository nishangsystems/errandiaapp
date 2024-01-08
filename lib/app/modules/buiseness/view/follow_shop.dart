import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';

class ShowBottomSheet {
  static void showBottomSheet2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 4,
                  width: 40,
                  color: appcolor().greyColor,
                ),
              ),
             Row(
              
              children: [
                SizedBox(width: 20,),
                Icon(Icons.person_add,color:Colors.black,),
                SizedBox(
                  width: 20,
                ),
                Text("Follow this shop")
              ],
             ),
              Row(
                
              children: [
                 SizedBox(width: 20,),

                Icon(Icons.call,color:Colors.black,),
                 SizedBox(width: 20,),

                Text("Call Suplier")
              ],
             ),
              Row(
              children: [
                 SizedBox(width: 20,),

                Icon(Icons.reviews,color:Colors.black,),
                 SizedBox(width: 20,),

                Text("write Reviews")
              ],
             ),
              Row(
              children: [
                 SizedBox(width: 20,),

                Icon(Icons.report,size: 30,color:Colors.red,),
                 SizedBox(width: 20,),

                Text("Report the shop")
              ],
             )
            ],
          ),
        );
      },
    );
  }
}