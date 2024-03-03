import 'dart:convert';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/modules/buiseness/view/businesses_view_with_bar.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/errands/view/New_Errand.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

class home_view_1 extends StatefulWidget {
  home_view_1({super.key});

  @override
  State<home_view_1> createState() => _home_view_1State();
}

class _home_view_1State extends State<home_view_1> {
  String? isLoggedIn;
  late home_controller homeController;
  late profile_controller profileController;

  // List<dynamic> recentlyPostedItemsData = [];
  // List<dynamic> featuredBusinessesData = [];
  // bool _isRPILoading = true;
  // bool _isFBLLoading = true;
  // bool isRPIError = false;
  // bool isFBLError = false;

  Country() async {
    try {
      final response = await http.get(
        Uri.parse('${apiDomain().domain}/countries'),
      );
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        Countryy.Itemss = List.from(productsData)
            .map<CountryCode>((product) => CountryCode.fromJson(product))
            .toList();
        setState(() {});
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  CountryData() async {
    try {
      final response = await http.get(
        Uri.parse('${apiDomain().domain}/categories'),
      );
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        categor.Items = List.from(productsData)
            .map<Caegory>((product) => Caegory.fromJson(product))
            .toList();
        setState(() {});
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

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

  TownData() async {
    try {
      final response = await http.get(Uri.parse('${apiDomain().domain}/towns'));
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];

        Towns.Items = List.from(productsData)
            .map<Town>((product) => Town.fromJson(product))
            .toList();
        setState(() {});
      }
    } catch (w) {
      throw Exception(w.toString());
    }
  }

  street() async {
    try {
      final response = await http.get(
        Uri.parse('${apiDomain().domain}/streets'),
      );
      if (response.statusCode == 200) {
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];

        Street.Items = List.from(productsData)
            .map<Streetid>((product) => Streetid.fromJson(product))
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
    CountryData();
    RegionData();
    // TownData();
    Country();
    street();
    subCategoryData();
    homeController.featuredBusinessData();
    homeController.recentlyPostedItemsData();
    if (homeController.loggedIn.value) {
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
            height: Get.height * 0.45,
            color: Colors.white,
            child: buildLoadingWidget(),
          );
        } else if (homeController.recentlyPostedItemsData.isEmpty) {
          return Container(
            height: Get.height * 0.45,
            color: Colors.white,
            child: const Center(
              child: Text('No recently posted items'),
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
                  child: Card(
                    child: Container(
                      width: Get.width * 0.5,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * 0.09,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: appcolor().mainColor,
                                  child: data['user']['photo'] == ""
                                      ? const Icon(Icons.person)
                                      : FadeInImage.assetNetwork(
                                          placeholder:
                                              'assets/images/errandia_logo.png',
                                          image: getImagePath(
                                              data['user']['photo'].toString()),
                                          fit: BoxFit.cover,
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                          Divider(
                            color: appcolor().mediumGreyColor,
                          ),
                          Container(
                            height: Get.height * 0.2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            color: appcolor().lightgreyColor,
                            child: Center(
                              child:  data['images'].length > 0
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
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  height: Get.height * 0.001,
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
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
              child: Text('No featured businesses'),
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
                    Get.to(() => errandia_business_view(businessData: data));
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
                        Container(
                          height: Get.height * 0.15,
                          width: Get.width,
                          color: appcolor().lightgreyColor,
                          child: Image(
                            image: NetworkImage(data['image'] != ''
                                ? getImagePath(data['image'].toString())
                                : 'https://errandia.com/assets/images/logo-default.png'),
                            fit: BoxFit.fill,
                            height: Get.height * 0.15,
                            // width: Get.width * 0.3,
                          ),
                        ).paddingOnly(left: 3, right: 3, top: 10, bottom: 5),
                        SizedBox(
                          height: Get.height * 0.009,
                        ),
                        Text(
                          data['category']['name'].toString(),
                          style: TextStyle(
                              fontSize: 11,
                              // fontWeight: FontWeight.bold,
                              color: appcolor().mediumGreyColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ).paddingOnly(left: 3),
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
                        (data['street'] != '' && data['street'] != null)
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: appcolor().mediumGreyColor,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 1,
                                  ),
                                  Text(
                                    data['street'].toString(),
                                    style: const TextStyle(fontSize: 12),
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
            ),
          );
        }
      });
    }

    return Stack(
      children: [
        Image(
          image: const AssetImage(
            'assets/images/home_bg.png',
          ),
          fit: BoxFit.fill,
          height: Get.height,
          width: Get.width,
        ),
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
                            Get.to(New_Errand());
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
            Container(
              height: Get.height * 0.05,
              color: Colors.white,
            ),
          ],
        ),
      ],
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
