import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../global/constants/color.dart';
import '../New_Errand.dart';

class Product_serivices extends StatefulWidget {
  const Product_serivices({super.key});

  @override
  State<Product_serivices> createState() => _Product_serivicesState();
}

class _Product_serivicesState extends State<Product_serivices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      titleSpacing: 8,
      title: Text('Product/Service'.tr, style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xff113d6b),
      ),),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: appcolor().mediumGreyColor,
          fontSize: 18),
      automaticallyImplyLeading: false,
      leading: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Get.back();
        },
        icon: Icon(Icons.arrow_back_ios),
        color: Color(0xff113d6b),
      ),
      actions: [
        TextButton(
            onPressed: () {},
            child: Text(
              'Done',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ))
      ],
    ),
      body: Column(
        children: [
          ListTile(

            leading: FaIcon(FontAwesomeIcons.box),
            title: Text('Shaving tool'),
            trailing: InkWell(
                onTap: (){
                  Get.to(New_Errand());
                },
                child: Icon(Icons.edit)),
          ),
          Spacer(),
          InkWell(
            onTap: () {
            //  Get.to(nd_screen());
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
              child: Container(
                height: Get.height * 0.09,
                width: Get.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),

                  color: Color(0xffe0e6ec),
                ),
                child: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
