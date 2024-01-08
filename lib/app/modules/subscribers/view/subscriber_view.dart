import 'package:errandia/app/modules/global/Widgets/snackBar.dart';
import 'package:errandia/app/modules/subscribers/controller/subscriber_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/Widgets/blockButton.dart';
import '../../global/constants/color.dart';
import '../model/subscriber_model.dart';

class subscriber_view extends StatefulWidget {
  subscriber_view({super.key});

  @override
  State<subscriber_view> createState() => _subscriber_viewState();
}

class _subscriber_viewState extends State<subscriber_view> {
  subscriber_controller controller = Get.put(subscriber_controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controller.selectedCounter.value == 0
          ? AppBar(
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
                'Manage Subscribers',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              iconTheme: IconThemeData(
                color: appcolor().mediumGreyColor,
                size: 25,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.arrowDownWideShort),
                ),
              ],
            )
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 2,
              leading: IconButton(
                icon: Icon(
                  FontAwesomeIcons.xmark,
                  // size: 30,
                ),
                onPressed: () {
                  controller.cancel();
                  setState(() {});
                },
              ),
              automaticallyImplyLeading: false,
              title: Text(
                controller.selectedCounter.value.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
              iconTheme: IconThemeData(
                color: appcolor().mediumGreyColor,
                size: 25,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.square),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                ),
                TextButton(onPressed: () {}, child: Text('Bulk SMS')),
              ],
            ),
      body: Column(
        children: [
          Container(
            height: 20,
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
                    hintText: 'Search Subscribers'),
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
              itemCount: controller.subscriber_list.length,
              itemBuilder: (context, index) => InkWell(
                onLongPress: () {
                  if (controller.subscriber_list[index].isSelected == false) {
                    controller.subscriber_list[index].isSelected = true;
                    controller.selectedCounter.value++;
                    setState(() {});
                  } else {}
                },
                onTap: () {
                  if (controller.selectedCounter.value > 0) {
                    if (controller.subscriber_list[index].isSelected == false) {
                      controller.subscriber_list[index].isSelected = true;
                      controller.selectedCounter.value++;
                      setState(() {});
                    } else {
                      controller.subscriber_list[index].isSelected = false;
                      controller.selectedCounter.value--;
                      setState(() {});
                    }
                  } else {}
                },
                child: Container(
                  height: Get.height * 0.12,
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  padding: EdgeInsets.all(
                    10,
                  ),
                  decoration: BoxDecoration(
                    color: controller.subscriber_list[index].isSelected == false
                        ? Colors.white
                        : const Color.fromARGB(255, 217, 235, 250),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            '# ${index + 1}',
                            style: TextStyle(
                              color: appcolor().mediumGreyColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          controller.subscriber_list[index].isSelected == true
                              ? Container(
                                  child: Icon(
                                    Icons.check_box,
                                    color: appcolor().bluetextcolor,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.subscriber_list[index].name.toString(),
                            style: TextStyle(
                              color: appcolor().mainColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Subscribed on :',
                                  style: TextStyle(
                                    color: appcolor().mediumGreyColor,
                                  ),
                                ),
                                TextSpan(
                                  text: controller
                                      .subscriber_list[index].subscribedDate
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 155, 204, 244),
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Text(
                              controller.subscriber_list[index].msgCounter
                                      .toString() +
                                  ' messages',
                              style: TextStyle(
                                  color: appcolor().bluetextcolor,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ).paddingOnly(
                        left: 10,
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              if (controller.selectedCounter.value > 0) {
                              } else {
                                // here write fuction work
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.message_outlined,
                                  size: 20,
                                  color: appcolor().bluetextcolor,
                                ),
                                Text(
                                  ' SEND SMS',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: appcolor().bluetextcolor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.selectedCounter.value > 0) {
                              } else {
                                // here write fuction work
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      remove_subscriber_widget(
                                    controller.subscriber_list,
                                    index,
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.circleXmark,
                                  size: 20,
                                  color: appcolor().mediumGreyColor,
                                ),
                                Text(
                                  ' REMOVE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: appcolor().mediumGreyColor,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
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

Widget remove_subscriber_widget(RxList<subscriber_model> list, int index) {
  return AlertDialog(
    contentPadding: EdgeInsets.symmetric(horizontal: 0),
    insetPadding: EdgeInsets.symmetric(horizontal: 15),
    content: Container(
      height: Get.height * 0.52,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remove Subscriber',
            style: TextStyle(
                color: appcolor().mainColor,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: appcolor().lightgreyColor,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                    'assets/images/person_avatar.png',
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  list[index].name.toString(),
                  style: TextStyle(
                    color: appcolor().mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          blockButton(
            title: Text(
              'Yes , Remove Subscriber',
              style: TextStyle(
                color: appcolor().mainColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            ontap: () {
              Get.back();

              Get.showSnackbar(customsnackbar(
                 Row(
        children: [
          Text(
            'Subscriber Removed',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              'UNDO',
            ),
          ),
        ],
      ),
              ));
            },
            color: Colors.white,
            bordercolor: appcolor().mainColor,
          ),
          SizedBox(
            height: 10,
          ),
          blockButton(
            title: Text(
              'Cancel',
              style: TextStyle(
                color: appcolor().mainColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            ontap: () {
              Get.back();
            },
            color: appcolor().greyColor,
          )
        ],
      ).paddingSymmetric(
        horizontal: 20,
        vertical: 15,
      ),
    ),
  );
}
