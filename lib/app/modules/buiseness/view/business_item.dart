import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/constants/color.dart';
import '../featured_buiseness/view/featured_list_item.dart';

class business_item extends StatelessWidget {
  business_item({
    super.key,
    required this.imagepath,
    required this.location,
    required this.name,
    required this.type_of_business,
    this.BusinessBranch_location,
  });
  List? BusinessBranch_location;
  String imagepath;
  String type_of_business;
  String name;
  String location;
  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          // width: Get.width * 0.4,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: appcolor().lightgreyColor,
                child: Image(
                  image: AssetImage(
                    Featured_Businesses_Item_List[0].imagePath,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.009,
              ),
              Text(
                Featured_Businesses_Item_List[0].servicetype.toString(),
                style: TextStyle(
                    fontSize: 13,
                    // fontWeight: FontWeight.bold,
                    color: appcolor().mediumGreyColor),
              ),
              SizedBox(
                height: Get.height * 0.001,
              ),
              Text(
                Featured_Businesses_Item_List[0].name.toString(),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: appcolor().mainColor),
              ),
              SizedBox(
                height: Get.height * 0.001,
              ),
              Row(
                children: [
                  Icon(Icons.location_on),
                  Text(Featured_Businesses_Item_List[0].location.toString())
                ],
              ),
            ],
          ),
        );
  }
}
