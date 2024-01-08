import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/reviews/controller/review_controller.dart';
import 'package:errandia/app/modules/reviews/views/add_review.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Review_view extends StatelessWidget {
  review_controller _reviewcontroller = Get.put(review_controller());
  Review_view({super.key});
  double rating = 3.5;
  int review_count = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      appBar: AppBar(
        leadingWidth: 30,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Reviews',
          style: TextStyle(
            color: appcolor().mainColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(add_review_view());
            },
            child: Text(
              'Add Reviews',
              style: TextStyle(
                color: appcolor().mainColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: appcolor().mediumGreyColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //         padding: EdgeInsets.only(left: 40, right: 10),
      //         height: Get.height * 0.2,
      //         decoration: BoxDecoration(
      //           color: appcolor().skyblueColor,
      //           border: Border.symmetric(
      //             horizontal: BorderSide(
      //               color: appcolor().mediumGreyColor,
      //             ),
      //           ),
      //         ),
      //         child: Row(
      //           // crossAxisAlignment: CrossAxisAlignment.center,
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Text(
      //               rating.toString(),
      //               style: TextStyle(fontSize: 60),
      //             ),
      //             SizedBox(
      //               width: Get.width * 0.05,
      //             ),
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   'Average Rating',
      //                   style: TextStyle(
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   height: Get.height * 0.001,
      //                 ),
      //                 RatingBar.builder(
      //                   allowHalfRating: true,
      //                   itemCount: 5,
      //                   updateOnDrag: false,
      //                   initialRating: rating,
      //                   itemSize: 25,
      //                   itemBuilder: (context, index) {
      //                     return Icon(
      //                       Icons.star,
      //                       color: Colors.amber,
      //                       size: 20,
      //                     );
      //                   },
      //                   ignoreGestures: true,
      //                   onRatingUpdate: (value) {
      //                     debugPrint(value.toString());
      //                   },
      //                 ),
      //                 SizedBox(
      //                   height: Get.height * 0.004,
      //                 ),
      //                 Text(
      //                   review_count.toString() + ' Reviews',
      //                   style: TextStyle(
      //                       fontSize: 12,
      //                       fontWeight: FontWeight.bold,
      //                       color: appcolor().blueColor),
      //                 ),
      //               ],
      //             )
      //           ],
      //         ),
      //       ),
      //       Container(
      //         decoration: BoxDecoration(),
      //         margin: EdgeInsets.symmetric(vertical: 10),
      //         height: Get.height * 0.1,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             // filter list
      //             Container(
      //               padding: EdgeInsets.symmetric(horizontal: 15),
      //               height: Get.height * 0.08,
      //               width: Get.width * 0.4,
      //               decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.circular(5)),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Text(
      //                     'Filter List',
      //                     style: TextStyle(fontSize: 15),
      //                   ),
      //                   Icon(FontAwesomeIcons.arrowDownShortWide)
      //                 ],
      //               ),
      //             ),
      //             Container(
      //               padding: EdgeInsets.symmetric(horizontal: 15),
      //               height: Get.height * 0.08,
      //               width: Get.width * 0.4,
      //               decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.circular(5)),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Text(
      //                     'Sort List',
      //                     style: TextStyle(fontSize: 15),
      //                   ),
      //                   Icon(FontAwesomeIcons.arrowDownShortWide)
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 244, 244, 244),
            expandedHeight: Get.height * 0.33,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 40, right: 10),
                    height: Get.height * 0.2,
                    decoration: BoxDecoration(
                      color: appcolor().skyblueColor,
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: appcolor().mediumGreyColor,
                        ),
                      ),
                    ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          rating.toString(),
                          style: TextStyle(fontSize: 60),
                        ),
                        SizedBox(
                          width: Get.width * 0.05,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Average Rating',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.001,
                            ),
                            RatingBar.builder(
                              allowHalfRating: true,
                              itemCount: 5,
                              updateOnDrag: false,
                              initialRating: rating,
                              itemSize: 25,
                              itemBuilder: (context, index) {
                                return Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              },
                              ignoreGestures: true,
                              onRatingUpdate: (value) {
                                debugPrint(value.toString());
                              },
                            ),
                            SizedBox(
                              height: Get.height * 0.004,
                            ),
                            Text(
                              review_count.toString() + ' Reviews',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: appcolor().blueColor),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: Get.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // filter list
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: Get.height * 0.08,
                          width: Get.width * 0.4,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Filter List',
                                style: TextStyle(fontSize: 15),
                              ),
                              Icon(FontAwesomeIcons.arrowDownShortWide)
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: Get.height * 0.08,
                          width: Get.width * 0.4,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sort List',
                                style: TextStyle(fontSize: 15),
                              ),
                              Icon(FontAwesomeIcons.arrowDownShortWide)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
          SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                // height: Get.height*0.3,
                padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: Get.height * 0.07,
                          width: Get.width * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: Image(
                            image: AssetImage('assets/images/person_avatar.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(width: Get.width * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kory Swaniawski',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '30 Apr 2023',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Spacer(),
                        RatingBar.builder(
                          minRating: 1,
                          initialRating: 3,
                          ignoreGestures: true,
                          // tapOnlyMode: true,
                          updateOnDrag: false,
                          itemSize: 18,
                          itemBuilder: (context, index) {
                            return Icon(
                              Icons.star,
                              color: Colors.amber,
                            );
                          },
                          onRatingUpdate: (value) {},
                        )
                      ],
                    ),
                    Container(
                      height: Get.height * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            // padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            margin: EdgeInsets.only(
                              right: 10,
                              top: 10,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // border: Border.all(color: appcolor().mediumGreyColor),
                                borderRadius: BorderRadius.circular(8)),
                            height: Get.height * 0.1,

                            width: Get.width * 0.3,
                            child: Image(
                              image: AssetImage(
                                'assets/images/ui_23_item.png',
                              ),
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      child: Text(
                        'Praesentium quo impedit eaque ut. Aperiam qui illum. Porro quis autem dolorum saepe dolor ipsa ut. ',
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
