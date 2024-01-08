import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/profile/view/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class update_password_view extends StatelessWidget {
  const update_password_view({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Change Password',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // current password
          Text(
            'Current Password',
            style: TextStyle(
              fontSize: 16,
              color: appcolor().mediumGreyColor,
            ),
          ),

          blockButton(
            title: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '********',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  hintStyle: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 20,
                  )),
            ),
            ontap: () {},
            color: Colors.white,
          ),

          SizedBox(
            height: 15,
          ),
          // new password
          Text(
            'New Password',
            style: TextStyle(
              fontSize: 16,
              color: appcolor().mediumGreyColor,
            ),
          ),

          blockButton(
            title: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '********',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  hintStyle: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 20,
                  )),
            ),
            ontap: () {},
            color: Colors.white,
          ),
          SizedBox(
            height: 15,
          ),
          // repeat new password
          Text(
            'Repeat New Password',
            style: TextStyle(
              fontSize: 16,
              color: appcolor().mediumGreyColor,
            ),
          ),

          blockButton(
            title: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '********',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  hintStyle: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 20,
                  )),
            ),
            ontap: () {},
            color: Colors.white,
          )
        ],
      ).paddingSymmetric(
        horizontal: 15,
        vertical: 20,
      ),
    );
  }
}
