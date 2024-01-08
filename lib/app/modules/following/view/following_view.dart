import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/Widgets/blockButton.dart';
import '../../global/constants/color.dart';
import '../controller/following_controller.dart';

class following_view extends StatefulWidget {
  const following_view({super.key});

  @override
  State<following_view> createState() => _following_viewState();
}

class _following_viewState extends State<following_view> {
  following_controller controller = Get.put(following_controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            // size: 30,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Manage Following',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
          size: 25,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Text(
              'Manage businesses you follow',
              style: TextStyle(
                color: appcolor().mediumGreyColor,
              ),
            ),
          ),
          blockButton(
            title: Container(
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    suffixIcon: Icon(
                      Icons.search,
                    ),
                    hintText: 'Search Business'),
              ),
            ),
            ontap: () {},
            color: Colors.white,
          ).paddingSymmetric(horizontal: 15),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              itemCount: controller.following_list.length,
              itemBuilder: (context, index) => InkWell(
                onLongPress: () {
                  if (controller.following_list[index].isSelected == false) {
                    controller.following_list[index].isSelected = true;
                    controller.selectedCounter.value++;
                    setState(() {});
                  } else {}
                },
                onTap: () {
                  if (controller.selectedCounter.value > 0) {
                    if (controller.following_list[index].isSelected == false) {
                      controller.following_list[index].isSelected = true;
                      controller.selectedCounter.value++;
                      setState(() {});
                    } else {
                      controller.following_list[index].isSelected = false;
                      controller.selectedCounter.value--;
                      setState(() {});
                    }
                  } else {}
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  padding: EdgeInsets.all(
                    10,
                  ),
                  decoration: BoxDecoration(
                    color: controller.following_list[index].isSelected == false
                        ? Colors.white
                        : const Color.fromARGB(255, 217, 235, 250),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(
                        0,
                      ),
                      decoration: BoxDecoration(
                        color:
                            controller.following_list[index].isSelected == false
                                ? Colors.white
                                : const Color.fromARGB(255, 217, 235, 250),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: appcolor().mediumGreyColor,
                              ),
                              // borderRadius: BorderRadius.circular(
                              //   8,
                              // ),
                            ),
                            width: Get.width * 0.13,
                            height: Get.height * 0.06,
                            child: controller
                                        .following_list[index].isSelected ==
                                    false
                                ? Image(
                                    image: AssetImage(
                                      controller.following_list[index].picurl
                                          .toString(),
                                    ),
                                    fit: BoxFit.fill,
                                  )
                                : Container(
                                    color: appcolor().bluetextcolor,
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                          Container(
                            width: Get.width * 0.45,
                            // decoration: BoxDecoration(color: Colors.red),
                            // height: Get.height * 0.08,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width * 0.45,
                                  child: Text(
                                    controller.following_list[index].name
                                        .toString(),
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: appcolor().mainColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: Get.height * 0.04,
                                  // width: Get.width * 0.5,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller
                                              .following_list[index].location,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                controller.following_list[index].button_is_open==true?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Member Since: ', style: TextStyle(color: appcolor().mainColor, fontSize: 12),),
                                    Text('Feb 2016', style: TextStyle(color: appcolor().mainColor, fontSize: 12),)
                                  ],
                                ):Container(),
                                SizedBox(height: 5,),
                                controller.following_list[index].button_is_open==true?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Subscribed on: ', style: TextStyle(color: appcolor().mainColor, fontSize: 12),),
                                    Text('12 Feb 2016', style: TextStyle(color: appcolor().mainColor, fontSize: 12, fontWeight: FontWeight.w500,),)
                                  ],
                                ):Container(),
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              controller.following_list[index].button_is_open =
                                  !controller
                                      .following_list[index].button_is_open!;
                              setState(() {});
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'UNSUBSCRIBE',
                                  style: TextStyle(
                                    color: appcolor().bluetextcolor,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: appcolor().greyColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      )),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(
                                    controller.following_list[index]
                                                .button_is_open ==
                                            false
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_drop_up,
                                    color: appcolor().mediumGreyColor,
                                    size: 24,
                                  ),
                                ),
                                // controller.following_list[index].button_is_open==true?
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
