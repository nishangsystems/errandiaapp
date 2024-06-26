import 'dart:convert';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:errandia/app/modules/buiseness/view/businesses_view_with_bar.dart';
import 'package:errandia/app/modules/errands/view/New_Errand.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/global/Widgets/errand_widget_card.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/home/view/home_view.dart';
import 'package:errandia/app/modules/products/view/add_product_view.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../modal/Country.dart';
import '../../../../modal/Region.dart';
import '../../../../modal/Street.dart';
import '../../../../modal/Town.dart';
import '../../../../modal/category.dart';
import '../../../../modal/subcatgeory.dart';
import '../../categories/CategoryData.dart';
import '../../errands/view/see_all_errands.dart';

// final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class home_view_1 extends StatefulWidget {
  home_view_1({super.key});

  @override
  State<home_view_1> createState() => _home_view_1State();
}

class _home_view_1State extends State<home_view_1> with WidgetsBindingObserver {
  String? isLoggedIn;
  late home_controller homeController;
  late profile_controller profileController;

  // List<dynamic> recentlyPostedItemsData = [];
  // List<dynamic> featuredBusinessesData = [];
  // bool _isRPILoading = true;
  // bool _isFBLLoading = true;
  // bool isRPIError = false;
  // bool isFBLError = false;
  // Country() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('${apiDomain().domain}/countries'),
  //     );
  //     if (response.statusCode == 200) {
  //       final catalogJson = response.body;
  //       final decodedData = jsonDecode(catalogJson);
  //       var productsData = decodedData["data"];
  //       Countryy.Itemss = List.from(productsData)
  //           .map<CountryCode>((product) => CountryCode.fromJson(product))
  //           .toList();
  //       setState(() {});
  //     }
  //   } catch (w) {
  //     throw Exception(w.toString());
  //   }
  // }

