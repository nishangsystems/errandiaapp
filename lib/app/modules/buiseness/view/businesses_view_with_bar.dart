import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/view/business_item.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/constants/color.dart';

class BusinessesViewWithBar extends StatelessWidget {
  BusinessesViewWithBar({super.key});
  final business_controller busi_controller = Get.put(business_controller());

  @override
  Widget build(BuildContext context) {
    home_controller().atbusiness.value = true;
    return Scaffold(
      appBar: appbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // address widget
          
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: appcolor().greyColor,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: Get.height * 0.06,
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.buildingUser,
                  color: appcolor().mediumGreyColor,
                  size: 18,
                ),
                SizedBox(
                  width: Get.width * 0.05,
                ),
                Text(
                  'Update Your Business Info',
                  style: TextStyle(fontSize: 13),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Update Bussiness',
                    style: TextStyle(
                      color: appcolor().blueColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //busieness
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Text(
                  'Bussiness ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: appcolor().mainColor,
                  ),
                ),
                Spacer(),
                InkWell(
                  // splashColor: Colors.grey,
                  // splashFactory: InkSplash.splashFactory,'[=]
                  // radius: 25,
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            Text(
                              'Sort List',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: appcolor().mainColor,
                              ),
                            ),
                            // z-a
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text: 'Business Name : ',
                                        style: TextStyle(
                                          color: appcolor().mainColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Desc Z-A',
                                        style: TextStyle(
                                          color: appcolor().mediumGreyColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Obx(
                                  () => Radio(
                                    value: 'sort descending',
                                    groupValue:
                                        busi_controller.sorting_value.value,
                                    onChanged: (val) {
                                      busi_controller.sorting_value.value =
                                          val.toString();
                                    },
                                  ),
                                )
                              ],
                            ),

                            // a-z
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text: 'Business Name : ',
                                        style: TextStyle(
                                          color: appcolor().mainColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Asc A-Z',
                                        style: TextStyle(
                                          color: appcolor().mediumGreyColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Obx(() => Radio(
                                      value: 'sort acending',
                                      groupValue:
                                          busi_controller.sorting_value.value,
                                      onChanged: (val) {
                                        busi_controller.sorting_value.value =
                                            val.toString();
                                      },
                                    ))
                              ],
                            ),

                            // distance nearest to me
                            Row(
                              children: [
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(fontSize: 16),
                                        children: [
                                      TextSpan(
                                        text:
                                            'Distance: Nearest to my location',
                                        style: TextStyle(
                                          color: appcolor().mainColor,
                                        ),
                                      ),
                                    ])),
                                Spacer(),
                                Obx(() => Radio(
                                      value: 'distance nearest to my location',
                                      groupValue:
                                          busi_controller.sorting_value.value,
                                      onChanged: (val) {
                                        busi_controller.sorting_value.value =
                                            val.toString();
                                      },
                                    ))
                              ],
                            ),

                            //recentaly added
                            Row(
                              children: [
                                Text(
                                  'Recently Added ',
                                  style: TextStyle(
                                      color: appcolor().mainColor,
                                      fontSize: 16),
                                ),
                                Icon(
                                  Icons.arrow_upward,
                                  size: 25,
                                  color: appcolor().mediumGreyColor,
                                ),
                                Spacer(),
                                Obx(
                                  () => Radio(
                                    value: 'recentaly added',
                                    groupValue:
                                        busi_controller.sorting_value.value,
                                    onChanged: (val) {
                                      busi_controller.sorting_value.value =
                                          val.toString();
                                      print(val.toString());
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ).paddingSymmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Icon(Icons.sort),
                    height: Get.height * 0.05,
                    width: Get.width * 0.1,
                    decoration: BoxDecoration(
                        // color: Colors.amber,
                        shape: BoxShape.circle),
                  ),
                ),
                // IconButton(
                //   padding: EdgeInsets.all(0),

                //   splashRadius: 15,
                //   // visualDensity: VisualDensity(
                //   //   horizontal: 5,
                //   //   vertical: 5,
                //   // ),
                //   highlightColor: Colors.red,
                //   onPressed: () {},
                //   icon: Icon(
                //     Icons.sort,
                //   ),

                // ),
              ],
            ),
          ),

          // horizontal list
          Container(
            padding: EdgeInsets.only(left: 10),
            height: 60,
            // color: Colors.black,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Center(
                  child: horizontal_list_item(),
                );
              },
            ),
          ),

          // grid view

          Expanded(
            child: GridView.builder(
              itemCount: business_controller().businessList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(errandia_business_view(
                      index: index,
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border.all(color: appcolor().greyColor)
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    // width: Get.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: appcolor().lightgreyColor,
                          child: Image(
                            image: AssetImage(
                              business_controller()
                                  .businessList[index]
                                  .imagepath,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.009,
                        ),
                        Text(
                          business_controller()
                              .businessList[index]
                              .type_of_business,
                          style: TextStyle(
                              fontSize: 13,
                              // fontWeight: FontWeight.bold,
                              color: appcolor().mediumGreyColor),
                        ),
                        SizedBox(
                          height: Get.height * 0.001,
                        ),
                        Text(
                          business_controller()
                              .businessList[index]
                              .name
                              .toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: appcolor().mainColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: Get.height * 0.001,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on),
                            Text(
                              business_controller()
                                  .businessList[index]
                                  .location
                                  .toString(),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).paddingSymmetric(horizontal: 10),
          )
        ],
      ),
    );
  }
}

Widget horizontal_list_item() {
  return InkWell(
    onTap: () {},
    child: Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: appcolor().skyblueColor,
        borderRadius: BorderRadius.circular(8),
      ),
      // height: 20,
      child: Text('Beauty & Hair'),
    ),
  );
}
