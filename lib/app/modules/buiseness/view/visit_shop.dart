import 'package:carousel_slider/carousel_slider.dart';
import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/featured_buiseness/view/featured_list_item.dart';
import 'package:errandia/app/modules/buiseness/view/businesses_view_with_bar.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/view/manage_products_view.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/services/view/service_details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../../products/view/product_view.dart';
import '../../recently_posted_item.dart/view/recently_posted_list.dart';

class VisitShop extends StatefulWidget {
  final Map<String, dynamic> businessData;

  const VisitShop({super.key, required this.businessData});

  @override
  State<VisitShop> createState() => _VisitShopState();
}

class _VisitShopState extends State<VisitShop> {
  final business_controller controller = Get.put(business_controller());

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("businessData: ${widget.businessData['name']}");
    }
    return Scaffold(
        appBar: titledAppBar(widget.businessData['name'], [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
            color: appcolor().mediumGreyColor,
          ),
          IconButton(
            onPressed: () {
              Share.share('text', subject: 'hello share');
            },
            // vertical 3 dots
            icon: const Icon(
              Icons.more_vert,
              size: 30,
            ),
            color: appcolor().mediumGreyColor,
          ),
        ]),
        body: SingleChildScrollView(
          child:
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: Get.width * 1,
                color: Colors.red,
                child: Image.asset(
                  widget.businessData['imagepath'],
                  fit: BoxFit.cover,
                ),
              ),

              Column(
                children: [
                  product_review_widget(),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                ],
              ).paddingOnly(top: 20, left: 15, right: 15),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: InkWell(
                  onTap: () {
                    // errandia_view_bottomsheet();
                  },
                  child: Container(
                    height: Get.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffe6edf7),
                    ),
                    child: Center(
                      child: Text(
                        'Unfollow Shop',
                        style: TextStyle(
                            fontSize: 16, color: appcolor().bluetextcolor),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: Get.height * 0.025,
              ),

              // follow us on social media
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      'Follow us on social media',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // fb
                  InkWell(
                    onTap: () async {
                      controller.mylaunchUrl('www.bmdu.net');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 5,
                      ),
                      child: Icon(
                        FontAwesomeIcons.squareFacebook,
                        color: appcolor().bluetextcolor,
                      ),
                    ),
                  ),

                  // insta
                  InkWell(
                    onTap: () async {
                      controller.mylaunchUrl('www.google.com');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.instagram,
                        color: Colors.pink,
                      ),
                    ),
                  ),

                  // twitter
                  InkWell(
                    onTap: () async {
                      controller.mylaunchUrl('www.instagram.com');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      child: Icon(
                        FontAwesomeIcons.squareTwitter,
                        color: appcolor().bluetextcolor,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: Get.height * 0.03,
              ),

              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      'Products',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: appcolor().mainColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.to(() => manage_product_view());
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),

              product_item_list(),

              SizedBox(
                height: Get.height * 0.03,
              ),

              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      'Services',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: appcolor().mainColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Get.to(() => manage_product_view());
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),

              Service_item_list(),

              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      'Related Businesses',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: appcolor().mainColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.to(BusinessesViewWithBar());
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),

              businesses_item_list(),

              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      'Recently Posted Errands',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: appcolor().mainColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Get.to(BusinessesViewWithBar());
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),

              recently_posted_errands(),
            ],
          ),


        ));
  }
}

Widget product_review_widget() {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text(
      'Rubiliams hair salon',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    const Text(
      'Akwa Douala, Littoral, Cameroon',
      style: TextStyle(fontSize: 15, color: Colors.black),
    ),
    const SizedBox(
      height: 5,
    ),
    Row(
      children: [
        Icon(
          Icons.person,
          size: 18,
          color: appcolor().mediumGreyColor,
        ),
        Text(
          '  Member Since 2010',
          style: TextStyle(
            fontSize: 13,
            color: appcolor().mediumGreyColor,
          ),
        ),
        const Spacer(),
        RatingBar.builder(
          initialRating: 3.5,
          allowHalfRating: true,
          ignoreGestures: true,
          itemSize: 18,
          itemBuilder: (context, index) {
            return const Icon(
              Icons.star_rate_rounded,
              color: Colors.amber,
            );
          },
          onRatingUpdate: (val) {},
        ),
        Text(
          '10 Reviews',
          style: TextStyle(
            fontSize: 11,
            color: appcolor().mediumGreyColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ]);
}

Widget product_item_list() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    height: Get.height * 0.3,
    color: Colors.white,
    child: ListView.builder(
        itemCount: profile_controller().product_list.length,
      primary: false,
      shrinkWrap: false,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
          final item = Recently_item_List[index];

          return GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print("product item clicked: ${item.name}");
                }
                Get.to(() => Product_view(item: item));
              },
              child: profile_controller().product_list[index]);
        },
      ),
  );
}

Widget Service_item_list() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    height: Get.height * 0.3,
    color: Colors.white,
    child: ListView.builder(
      itemCount: profile_controller().service_list.length,
      primary: false,
      shrinkWrap: false,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final item = profile_controller().service_list[index];
        return GestureDetector(
          onTap: () {
            if (kDebugMode) {
              print("service item: ${item.name}");
            }
            Get.to(() => ServiceDetailsView(service: item));
          },
          child: profile_controller().service_list[index],
        );
      },
    ),
  );
}

// widget businesses list
Widget businesses_item_list() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    height: Get.height * 0.3,
    color: Colors.white,
    child: ListView.builder(
      itemCount: business_controller().businessList.length,
      primary: false,
      shrinkWrap: false,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final item = business_controller().businessList[index];
        return GestureDetector(
          onTap: () {
            if (kDebugMode) {
              print("business item: ${item.name}");
            }
            Get.to(() => VisitShop(businessData: item.toJson()));
          },
          child: business_controller().businessList[index],
        );
      },
    ),
  );
}

// widget recently posted errands
Widget recently_posted_errands() {
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