  RegionData() async {
    try {
      final response = await http.get(
        Uri.parse('${apiDomain().domain}/regions'),
      );
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        print(productsData);
        Regions.Items = List.from(productsData)
            .map<CountryRegion>((product) => CountryRegion.fromJson(product))
            .toList();
        setState(() {});
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  subCategoryData() async {
    try {
      final response = await http.get(
        Uri.parse('${apiDomain().domain}/streets'),
      );
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        // print(productsData);
        subCetegoryData.Items = List.from(productsData)
            .map<Sub>((product) => Sub.fromJson(product))
            .toList();
        setState(() {});
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  void loadIsLoggedIn() async {
    isLoggedIn = await checkLogin();
    homeController.loggedIn.value =
        isLoggedIn != null && isLoggedIn!.isNotEmpty;

    print('INIT: Is logged in: $isLoggedIn');
  }

  Future<String?> checkLogin() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedpref.getString('token');
    print('Is logged in: $isLoggedIn');
    return isLoggedIn;
  }

  @override
  void initState() {
    super.initState();
    homeController = Get.put(home_controller());
    profileController = Get.put(profile_controller());
    // CountryData();
    RegionData();
    // TownData();
    // Country();
    // street();
    subCategoryData();
    homeController.featuredBusinessData();
    homeController.recentlyPostedItemsData();
    // if (homeController.loggedIn.value) {
    profileController.getUser();
    // }
  }

  String _formatAddress(Map<String, dynamic> item) {
    print("item: $item");
    // String street = item['street'].toString() != '[]' && '';
    String townName =
        item['town'].toString() != 'null' && item['town'].toString() != '[]'  ? item['town']['name'] : '';
    String regionName = item['region'].toString() != 'null' && item['region'].toString() != '[]'
        ? item['region']['name'].split(" -")[0]
        : '';

    return [townName, regionName].where((s) => s.isNotEmpty).join(", ").trim();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      profileController.getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey =
        GlobalKey<ScaffoldState>(); // ADD THIS LINE
    home_controller().atbusiness.value = false;

    Future<void> locationPermission() async {
      var status = await Permission.location.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Camera access denied')));
      } else if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Camera access permanently denied')));
      } else if (status.isGranted) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Camera access granted')));
      }
    }

    Widget _buildRPIErrorWidget(String message, VoidCallback onReload) {
      return !homeController.isRPILoading.value
          ? Container(
              height: Get.height * 0.3,
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

    Widget _buildFBLErrorWidget(String message, VoidCallback onReload) {
      return !homeController.isFBLLoading.value
          ? Container(
              height: Get.height * 0.3,
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

    Widget Recently_posted_items_Widget() {
      return Obx(() {
        if (homeController.isRPIError.value) {
          return _buildRPIErrorWidget('Failed to load recently posted items',
              homeController.reloadRecentlyPostedItems);
        } else if (homeController.isRPILoading.value) {
          return Container(
            height: Get.height * 0.33,
            color: Colors.white,
            child: buildLoadingWidget(),
          );
        } else if (homeController.recentlyPostedItemsData.isEmpty) {
          return Container(
            height: Get.height * 0.33,
            color: Colors.white,
            child: const Center(
              child: Text('No recently posted errands found.'),
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: Get.height * 0.45,
            color: Colors.white,
            child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: homeController.recentlyPostedItemsData.length > 4
                  ? 4
                  : homeController.recentlyPostedItemsData.length,
              itemBuilder: (context, index) {
                var data = homeController.recentlyPostedItemsData[index];

                return InkWell(
                  onTap: () {
                    // Get.to(Product_view(item: data,name: data['name'].toString(),));
                    // Get.back();
                    Get.to(() => errand_detail_view(
                          data: data,
                        ));
                  },
                  child: ErrandWidgetCard(
                    data: data,
                  )
                );
              },
            ),
          );
        }
      });
    }

    Widget Featured_Businesses_List() {
      return Obx(() {
        if (homeController.isFBLError.value) {
          return _buildFBLErrorWidget("Failed to load featured businesses",
              homeController.reloadFeaturedBusinessesData);
        } else if (homeController.isFBLLoading.value) {
          print("fbl: ${homeController.isFBLLoading.value}");
          return Container(
            height: Get.height * 0.33,
            color: Colors.white,
            child: buildLoadingWidget(),
          );
        } else if (homeController.featuredBusinessData.isEmpty) {
          return Container(
            height: Get.height * 0.33,
            color: Colors.white,
            child: const Center(
              child: Text('No featured businesses found.'),
            ),
          );
        } else {
          print("fbl: ${homeController.featuredBusinessData}");
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: Get.height * 0.33,
            color: Colors.white,
            child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: homeController.featuredBusinessData.length > 4
                  ? 4
                  : homeController.featuredBusinessData.length,
              itemBuilder: (context, index) {
                var data = homeController.featuredBusinessData[index];
                print("sub data: ${data['street']}");
                return InkWell(
                  onTap: () {
                    // Get.to(() => errandia_business_view(key: UniqueKey(), businessData: data));
                    Get.toNamed('/business_view',
                        arguments: data, preventDuplicates: false);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: Get.width * 0.4,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.005,
                        ),
                        // Image(
                        //   image: NetworkImage(data['image'] != ''
                        //       ? getImagePath(data['image'].toString())
                        //       : 'https://errandia.com/assets/images/logo-default.png'),
                        //   fit: BoxFit.fill,
                        //   height: Get.height * 0.15,
                        //   // width: Get.width * 0.3,
                        // )
                        Container(
                          height: Get.height * 0.16,
                          width: Get.width * 0.4,
                          color: appcolor().lightgreyColor,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/errandia_logo.png',
                            image: getImagePathWithSize(
                                data['image'].toString(),
                                width: 200,
                                height: 180),
                            fit: BoxFit.contain,
                            width: double.infinity,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/errandia_logo.png',
                                // Your fallback image
                                fit: BoxFit.fill,
                                // width: double.infinity,
                                height: Get.height * 0.16,
                              );
                            },
                          ),
                        ).paddingOnly(left: 3, right: 3, top: 10, bottom: 5),
                        SizedBox(
                          height: Get.height * 0.009,
                        ),
                        SizedBox(
                            width: Get.width * 0.4,
                            child: Text(
                              data['category']['name'].toString(),
                              style: TextStyle(
                                  fontSize: 11,
                                  // fontWeight: FontWeight.bold,
                                  color: appcolor().mediumGreyColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ).paddingOnly(left: 3)),
                        SizedBox(
                          height: Get.height * 0.001,
                        ),
                        Text(
                          capitalizeAll(data['name'] ?? ""),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: appcolor().mainColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).paddingOnly(left: 3),
                        SizedBox(
                          height: Get.height * 0.001,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: appcolor().mediumGreyColor,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            SizedBox(
                              width: Get.width * 0.35,
                              child: Text(
                                _formatAddress(data),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: appcolor().mediumGreyColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const AssetImage(
              'assets/images/home_bg.png',
            ),
            fit: BoxFit.fill,
            height: Get.height,
            width: Get.width,
          ),
          // plus icon
          
          ListView(
            // physics: (),
            children: [
              // welcome widget
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SizedBox(
                  height: Get.height * 0.16,
                  width: Get.width,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              homeController.loggedIn.value
                                  ? 'Welcome ${capitalizeAll(getLastName(profileController.userData['name']))}'
                                  : 'Welcome',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Start by running an errand',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              if (homeController.loggedIn.value) {
                                Get.to(() => const New_Errand());
                              } else {
                                Get.to(() => const signin_view());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            child: Text(
                              'Run an Errand',
                              style: TextStyle(
                                  color: appcolor().mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 6),
              //   color: appcolor().skyblueColor,
              //   height: Get.height * 0.06,
              //   child: Row(
              //     children: [
              //       Image(
              //         image: const AssetImage(
              //           'assets/images/refresh_location.png',
              //         ),
              //         color: appcolor().mainColor,
              //       ),
              //       Expanded(
              //         child: Text(
              //           homeController.loggedIn.value
              //               ? 'Update Business Location'.tr
              //               : 'Update Location'.tr,
              //           style:
              //               TextStyle(color: appcolor().mainColor, fontSize: 12),
              //         ),
              //       ),
              //       TextButton(
              //         onPressed: () async {
              //           var status = await Permission.location.status;
              //           if (status.isGranted) {
              //             ScaffoldMessenger.of(scaffoldKey.currentContext!)
              //                 .showSnackBar(const SnackBar(
              //                     content:
              //                         Text('Camera access permanently denied')));
              //           } else {
              //             locationPermission();
              //           }
              //         },
              //         child: Text(
              //           'Verify Location'.tr,
              //           style: TextStyle(
              //             color: appcolor().mainColor,
              //             fontSize: 10,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // categories widget

              // Container(
              //   color: Colors.white,
              //   child: Row(
              //     children: [
              //       Text(
              //         'Categories',
              //         style: TextStyle(
              //           fontWeight: FontWeight.w700,
              //           fontSize: 18,
              //           color: appcolor().mainColor,
              //         ),
              //       ),
              //       const Spacer(),
              //       TextButton(
              //         onPressed: () {
              //           Get.to(const categories_view());
              //         },
              //         child: const Text('See All'),
              //       ),
              //     ],
              //   ).paddingSymmetric(horizontal: 20),
              // ),
              //
              // Categories_List_Widget(),

              // Featured Businesses

              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      'Featured Businesses',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: appcolor().mainColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.to(() => BusinessesViewWithBar())?.then((_) {
                          homeController.featuredBusinessData.clear();
                          homeController.fetchFeaturedBusinessesData();
                        });
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),

              Featured_Businesses_List(),

              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      'Recently Posted Errands',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: appcolor().mainColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const SeeAllErrands());
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),

              Recently_posted_items_Widget(),
            ],
          ),

          // Positioned(
          //   top: 10,
          //   // right: 20,
          //   child: ExpandableFab(
          //     key: _key,
          //     overlayStyle: ExpandableFabOverlayStyle(
          //       // color: Colors.black.withOpacity(0.5),
          //       blur: 5,
          //     ),
          //     onOpen: () {
          //       debugPrint('onOpen');
          //     },
          //     afterOpen: () {
          //       debugPrint('afterOpen');
          //     },
          //     onClose: () {
          //       debugPrint('onClose');
          //     },
          //     afterClose: () {
          //       debugPrint('afterClose');
          //     },
          //     children: [
          //       FloatingActionButton.small(
          //         // shape: const CircleBorder(),
          //         heroTag: null,
          //         child: const Icon(Icons.edit),
          //         onPressed: () {
          //           const SnackBar snackBar = SnackBar(
          //             content: Text("SnackBar"),
          //           );
          //           // scaffoldKey.currentState?.showSnackBar(snackBar);
          //           HomeMessenger.scaffoldKey.currentState?.showSnackBar(snackBar);
          //         },
          //       ),
          //       FloatingActionButton.small(
          //         // shape: const CircleBorder(),
          //         heroTag: null,
          //         child: const Icon(Icons.search),
          //         onPressed: () {
          //           // Navigator.of(context).push(
          //           //     MaterialPageRoute(builder: ((context) => const NextPage())));
          //           print("going to next page");
          //         },
          //       ),
          //       FloatingActionButton.small(
          //         // shape: const CircleBorder(),
          //         heroTag: null,
          //         child: const Icon(Icons.share),
          //         onPressed: () {
          //           final state = _key.currentState;
          //           if (state != null) {
          //             debugPrint('isOpen:${state.isOpen}');
          //             state.toggle();
          //           }
          //         },
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}

Widget Categories_List_Widget() {
  return FutureBuilder(
      future: api().GetData('categories'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // return a container with text "data not found"
          return Container(
            height: Get.height * 0.17,
            color: Colors.white,
            child: const Center(
              child: Text('Categories not found'),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height * 0.17,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return SafeArea(
            child: Container(
              height: Get.height * 0.17,
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data[index];
                  return InkWell(
                    onTap: () {
                      Get.to(CategoryData(
                        name: data['name'].toString(),
                      ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: Get.width * 0.2,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            color: appcolor().lightgreyColor,
                            child: data['icon_url'] != ''
                                ? SvgPicture.network(data['icon_url'],
                                    // colorFilter: ColorFilter.mode( BlendMode.srcIn),
                                    semanticsLabel: 'A red up arrow')
                                : Image(
                                    image: const AssetImage(
                                      'assets/images/errandia_logo.png',
                                    ),
                                    height: Get.height * 0.05,
                                    width: Get.width * 0.1,
                                  ),
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Text(
                            data['name'].toString(),
                            style: const TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return Container(
            height: Get.height * 0.17,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return CircularProgressIndicator();
      });
}

void _reloadFeaturedBusinesses() {
  print('Reloading featured businesses');
}
