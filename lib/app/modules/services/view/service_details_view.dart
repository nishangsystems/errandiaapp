import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/categories/CategoryData.dart';
import 'package:errandia/app/modules/errands/view/Product/serivces.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/view/products_send_enquiry.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:errandia/app/modules/reviews/views/add_review.dart';
import 'package:errandia/app/modules/reviews/views/review_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

class ServiceDetailsView extends StatefulWidget {
  final service;

  const ServiceDetailsView({super.key, required this.service});

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView>
    with TickerProviderStateMixin {
  late final TabController tabController =
  TabController(length: 2, vsync: this);
  // final service;
  // _ServiceDetailsViewState(this.service);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("service: ${widget.service.name}");
    }
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => errandia_business_view(index: 2));
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FaIcon(FontAwesomeIcons.store),
                      Text(
                        'Store',
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: Get.width * 0.4,
                  height: 50,
                  child: blockButton(
                    title: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.white,
                          ),
                          Text(
                            '  Chat on Whatsapp',
                            style: TextStyle(color: Colors.white, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                    ontap: () async {},
                    color: appcolor().mainColor,
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.4,
                  height: 50,
                  child: blockButton(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call,
                            color: appcolor().mainColor,
                          ),
                          Text(
                            // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
                            'Call 673580194',
                            style: TextStyle(
                              fontSize: 9,
                              color: appcolor().mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ontap: () {},
                    color: appcolor().skyblueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 244, 244, 244),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: appcolor().mediumGreyColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "${widget.service.name}",
            style: TextStyle(
              color: appcolor().mainColor,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.messenger_sharp,
                size: 30,
              ),
              color: appcolor().mediumGreyColor,
            ),
            IconButton(
              onPressed: () {
                Share.share('text', subject: 'hello share');
              },
              icon: const Icon(
                Icons.share,
                size: 30,
              ),
              color: appcolor().mediumGreyColor,
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // service image
            Container(
              height: 300,
              width: Get.width * 1,
              color: Colors.red,
              child: Image.asset(
                widget.service.imagePath,
                fit: BoxFit.cover,
              ),
            ),

            Column(
              children: [
                product_review_widget(widget.service),

                SizedBox(
                  height: Get.height * 0.02,
                ),
              ],
            ).paddingOnly(top: 20, left: 15, right: 15),

            SizedBox(
              height: Get.height * 0.01,
            ),

            Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                        color: appcolor().greyColor,
                      ))),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: Get.height * 0.07,
                    child: TabBar(
                      // isScrollable: true,
                      dividerColor: appcolor().mediumGreyColor,
                      unselectedLabelColor: appcolor().mediumGreyColor,
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                      indicatorColor: appcolor().mainColor,

                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appcolor().mainColor,
                        fontSize: 18,
                      ),
                      controller: tabController,
                      labelColor: appcolor().darkBlueColor,
                      tabs: const [
                        Tab(
                          text: "Description",
                        ),
                        Tab(
                          text: "Supplier Info",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: Get.height * 0.2,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        // Text('${widget.item['description']}'),
                        const Text('Some description'),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('supplier image'),
                            SizedBox(
                              width: Get.width * 0.08,
                            ),
                            const Column(
                              children: [
                                Text('supplier info  1'),
                                Text('supplier info  1'),
                                Text('supplier info  1'),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: Get.height * 0.015,
            ),

            Container(
              height: Get.height * 0.08,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: appcolor().greyColor,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
              child: InkWell(
                onTap: () {
                  Get.to(product_send_enquiry());
                },
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.message,
                      color: appcolor().blueColor,
                    ),
                    Text(
                      'Send Enquiry',
                      style: TextStyle(color: appcolor().blueColor),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: appcolor().mainColor,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: Get.height * 0.015,
            ),

            // suplier review
            Container(
              height: Get.height * 0.08,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: appcolor().greyColor,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
              child: Row(
                children: [
                  const Text(
                    'Supplier Review',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(Review_view());
                    },
                    child: const Text(
                      'See All',
                    ),
                  ),
                ],
              ),
            ),

            Container(
              // height: Get.height * 0.3,
              width: Get.width,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: appcolor().greyColor,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(left: 20, right: 15, top: 15, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: Get.height * 0.05,
                            width: Get.width * 0.1,
                            color: Colors.white,
                            // child: Image.asset(widget.item['featured_image']),
                            child: Image.asset(
                              widget.service.imagePath,
                            ),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name of supplier',
                              ),
                              Text('location'),
                            ],
                          ),
                          // Spacer(),
                          SizedBox(
                            width: Get.width * 0.13,
                          ),
                          RatingBar.builder(
                            itemCount: 5,
                            direction: Axis.horizontal,
                            initialRating: 1,
                            itemSize: 22,
                            maxRating: 5,
                            allowHalfRating: true,
                            glow: true,
                            itemBuilder: (context, _) {
                              return const Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                            onRatingUpdate: (value) {
                              debugPrint(value.toString());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Recently_item_List.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                          const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                          height: Get.height * 0.2,
                          color: Colors.white,
                          width: Get.width * 0.2,
                          child: Center(
                              child: Image.asset(Recently_item_List[index]
                                  .imagePath
                                  .toString())),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                    ),
                  ),
                ],
              ),
            ),

            InkWell(
              onTap: () {
                var item = {
                  'name': widget.service.name,
                  'imagePath': widget.service.imagePath,
                  'cost': widget.service.cost,
                  'location': widget.service.location,
                  'featured_image': "https://picsum.photos/250?image=9",
                  'address': 'Akwa, Douala',
                };
                Get.to(() => add_review_view(
                  review: item,
                ));
              },
              child: Container(
                margin:
                const EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
                height: Get.height * 0.05,
                width: Get.width * 0.4,
                decoration: BoxDecoration(
                    color: appcolor().mainColor,
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: const Center(
                  child: Text(
                    'Add Your Review',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 10),
              child: Text(
                'More products from this supplier',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              height: Get.height * 0.32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ui_23_item_list.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      // height: Get.height * 0.15,
                      color: Colors.white,
                      width: Get.width * 0.38,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.15,
                            child: Image.asset(
                                ui_23_item_list[index].imagePath.toString()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: appcolor().mediumGreyColor,
                              ),
                              Text(
                                ui_23_item_list[index].location.toString(),
                                style: TextStyle(
                                    color: appcolor().mediumGreyColor,
                                    fontSize: 12),
                              )
                            ],
                          ),
                          Text(
                            ui_23_item_list[index].item_desc,
                            style: TextStyle(
                                fontSize: 12, color: appcolor().mainColor),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ui_23_item_list[index].itemname,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: appcolor().mainColor,
                                fontSize: 16),
                          )
                        ],
                      ));
                },
              ),
            ),

            const Padding(
              padding:
              EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
              child: Text(
                'Services Offered by this Supplier',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              height: Get.height * 0.32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Recently_item_List.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      // height: Get.height * 0.15,
                      color: Colors.white,
                      width: Get.width * 0.38,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.15,
                            child: Image.asset(
                                Recently_item_List[index].imagePath.toString()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: appcolor().mediumGreyColor,
                              ),
                              Text(
                                ui_23_item_list[index].location.toString(),
                                style: TextStyle(
                                    color: appcolor().mediumGreyColor,
                                    fontSize: 12),
                              )
                            ],
                          ),
                          Text(
                            ui_23_item_list[index].item_desc,
                            style: TextStyle(
                                fontSize: 12, color: appcolor().mainColor),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            ui_23_item_list[index].itemname,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: appcolor().mainColor,
                                fontSize: 16),
                          )
                        ],
                      ));
                },
              ),
            ),

            SizedBox(
              height: Get.height * 0.1,
            )

          ],
        )));
  }
}

Widget product_review_widget(item) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      '${item.name}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      '${item.cost}',
      style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: appcolor().darkBlueColor),
    ),
    Row(
      children: [
        RatingBar.builder(
          itemCount: 5,
          direction: Axis.horizontal,
          initialRating: 3,
          itemSize: 22,
          maxRating: 5,
          allowHalfRating: true,
          glow: true,
          itemBuilder: (context, _) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
            );
          },
          onRatingUpdate: (value) {
            debugPrint(value.toString());
          },
        ),
        SizedBox(
          width: Get.width * 0.01,
        ),
        Text(
          // '${item['reviews']} Supplier Reviews',
          '10 Reviews',
          style: TextStyle(color: appcolor().mediumGreyColor, fontSize: 12),
        ),
      ],
    ),
  ]);
}
