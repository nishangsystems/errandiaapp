import 'dart:convert';

import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/app/modules/profile/view/profile_view.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../APi/apidomain & api.dart';

class SeeAllErrands extends StatefulWidget {
  const SeeAllErrands({super.key});

  @override
  State<SeeAllErrands> createState() => _SeeAllErrandsState();
}

class _SeeAllErrandsState extends State<SeeAllErrands>
    with WidgetsBindingObserver {
  late ScrollController scrollController;
  late errand_controller errandController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      errandController.fetchErrands();
    });

    errandController = Get.put(errand_controller());

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 20) {
        errandController.fetchErrands();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      errandController.reloadErrands();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildRPIErrorWidget(String message, VoidCallback onReload) {
      return !errandController.isErrandLoading.value
          ? Container(
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
                      child: Text(
                        'Retry',
                        style: TextStyle(color: appcolor().lightgreyColor),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : buildLoadingWidget();
    }

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.navigate_before,
                    size: 30,
                    color: appcolor().mediumGreyColor,
                  )),
              title: Text(
                "RECENT ERRANDS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: appcolor().mainColor,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  color: appcolor().mediumGreyColor,
                )
              ],
            ),
            body:
                // SingleChildScrollView(
                //             child:
                Container(
                    height: Get.height * 0.9,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Obx(() {
                      if (errandController.isErrandError.value) {
                        return _buildRPIErrorWidget(
                            'Failed to load recently posted items',
                            errandController.reloadErrands);
                      } else if (errandController.isErrandLoading.value) {
                        return buildLoadingWidget();
                      } else if (errandController.errandList.isEmpty) {
                        return _buildRPIErrorWidget(
                            'No recently posted items found', () {
                          errandController.reloadErrands();
                        });
                      } else {
                        return ListView.builder(
                          key: const PageStorageKey('recentlyPostedItemsList'),
                          controller: scrollController,
                          primary: false,
                          shrinkWrap: false,
                          scrollDirection: Axis.vertical,
                          itemCount: errandController.errandList.length,
                          itemBuilder: (context, index) {
                            var data = errandController.errandList[index];
                            print("errands data: $data");
                            return InkWell(
                              onTap: () {
                                if (kDebugMode) {
                                  print("product data: $data");
                                }
                                // Get.to(Product_view(item: data,name: data['name'].toString(),));
                                Get.to(() => errand_detail_view(data: data));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    width: Get.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: SizedBox(
                                            height: Get.height * 0.09,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      appcolor().mainColor,
                                                  // backgroundImage: NetworkImage(
                                                  //   data['shop']['image'].toString(),
                                                  // ),
                                                  child: data['user']
                                                              ['photo'] ==
                                                          ""
                                                      ? const Icon(Icons.person)
                                                      : FadeInImage
                                                          .assetNetwork(
                                                          placeholder:
                                                              'assets/images/errandia_logo.png',
                                                          image: getImagePath(
                                                              data['user']
                                                                      ['photo']
                                                                  .toString()),
                                                          fit: BoxFit.cover,
                                                          imageErrorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Image.asset(
                                                              'assets/images/errandia_logo.png',
                                                              // Your fallback image
                                                              fit: BoxFit.cover,
                                                            );
                                                          },
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.02,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      capitalizeAll(
                                                          data['user']['name']),
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(DateTime.parse(
                                                              data['created_at']
                                                                  .toString())),
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: appcolor().mediumGreyColor,
                                        ),
                                        Container(
                                          height: Get.height * 0.25,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 0),
                                          color: Colors.white,
                                          child: Center(
                                            child: data['images'].length > 0
                                                ? FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'assets/images/errandia_logo.png',
                                                    image: getImagePath(
                                                        data['images'][0]['url']
                                                            .toString()),
                                                    fit: BoxFit.cover,
                                                    imageErrorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                        'assets/images/errandia_logo.png',
                                                        // Your fallback image
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  )
                                                : Image.asset(
                                                    'assets/images/errandia_logo.png',
                                                    // Your fallback image
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        Divider(
                                          color: appcolor().mediumGreyColor,
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.009,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   Featured_Businesses_Item_List[index]
                                              //       .servicetype
                                              //       .toString(),
                                              //   style: TextStyle(
                                              //       fontSize: 13,
                                              //       fontWeight: FontWeight.bold,
                                              //       color: appcolor().mediumGreyColor),
                                              // ),
                                              // SizedBox(
                                              //   height: Get.height * 0.001,
                                              // ),
                                              Text(
                                                capitalizeAll(data['title'].toString()),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        appcolor().mainColor),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.003,
                                              ),
                                              data['street'] != "" &&
                                                      data['street'] != null
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          size: 13,
                                                          color: appcolor()
                                                              .mediumGreyColor,
                                                        ),
                                                        Text(
                                                          data['street']
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: appcolor()
                                                                .mediumGreyColor,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(
                                                      height: 6,
                                                    )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    })

                    // )
                    )));
  }
}
