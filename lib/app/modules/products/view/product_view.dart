import 'package:carousel_slider/carousel_slider.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/products/view/products_send_enquiry.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:errandia/app/modules/reviews/views/add_review.dart';
import 'package:errandia/app/modules/reviews/views/review_view.dart';
import 'package:errandia/common/random_ui/ui_23.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import '../../errands/view/Product/serivces.dart';
import '../../global/constants/color.dart';

class Product_view extends StatefulWidget {
  final item;
  final name;
  Product_view({super.key,required this.item, this.name});

  @override
  State<Product_view> createState() => _Product_viewState(item);
}

class _Product_viewState extends State<Product_view>
    with TickerProviderStateMixin {
  late final TabController tabController =
  TabController(length: 2, vsync: this);
final item;
  _Product_viewState(this.item);

  @override
  Widget build(BuildContext context) {
  //  print(widget.item.product_name);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){
                  Get.to(Product_serivices());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FaIcon(FontAwesomeIcons.store),
                    Text(
                      'Store',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
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
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                        ),
                        Text(
                          '  Chat on Whatsapp',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9
                          ),
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
                          'Call ${widget.item['shop']['phone']}',
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
          "${widget.name}",
          style: TextStyle(
            color: appcolor().mainColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.messenger_sharp,
              size: 30,
            ),
            color: appcolor().mediumGreyColor,
          ),
          IconButton(
            onPressed: () {
              Share.share('text',subject: 'hello share');
            },
            icon: Icon(
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
            Column(
              children: [
                image_select_widget(widget.item['images']),
                product_review_widget(widget.item),
                // SizedBox(
                //   height: Get.height * 0.03,
                // ),
                // chat on whatsapp button
                // blockButton(
                //   title: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(
                //         FontAwesomeIcons.whatsapp,
                //         color: Colors.white,
                //       ),
                //       Text(
                //         '  Chat on Whatsapp',
                //         style: TextStyle(
                //           color: Colors.white,
                //         ),
                //       )
                //     ],
                //   ),
                //   ontap: () {},
                //   color: appcolor().mainColor,
                // ),

                // call button
                SizedBox(
                  height: Get.height * 0.02,
                ),
                // blockButton(
                //   title: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(
                //         FontAwesomeIcons.phone,
                //         color: appcolor().mainColor,
                //         size: 18,
                //       ),
                //       Text(
                //         '  Call 673580194',
                //         style: TextStyle(
                //             color: appcolor().mainColor, fontSize: 16),
                //       )
                //     ],
                //   ),
                //   ontap: () {},
                //   color: appcolor().skyblueColor,
                // ),
              ],
            ).paddingOnly(
              left: 15,
              right: 15,
              top: 20,
            ),

           // tab bar view
            SizedBox(
              height: Get.height * 0.01,
            ),
            // Divider(
            //   color: appcolor().mediumGreyColor,
            // ),
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
                      unselectedLabelStyle: TextStyle(
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
                      tabs: [
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
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: Get.height * 0.2,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        Text(
                          '${widget.item['description']}'
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text('supplier image'),
                              ),
                              SizedBox(
                                width: Get.width * 0.08,
                              ),
                              Column(
                                children: [
                                  Text('supplier info  1'),
                                  Text('supplier info  1'),
                                  Text('supplier info  1'),
                                ],
                              )
                            ],
                          ),
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
              padding: EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
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
                      '   Send Enquiry',
                      style: TextStyle(color: appcolor().blueColor),
                    ),
                    Spacer(),
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
              padding: EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
              child: Row(
                children: [
                  Text(
                    'Supplier Review',
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(Review_view());
                    },
                    child: Text(
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
              padding: EdgeInsets.only(left: 20, right: 15, top: 15, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              height: Get.height * 0.05,
                              width: Get.width * 0.1,
                              color: Colors.white,
                              child: Image.asset(widget.item['featured_image']),
                            ),
                            Column(
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
                                return Icon(
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
                      ),
                    ],
                  ),
                  Container(
                    height: Get.height * 0.15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Recently_item_List.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                          EdgeInsets.only(right: 10, top: 10, bottom: 10),
                          height: Get.height * 0.2,
                          color: Colors.white,
                          width: Get.width * 0.2,
                          child: Center(
                              child: Image.asset(Recently_item_List[index].imagePath.toString())
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                    ),
                  ),
                ],
              ),
            ),

            // add your Reviews

            InkWell(
              onTap: (){
                Get.to(add_review_view(review: item,));
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
                height: Get.height * 0.05,
                width: Get.width * 0.4,
                decoration: BoxDecoration(
                    color: appcolor().mainColor,
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Text(
                    'Add Your Review',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white,fontSize: 12),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 15, top: 0, bottom: 10),
              child: Text(
                'More products from this supplier',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: Get.height * 0.32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ui_23_item_list.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      // height: Get.height * 0.15,
                      color: Colors.white,
                      width: Get.width * 0.38,
                      child: Column(
                        children: [
                          Container(
                            height: Get.height * 0.15,
                            child: Image.asset(ui_23_item_list[index].imagePath.toString()),
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

            Padding(
              padding:
              EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
              child: Text(
                'Services Offered by this Supplier',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: Get.height * 0.32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Recently_item_List.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      // height: Get.height * 0.15,
                      color: Colors.white,
                      width: Get.width * 0.38,
                      child: Column(
                        children: [
                          Container(
                            height: Get.height * 0.15,
                            child: Image.asset(Recently_item_List[index].imagePath.toString()),
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
        ),
      ),
    );
  }
}

Widget image_select_widget(
    final item
    ) {
  return Container(
    child: Column(
      children: [
        Container(
          height: Get.height * 0.4,
          color: Colors.white,
          //  child: Image.asset(item.imagePath.toString()),
          child: CarouselSlider.builder(
            options: CarouselOptions(
              enableInfiniteScroll: true,
              aspectRatio: 2.0,
              viewportFraction: 1.0,
              scrollDirection: Axis.horizontal,
              // aspectRatio: 2,
            ),
            itemCount: item.length,
            itemBuilder: (context, index, realIndex) {
              var image = item[index];
              return Image.network(image['url'].toString(),fit: BoxFit.cover,);
            },
          ),
        ),
        Container(
          height: Get.height * 0.15,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: item.length,
            itemBuilder: (context, index) {
              var image = item[index];
              return Container(
                margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                height: Get.height * 0.2,
                color: Colors.white,
                width: Get.width * 0.2,
                child: Center(
                    child: Image.network(image['url'].toString())
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget product_review_widget(item) {
  return Container(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '${item['name']}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'XAF ${item['unit_price']}',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: appcolor().mediumGreyColor),
      ),
      Row(
        children: [
          RatingBar.builder(
            itemCount: 5,
            direction: Axis.horizontal,
            initialRating: 1,
            itemSize: 22,
            maxRating: 5,
            allowHalfRating: true,
            glow: true,
            itemBuilder: (context, _) {
              return Icon(
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
            '${item['reviews']} Supplier Reviews',
            style: TextStyle(color: appcolor().mediumGreyColor, fontSize: 12),
          ),
        ],
      ),
    ]),
  );
}