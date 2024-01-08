import 'package:errandia/app/modules/Enquiries/controller/enquiry_controller.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/view/add_business_view.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/errands/view/run_an_errand.dart';
import 'package:errandia/app/modules/products/controller/manage_products_controller.dart';
import 'package:errandia/app/modules/products/view/add_product_view.dart';
import 'package:errandia/app/modules/global/Widgets/filter_product_view.dart';
import 'package:errandia/app/modules/services/controller/manage_service_controller.dart';
import 'package:errandia/app/modules/services/view/add_service_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../errands/controller/errand_controller.dart';
import '../../global/Widgets/account_suspended_widget.dart';
import '../../global/Widgets/blockButton.dart';
import '../../global/Widgets/bottomsheet_item.dart';
import '../../global/Widgets/customDrawer.dart';
import '../../global/constants/color.dart';

enquiry_controller controller = Get.put(enquiry_controller());

class enquireis_view extends StatefulWidget {
  enquireis_view({super.key});

  @override
  State<enquireis_view> createState() => _enquireis_viewState();
}

class _enquireis_viewState extends State<enquireis_view> {
  enquiry_tab_controller tabController = Get.put(enquiry_tab_controller());

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
                  'Manage Enquiries',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                iconTheme: IconThemeData(
                  color: appcolor().mediumGreyColor,
                  size: 30,
                ),
                actions: [
                  Container(),
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
                    fontSize: 24,
                    color: appcolor().bluetextcolor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                iconTheme: IconThemeData(
                  color: appcolor().bluetextcolor,
                  size: 30,
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.square,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: controller.selectedCounter.value
                                          .toString() +
                                      ' conversation moved to trash ',
                                ),
                                TextSpan(text: 'UNDO')
                              ]),
                            )),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                    ),
                  ),
                ],
              ),
        body: SafeArea(
          child: Builder(
            builder: (ctx) => Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: appcolor().greyColor,
                      ),
                    ),
                  ),
                  height: Get.height * 0.08,
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    dividerColor: appcolor().bluetextcolor,
                    isScrollable: true,
                    unselectedLabelColor: appcolor().mediumGreyColor,
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    indicatorColor: appcolor().mainColor,
                    labelColor: appcolor().bluetextcolor,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appcolor().mainColor,
                      fontSize: 18,
                    ),
                    controller: tabController.tabController,
                    tabs: [
                      Text('All Enquiries'),
                      Text('Unread Enquiries'),
                      Text('Trash'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController.tabController,
                    children: [
                      All_Enquries(ctx),
                      Unread_Enquiries(ctx),
                      Trashed(ctx),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget All_Enquries(BuildContext ctx) {
    return Column(
      children: [
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
                  hintText: 'Search Enquiries'),
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
            itemCount: controller.allenquiry_list.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (controller.selectedCounter.value > 0) {
                        if (controller.allenquiry_list[index].isSelected ==
                            false) controller.selectedCounter.value++;
                        controller.allenquiry_list[index].isViewed = true;
                        controller.allenquiry_list[index].isSelected = true;
                      } else {
                        controller.allenquiry_list[index].isViewed =
                            !controller.allenquiry_list[index].isViewed!;
                      }
                      setState(() {});
                    },
                    onLongPress: () {
                      controller.allenquiry_list[index].isViewed = true;
                      controller.selectedCounter.value++;
                      controller.allenquiry_list[index].isSelected = true;

                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        10,
                      ),
                      decoration: BoxDecoration(
                        color: controller.allenquiry_list[index].isSelected ==
                                false
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
                        children: [
                          // image container
                          controller.allenquiry_list[index].isViewed == false
                              ? CircleAvatar(
                                  backgroundColor: appcolor().redColor,
                                  radius: 6,
                                )
                              : Container(
                                  width: 12,
                                ),
                          Container(
                            margin: EdgeInsets.only(
                              right: 10,
                              left: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            width: Get.width * 0.12,
                            height: Get.height * 0.06,
                            child: controller
                                        .allenquiry_list[index].isSelected ==
                                    false
                                ? Image(
                                    image: AssetImage(
                                      controller.allenquiry_list[index].imageurl
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
                            height: Get.height * 0.07,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width * 0.45,
                                  child: Text(
                                    controller.allenquiry_list[index].personName
                                        .toString(),
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: appcolor().mainColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: Get.height * 0.04,
                                  width: Get.width * 0.5,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontSize: 10,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller
                                              .allenquiry_list[index]
                                              .desc_title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller
                                              .allenquiry_list[index]
                                              .Description,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              controller.allenquiry_list[index].isViewed ==
                                      false
                                  ? Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: appcolor().redColor),
                                      child: Center(
                                        child: Text(
                                          controller.allenquiry_list[index].time
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '2 mins',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: appcolor().mediumGreyColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  index != controller.allenquiry_list.length - 1
                      ? Divider()
                      : SizedBox(),
                ],
              );
            },
          ),
        )
      ],
    ).paddingOnly(
      left: 10,
      right: 10,
      top: 10,
    );
  }

  
Widget Unread_Enquiries(BuildContext ctx) {
  return Column(
      children: [
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
                  hintText: 'Search Enquiries'),
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
            itemCount: controller.allenquiry_list.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (controller.selectedCounter.value > 0) {
                        if (controller.allenquiry_list[index].isSelected ==
                            false) controller.selectedCounter.value++;
                        controller.allenquiry_list[index].isViewed = true;
                        controller.allenquiry_list[index].isSelected = true;
                      } else {
                        controller.allenquiry_list[index].isViewed =
                            !controller.allenquiry_list[index].isViewed!;
                      }
                      setState(() {});
                    },
                    onLongPress: () {
                      controller.allenquiry_list[index].isViewed = true;
                      controller.selectedCounter.value++;
                      controller.allenquiry_list[index].isSelected = true;

                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        10,
                      ),
                      decoration: BoxDecoration(
                        color: controller.allenquiry_list[index].isSelected ==
                                false
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
                        children: [
                          // image container
                          controller.allenquiry_list[index].isViewed == false
                              ? CircleAvatar(
                                  backgroundColor: appcolor().redColor,
                                  radius: 6,
                                )
                              : Container(
                                  width: 12,
                                ),
                          Container(
                            margin: EdgeInsets.only(
                              right: 10,
                              left: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            width: Get.width * 0.12,
                            height: Get.height * 0.06,
                            child: controller
                                        .allenquiry_list[index].isSelected ==
                                    false
                                ? Image(
                                    image: AssetImage(
                                      controller.allenquiry_list[index].imageurl
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
                            height: Get.height * 0.07,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width * 0.45,
                                  child: Text(
                                    controller.allenquiry_list[index].personName
                                        .toString(),
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: appcolor().mainColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: Get.height * 0.04,
                                  width: Get.width * 0.5,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontSize: 10,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller
                                              .allenquiry_list[index]
                                              .desc_title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller
                                              .allenquiry_list[index]
                                              .Description,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              controller.allenquiry_list[index].isViewed ==
                                      false
                                  ? Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: appcolor().redColor),
                                      child: Center(
                                        child: Text(
                                          controller.allenquiry_list[index].time
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '2 mins',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: appcolor().mediumGreyColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  index != controller.allenquiry_list.length - 1
                      ? Divider()
                      : SizedBox(),
                ],
              );
            },
          ),
        )
      ],
    ).paddingOnly(
      left: 10,
      right: 10,
      top: 10,
    );
  
}

Widget Trashed(BuildContext ctx) {
 return Column(
      children: [
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
                  hintText: 'Search Enquiries'),
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
            itemCount: controller.allenquiry_list.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (controller.selectedCounter.value > 0) {
                        if (controller.allenquiry_list[index].isSelected ==
                            false) controller.selectedCounter.value++;
                        controller.allenquiry_list[index].isViewed = true;
                        controller.allenquiry_list[index].isSelected = true;
                      } else {
                        controller.allenquiry_list[index].isViewed =
                            !controller.allenquiry_list[index].isViewed!;
                      }
                      setState(() {});
                    },
                    onLongPress: () {
                      controller.allenquiry_list[index].isViewed = true;
                      controller.selectedCounter.value++;
                      controller.allenquiry_list[index].isSelected = true;

                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        10,
                      ),
                      decoration: BoxDecoration(
                        color: controller.allenquiry_list[index].isSelected ==
                                false
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
                        children: [
                          // image container
                          controller.allenquiry_list[index].isViewed == false
                              ? CircleAvatar(
                                  backgroundColor: appcolor().redColor,
                                  radius: 6,
                                )
                              : Container(
                                  width: 12,
                                ),
                          Container(
                            margin: EdgeInsets.only(
                              right: 10,
                              left: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            width: Get.width * 0.12,
                            height: Get.height * 0.06,
                            child: controller
                                        .allenquiry_list[index].isSelected ==
                                    false
                                ? Image(
                                    image: AssetImage(
                                      controller.allenquiry_list[index].imageurl
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
                            height: Get.height * 0.07,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width * 0.45,
                                  child: Text(
                                    controller.allenquiry_list[index].personName
                                        .toString(),
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: appcolor().mainColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: Get.height * 0.04,
                                  width: Get.width * 0.5,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontSize: 10,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller
                                              .allenquiry_list[index]
                                              .desc_title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller
                                              .allenquiry_list[index]
                                              .Description,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              controller.allenquiry_list[index].isViewed ==
                                      false
                                  ? Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: appcolor().redColor),
                                      child: Center(
                                        child: Text(
                                          controller.allenquiry_list[index].time
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '2 mins',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: appcolor().mediumGreyColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  index != controller.allenquiry_list.length - 1
                      ? Divider()
                      : SizedBox(),
                ],
              );
            },
          ),
        )
      ],
    ).paddingOnly(
      left: 10,
      right: 10,
      top: 10,
    );
  
}

}

// Widget managebottomSheetWidgetitem({
//   required String title,
//   required IconData icondata,
//   required Callback callback,
//   Color? color,
// }) {
//   return InkWell(
//     highlightColor: Colors.grey,
//     hoverColor: Colors.grey,
//     // focusColor: Colors.grey,
//     // splashColor: Colors.grey,
//     // overlayColor: Colors.grey,
//     onTap: callback,
//     child: Row(
//       children: [
//         Container(
//           height: 24,
//           child: Icon(
//             icondata,
//             color: color == null ? Colors.black : color,
//           ),
//         ),
//         SizedBox(
//           width: 18,
//         ),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             color: color == null ? Colors.black : color,
//           ),
//         ),
//       ],
//     ).paddingSymmetric(vertical: 15),
//   );
// }

// // status

// found 2,
// pending 1,
// cancelled 0,
