import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class filter_product_view extends StatelessWidget {
  filter_product_view({super.key});
  RxString groupValue = 'Publish'.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Filter',
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: appcolor().mediumGreyColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Apply',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          // sort
          Text(
            'Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ).paddingSymmetric(horizontal: 10,),
          // radion button
          radio_button_widget().paddingSymmetric(horizontal: 5,),
          // date
          Text(
            'Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ).paddingSymmetric(horizontal: 10,),

          Divider(
            color: appcolor().greyColor,
            thickness: 1,
            height: 1,
            indent: 0,
          ),
          // date picker from
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.date_range,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'From : 01/03/2023',
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
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.date_range,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                hintText: 'To : 02/03/2023',
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
          
          Text(
            'Category'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ).paddingSymmetric(horizontal: 10,),

        ],
      ),),
    );
  }

  Widget radio_button_widget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(
              () => Radio(
                visualDensity: VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                ),
                value: 'Publish',
                groupValue: groupValue.value,
                onChanged: (val) {
                  groupValue.value = val.toString();
                },
              ),
            ),
            Text(
              'Publish',
            ),
          ],
        ),
        Row(
          children: [
            Obx(
              () => Radio(
                visualDensity: VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                ),
                value: 'Draft',
                groupValue: groupValue.value,
                onChanged: (val) {
                  groupValue.value = val.toString();
                },
              ),
            ),
            Text(
              'Draft',
            ),
          ],
        ),
        Row(
          children: [
            Obx(
              () => Radio(
                visualDensity: VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                ),
                value: 'Trash',
                groupValue: groupValue.value,
                onChanged: (val) {
                  groupValue.value = val.toString();
                },
              ),
            ),
            Text(
              'Trash',
            ),
          ],
        ),
      ],
    );
  }
}
