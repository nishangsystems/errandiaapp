import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/app/modules/profile/view/profile_view.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../APi/apidomain & api.dart';

class SeeAllErrands extends StatefulWidget {
  const SeeAllErrands({super.key});

  @override
  State<SeeAllErrands> createState() => _SeeAllErrandsState();
}

class _SeeAllErrandsState extends State<SeeAllErrands> {
  @override
  Widget build(BuildContext context) {
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
            body: FutureBuilder(
              future: api().getProduct('products', 1),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('No Data Found'),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    primary: false,
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            // backgroundImage: NetworkImage(
                                            //   data['shop']['image'].toString(),
                                            // ),
                                            child: data['shop']['image'] == ""
                                                ? const Icon(Icons.person)
                                                : null,
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
                                                Recently_item_List[index].name.toString(),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                Recently_item_List[index].date.toString(),
                                                style: const TextStyle(fontSize: 12),
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
                                      child: Image(
                                        image: AssetImage(
                                          Recently_item_List[index].imagePath,
                                        ),
                                        height: Get.height * 0.22,
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
                                          Recently_item_List[index].belowText.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: appcolor().mainColor),
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.003,
                                        ),
                                        Row(
                                          children: [
                                             Icon(Icons.location_on,
                                                color: appcolor().mediumGreyColor, size: 15),
                                            const SizedBox(
                                              width: 4,
                                            ),
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
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )));
  }
}
