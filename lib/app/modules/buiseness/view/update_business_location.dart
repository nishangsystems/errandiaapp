import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/constants/color.dart';

class update_business_location_view extends StatelessWidget {
  const update_business_location_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Business Location',
          style: TextStyle(
            color: appcolor().mediumGreyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.arrow_back_ios,
            color: appcolor().mediumGreyColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'UPDATE',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  FontAwesomeIcons.earthAsia,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'South West Region',
                suffixIcon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Divider(
            color: appcolor().greyColor,
            thickness: 1,
            height: 1,
            indent: 0,
          ),
           Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 45,top: 10),
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'Bulea',
                suffixIcon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Divider(
            color: appcolor().greyColor,
            thickness: 1,
            height: 1,
            indent: 0,
          ),
           Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: TextFormField(
            
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 45,top: 10),
                border: InputBorder.none,
                // prefixIcon: Icon(

                //   // FontAwesomeIcons.earthAsia,
                //   color: Colors.black,
                // ),
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'Molyko',
                suffixIcon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Divider(
            color: appcolor().greyColor,
            thickness: 1,
            height: 1,
            indent: 0,
          ),
           Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.location_pin,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'Address',
                suffixIcon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Divider(
            color: appcolor().greyColor,
            thickness: 1,
            height: 1,
            indent: 0,
          ),
        ],
      ),
    );
  }
}
