import 'package:errandia/app/APi/business.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/view/business_item.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/constants/color.dart';

class BusinessesViewWithBar extends StatefulWidget {
  BusinessesViewWithBar({super.key});

  @override
  State<BusinessesViewWithBar> createState() => _BusinessesViewWithBarState();
}

class _BusinessesViewWithBarState extends State<BusinessesViewWithBar> {
  late business_controller busi_controller;
  late ScrollController scrollController;
  List<dynamic> featuredBusinessesData = [];

  // Reload function for featured businesses
  void _reloadFeaturedBusinessesData() {
    busi_controller.itemList.clear();
    busi_controller.loadBusinesses();
  }


  @override
  void initState() {
    super.initState();
    busi_controller = Get.put(business_controller());

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 20) {
        busi_controller.loadBusinesses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    home_controller().atbusiness.value = true;


    Widget _buildFBLErrorWidget(String message, VoidCallback onReload) {
      return !busi_controller.isLoading.value ? Container(
        height: Get.height * 0.9,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              ElevatedButton(
                onPressed: onReload,
                style: ElevatedButton.styleFrom(
                  primary: appcolor().mainColor,
                ),
                child: Text('Retry',
                  style: TextStyle(
                      color: appcolor().lightgreyColor
                  ),
                ),
              ),
            ],
          ),
        ),
      ): buildLoadingWidget();
    }


    return Scaffold(
      appBar: appbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // address widget

          // Container(
          //   decoration: BoxDecoration(
          //     color: const Color.fromARGB(255, 255, 255, 255),
          //     border: Border.symmetric(
          //       horizontal: BorderSide(
          //         color: appcolor().greyColor,
          //       ),
          //     ),
          //   ),
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   height: Get.height * 0.06,
          //   child: Row(
          //     children: [
          //       Icon(
          //         FontAwesomeIcons.buildingUser,
          //         color: appcolor().mediumGreyColor,
          //         size: 18,
          //       ),
          //       SizedBox(
          //         width: Get.width * 0.05,
          //       ),
          //       Text(
          //         'Update Your Business Info',
          //         style: TextStyle(fontSize: 13),
          //       ),
          //       Spacer(),
          //       TextButton(
          //         onPressed: () {},
          //         child: Text(
          //           'Update Bussiness',
          //           style: TextStyle(
          //             color: appcolor().blueColor,
          //             fontSize: 10,
          //             fontWeight: FontWeight.w700,
          //             decoration: TextDecoration.underline,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          //business
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Text(
                  'Business ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: appcolor().mainColor,
                  ),
                ),
                Spacer(),
                // InkWell(
                //   onTap: () {
                //     Get.bottomSheet(
                //       Container(
                //         color: const Color.fromRGBO(255, 255, 255, 1),
                //         child: Wrap(
                //           crossAxisAlignment: WrapCrossAlignment.start,
                //           children: [
                //             Text(
                //               'Sort List',
                //               style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 22,
                //                 color: appcolor().mainColor,
                //               ),
                //             ),
                //             // z-a
                //             Row(
                //               children: [
                //                 RichText(
                //                   text: TextSpan(
                //                     style: TextStyle(fontSize: 16),
                //                     children: [
                //                       TextSpan(
                //                         text: 'Business Name : ',
                //                         style: TextStyle(
                //                           color: appcolor().mainColor,
                //                         ),
                //                       ),
                //                       TextSpan(
                //                         text: 'Desc Z-A',
                //                         style: TextStyle(
                //                           color: appcolor().mediumGreyColor,
                //                         ),
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //                 Spacer(),
                //                 Obx(
                //                   () => Radio(
                //                     value: 'sort descending',
                //                     groupValue:
                //                         busi_controller.sorting_value.value,
                //                     onChanged: (val) {
                //                       busi_controller.sorting_value.value =
                //                           val.toString();
                //                     },
                //                   ),
                //                 )
                //               ],
                //             ),
                //
                //             // a-z
                //             Row(
                //               children: [
                //                 RichText(
                //                   text: TextSpan(
                //                     style: TextStyle(fontSize: 16),
                //                     children: [
                //                       TextSpan(
                //                         text: 'Business Name : ',
                //                         style: TextStyle(
                //                           color: appcolor().mainColor,
                //                         ),
                //                       ),
                //                       TextSpan(
                //                         text: 'Asc A-Z',
                //                         style: TextStyle(
                //                           color: appcolor().mediumGreyColor,
                //                         ),
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //                 Spacer(),
                //                 Obx(() => Radio(
                //                       value: 'sort acending',
                //                       groupValue:
                //                           busi_controller.sorting_value.value,
                //                       onChanged: (val) {
                //                         busi_controller.sorting_value.value =
                //                             val.toString();
                //                       },
                //                     ))
                //               ],
                //             ),
                //
                //             // distance nearest to me
                //             Row(
                //               children: [
                //                 RichText(
                //                     text: TextSpan(
                //                         style: TextStyle(fontSize: 16),
                //                         children: [
                //                       TextSpan(
                //                         text:
                //                             'Distance: Nearest to my location',
                //                         style: TextStyle(
                //                           color: appcolor().mainColor,
                //                         ),
                //                       ),
                //                     ])),
                //                 Spacer(),
                //                 Obx(() => Radio(
                //                       value: 'distance nearest to my location',
                //                       groupValue:
                //                           busi_controller.sorting_value.value,
                //                       onChanged: (val) {
                //                         busi_controller.sorting_value.value =
                //                             val.toString();
                //                       },
                //                     ))
                //               ],
                //             ),
                //
                //             //recentaly added
                //             Row(
                //               children: [
                //                 Text(
                //                   'Recently Added ',
                //                   style: TextStyle(
                //                       color: appcolor().mainColor,
                //                       fontSize: 16),
                //                 ),
                //                 Icon(
                //                   Icons.arrow_upward,
                //                   size: 25,
                //                   color: appcolor().mediumGreyColor,
                //                 ),
                //                 Spacer(),
                //                 Obx(
                //                   () => Radio(
                //                     value: 'recentaly added',
                //                     groupValue:
                //                         busi_controller.sorting_value.value,
                //                     onChanged: (val) {
                //                       busi_controller.sorting_value.value =
                //                           val.toString();
                //                       print(val.toString());
                //                     },
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ],
                //         ).paddingSymmetric(
                //           horizontal: 20,
                //           vertical: 10,
                //         ),
                //       ),
                //     );
                //   },
                //   child: Container(
                //     height: Get.height * 0.05,
                //     width: Get.width * 0.1,
                //     decoration: const BoxDecoration(
                //         // color: Colors.amber,
                //         shape: BoxShape.circle),
                //     child: const Icon(Icons.sort),
                //   ),
                // ),

                // ),
              ],
            ),
          ),

          // horizontal list
          // Container(
          //   padding: const EdgeInsets.only(left: 10),
          //   height: 60,
          //   // color: Colors.black,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (context, index) {
          //       return Center(
          //         child: horizontal_list_item(),
          //       );
          //     },
          //   ),
          // ),

          // business list grid view
          Expanded(
            child: Obx(() {
              if (busi_controller.isLoading.value == true) {
                return buildLoadingWidget();
              } else if (busi_controller.isFBLError.value) {
                return _buildFBLErrorWidget('Failed to load businesses', _reloadFeaturedBusinessesData);
              } else {
                return RefreshIndicator(
                    child: Obx(
                        () {
                          return GridView.builder(
                            key: const PageStorageKey('businesses'),
                            controller: scrollController,
                            itemCount: busi_controller.isLoading.value
                                ? busi_controller.itemList.length + 1
                                : busi_controller.itemList.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1 / 1.47,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                            ),
                            itemBuilder: (context, index) {
                              if (index >= busi_controller.itemList.length) {
                                return busi_controller.isLoading.value ? const Center(child: CircularProgressIndicator()) : Container();
                              }

                              var business = busi_controller.itemList[index];
                              return InkWell(
                                onTap: () {
                                  Get.to(() => errandia_business_view(
                                    businessData: business,
                                  ));
                                },
                                child: Container(
                                  height: Get.height * 0.4,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    // border: Border.all(color: appcolor().greyColor)
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 1, vertical: 1),
                                  // width: Get.width * 0.4,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: appcolor().lightgreyColor,
                                        child: Image.network(
                                          getImagePath(business['image'].toString()),
                                          height: Get.height * 0.17,
                                          width: Get.width * 0.4,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/errandia_logo.png',
                                              height: Get.height * 0.17,
                                              width: Get.width * 0.4,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      business['category'] != null
                                          ? Text(
                                        business['category']['name'] ?? "",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: appcolor().mediumGreyColor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                          ) : Text(
                                        "No category provided",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: appcolor().mediumGreyColor,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.001,
                                      ),
                                      Text(
                                        capitalizeAll(business['name'] ?? ""),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: appcolor().mainColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.001,
                                      ),
                                      business['street'] != null && business['street'].toString().isNotEmpty == true
                                          ? Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 13,
                                            color: appcolor().mediumGreyColor,
                                          ),
                                          Text(
                                            business['street'].toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: appcolor().mediumGreyColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      )
                                          : Text(
                                        "No location provided",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: appcolor().mediumGreyColor,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).paddingSymmetric(horizontal: 10);
                        }
                    ),
                    onRefresh: () async {
                      Get.find<business_controller>().currentPage.value = 1;
                      Get.find<business_controller>().loadBusinesses();
                    });
              }
            }),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
