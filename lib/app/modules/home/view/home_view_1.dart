import 'dart:convert';
import 'package:errandia/app/modules/errands/view/New_Errand.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../modal/Country.dart';
import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/categories/view/categories.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/common/random_ui/ui_23.dart';
import 'package:errandia/app/modules/errands/view/run_an_errand.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/modal/Country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../modal/Region.dart';
import '../../../../modal/Street.dart';
import '../../../../modal/subcatgeory.dart';
import '../../../../modal/Town.dart';
import '../../../../modal/category.dart';
import '../../categories/CategoryData.dart';
import '../../buiseness/featured_buiseness/view/featured_list_item.dart';
import '../../errands/view/see_all_errands.dart';
import '../../recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:http/http.dart' as http;

class home_view_1 extends StatefulWidget {
  home_view_1({super.key});

  @override
  State<home_view_1> createState() => _home_view_1State();
}

class _home_view_1State extends State<home_view_1> {
  String? isLoggedIn;
  home_controller homeController = Get.put(home_controller());

  Country() async {
    try {
      final response = await http.get(
        Uri.parse('${apiDomain().domain}countries'),
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
        Uri.parse('${apiDomain().domain}categories'),
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
        Uri.parse('${apiDomain().domain}regions'),
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
      final response = await http.get(Uri.parse('${apiDomain().domain}towns'));
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
        Uri.parse('${apiDomain().domain}streets'),
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
        Uri.parse('${apiDomain().domain}streets'),
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
    // TODO: implement initState
    super.initState();
    CountryData();
    RegionData();
    TownData();
    Country();
    street();
    subCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey =
        GlobalKey<ScaffoldState>(); // ADD THIS LINE

    Future<void> locationPermission() async {
      var status = await Permission.location.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Camera access denied')));
      } else if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Camera access permanently denied')));
      } else if (status.isGranted) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!)
            .showSnackBar(const SnackBar(content: Text('Camera access granted')));
      }
    }

    home_controller().atbusiness.value = false;
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
                                ? 'Welcome Kris'
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              color: appcolor().skyblueColor,
              height: Get.height * 0.06,
              child: Row(
                children: [
                  Image(
                    image: const AssetImage(
                      'assets/images/refresh_location.png',
                    ),
                    color: appcolor().mainColor,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        homeController.loggedIn.value
                            ? 'Update Business Location'.tr
                            : 'Update Location'.tr,
                        style: TextStyle(
                            color: appcolor().mainColor, fontSize: 12),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var status = await Permission.location.status;
                      if (status.isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Camera access Permantly denied')));
                      } else {
                        locationPermission();
                      }
                    },
                    child: Text(
                      'Verify Location'.tr,
                      style: TextStyle(
                        color: appcolor().mainColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // categories widget

            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: appcolor().mainColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(const categories_view());
                    },
                    child: const Text('See All'),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
            ),

            Categories_List_Widget(),

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
                      Get.to(Ui_23());
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
                      Get.to(SeeAllErands());
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
          return const Center(
            child: CircularProgressIndicator(),
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
                                    image: const NetworkImage(
                                        "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"),
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

Widget Featured_Businesses_List() {
  return FutureBuilder(
      future: api().bussiness('shops', 1),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            height: Get.height * 0.17,
            color: Colors.white,
            child: const Center(
              child: Text('Featured Businesses not found'),
            ),
          );
        } else if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: Get.height * 0.23,
            color: Colors.white,
            child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                var data = snapshot.data[index];
                return InkWell(
                  onTap: () {
                    Get.to(errandia_business_view(index: index));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: Get.width * 0.4,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: Get.height * 0.09,
                          color: appcolor().lightgreyColor,
                          child: Image(
                            image: NetworkImage(
                              data['image'] != ''
                                  ? data['image'].toString()
                                  : Featured_Businesses_Item_List[index]
                                      .imagePath
                                      .toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.009,
                        ),
                        Text(
                          Featured_Businesses_Item_List[index]
                              .servicetype
                              .toString(),
                          style: TextStyle(
                              fontSize: 12,
                              // fontWeight: FontWeight.bold,
                              color: appcolor().mediumGreyColor),
                        ),
                        SizedBox(
                          height: Get.height * 0.001,
                        ),
                        Text(
                          data['name'].toString(),
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
                            const Icon(Icons.location_on),
                            Text(
                              data['street'],
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
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
      });
}

Widget Recently_posted_items_Widget() {
  return FutureBuilder(
      future: api().getProduct('products', 1),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            height: Get.height * 0.17,
            color: Colors.white,
            child: const Center(
              child: Text('Recently Posted Errands not found'),
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
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: Get.height * 0.45,
            color: Colors.white,
            child: ListView.builder(
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                var data = snapshot.data[index];
                if (kDebugMode) {
                  print("data: $data");
                }

                return InkWell(
                  onTap: () {
                    // Get.to(Product_view(item: data,name: data['name'].toString(),));
                    // Get.back();
                    Get.to(errand_detail_view(
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
                                  backgroundImage: AssetImage(
                                    data['shop']['image'] != ''
                                        ? data['shop']['image'].toString()
                                        : Recently_item_List[index]
                                            .avatarImage
                                            .toString(),
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
                                      data['shop']['name'].toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Text(
                                    //   Recently_item_List[index].date.toString(),
                                    //   style: TextStyle(fontSize: 12),
                                    // ),
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            color: appcolor().lightgreyColor,
                            child: Center(
                              child: Image(
                                image: NetworkImage(
                                  data['featured_image'] != ''
                                      ? data['featured_image'].toString()
                                      : Featured_Businesses_Item_List[index]
                                          .imagePath
                                          .toString(),
                                ),
                                height: Get.height * 0.15,
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
                            margin: EdgeInsets.symmetric(
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
                                  data['name'].toString(),
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
                                    Text(
                                      data['shop']['street'].toString(),
                                      style: TextStyle(
                                          color: appcolor().mainColor),
                                    )
                                  ],
                                ),
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
        } else {
          return Container(
            height: Get.height * 0.17,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      });
}
