import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/APi/business.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/featured_buiseness/view/featured_list_item.dart';
import 'package:errandia/app/modules/buiseness/view/businesses_view_with_bar.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/errands/controller/search_errand_prod_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/products/controller/manage_products_controller.dart';
import 'package:errandia/app/modules/global/Widgets/filter_product_view.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:errandia/app/modules/services/view/service_details_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../../../common/random_ui/ui_23.dart';
import '../../global/Widgets/blockButton.dart';

import '../../global/constants/color.dart';
import '../../products/view/product_view.dart';

class search_errand_prod extends StatefulWidget {
  final String searchTerm;

  const search_errand_prod({super.key, required this.searchTerm});

  @override
  State<search_errand_prod> createState() => search_errand_prodState();
}

class search_errand_prodState extends State<search_errand_prod>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  manage_product_tabController pcontroller =
      Get.put(manage_product_tabController());
  manage_product_controller manageProductController =
  Get.put(manage_product_controller());
  late SearchErrandProdController searchProdController;


  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  late String _localSearchTerm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localSearchTerm = widget.searchTerm;
    searchProdController = Get.put(SearchErrandProdController());

    print("search term: $_localSearchTerm");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // manageProductController.loadAllProducts(_localSearchTerm);
      searchProdController.searchItem(_localSearchTerm);

      print("product List: ${searchProdController.productsList}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            endDrawer: Drawer(
              width: Get.width * 0.7,
              child: SafeArea(
                child: Column(
                  children: [
                    blockButton(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          hintText: 'Search Product',
                        ),
                      ),
                      ontap: () {},
                      color: Colors.white,
                    ).paddingOnly(
                      bottom: 20,
                    ),
                    blockButton(
                      title: const Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                      ontap: () {},
                      color: appcolor().mainColor,
                    )
                  ],
                ).paddingSymmetric(horizontal: 10, vertical: 50),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 2,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  // size: 30,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              automaticallyImplyLeading: false,
              title: const Text(
                'Hair Products',
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
              ),
              iconTheme: IconThemeData(
                color: appcolor().mediumGreyColor,
                size: 30,
              ),
              // filter icon buttons
              actions: [
                ///

                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.filter,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    Get.to(filter_product_view());
                  },
                ),

                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.arrowDownWideShort,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    Get.bottomSheet(
                      Container(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            Text(
                              'Sort List',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: appcolor().mainColor,
                              ),
                            ),
                            // z-a
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text: 'Product Name : ',
                                        style: TextStyle(
                                          color: appcolor().mainColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Desc Z-A',
                                        style: TextStyle(
                                          color: appcolor().mediumGreyColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Obx(
                                      () => Radio(
                                    value: 'sort descending',
                                    groupValue: manageProductController
                                        .allProducts_sort_group_value.value,
                                    onChanged: (val) {
                                      manageProductController
                                          .allProducts_sort_group_value
                                          .value = val.toString();
                                    },
                                  ),
                                )
                              ],
                            ),

                            // a-z
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text: 'Product Name : ',
                                        style: TextStyle(
                                          color: appcolor().mainColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Asc A-Z',
                                        style: TextStyle(
                                          color: appcolor().mediumGreyColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Obx(() => Radio(
                                  value: 'sort ascending',
                                  groupValue: manageProductController
                                      .allProducts_sort_group_value.value,
                                  onChanged: (val) {
                                    manageProductController
                                        .allProducts_sort_group_value
                                        .value = val.toString();
                                  },
                                ))
                              ],
                            ),

                            // distance nearest to me
                            Row(
                              children: [
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(fontSize: 16),
                                        children: [
                                          TextSpan(
                                            text: 'Date',
                                            style: TextStyle(
                                              color: appcolor().mainColor,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Last Modified',
                                          ),
                                        ])),
                                Spacer(),
                                Obx(() => Radio(
                                  value: 'Date Last modified ',
                                  groupValue: manageProductController
                                      .allProducts_sort_group_value.value,
                                  onChanged: (val) {
                                    manageProductController
                                        .allProducts_sort_group_value
                                        .value = val.toString();
                                  },
                                ))
                              ],
                            ),

                            //recentaly added
                            Row(
                              children: [
                                Text(
                                  'Price',
                                  style: TextStyle(
                                      color: appcolor().mainColor, fontSize: 16),
                                ),
                                Icon(
                                  Icons.arrow_upward,
                                  size: 25,
                                  color: appcolor().mediumGreyColor,
                                ),
                                Spacer(),
                                Obx(
                                      () => Radio(
                                    value: 'Price',
                                    groupValue: manageProductController
                                        .allProducts_sort_group_value.value,
                                    onChanged: (val) {
                                      manageProductController
                                          .allProducts_sort_group_value
                                          .value = val.toString();
                                      print(val.toString());
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ).paddingSymmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Scaffold.of(scaffoldKey.currentContext!).openEndDrawer();
                  },
                ),

                ///
              ],
            ),
            body: SafeArea(
              child: Builder(
                builder: (ctx) => Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: appcolor().greyColor,
                          ),
                        ),
                      ),
                      height: Get.height * 0.08,
                      child: TabBar(
                        dividerColor: appcolor().bluetextcolor,
                        isScrollable: true,
                        unselectedLabelColor: appcolor().mediumGreyColor,
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        indicatorColor: appcolor().mainColor,
                        labelColor: appcolor().bluetextcolor,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appcolor().mainColor,
                          fontSize: 18,
                        ),
                        controller: pcontroller.tabController,
                        tabs: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Text('All'),
                          ),
                          SizedBox(
                            width: Get.width * 0.26,
                            child: const Text('Products'),
                          ),
                          const Text('Services'),
                        ],
                      ),
                    ),
                    // a text saying Errandia Suggest the following businesses that might have your product
                    // Container(
                    //   margin: EdgeInsets.only(
                    //     top: Get.height * 0.01,
                    //     left: Get.width * 0.03,
                    //   ),
                    //   child: Expanded(
                    //     child: Text(
                    //       'Errandia Suggest the following businesses that might have your product',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //         color: appcolor().mediumGreyColor,
                    //         fontSize: 12,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: TabBarView(
                          controller: pcontroller.tabController,
                          children: [
                            allProducts(ctx),
                            Published(ctx),
                            Drafts(ctx),
                          ]),
                    ),
                  ],
                ),
              ),
            )),


      ],
    );
  }
}

Widget allProducts(BuildContext ctx) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(
          height: Get.height * 0.01,
        ),
        Container(
          child: Row(
            children: [
              Text(
                '6 Suggested Products',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: appcolor().mainColor,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // screen for the list of all products
                  // Get.to(() => SeeAllErands());
                },
                child: const Text('See All'),
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          height: Get.height * 0.45,
          child: ListView.builder(
              itemCount: ui_23_item_list.length - 3,
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => Product_view(
                          item: Recently_item_List[0],
                        ));
                  },
                  child: Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: [
                        Card(
                          shadowColor: Colors.transparent,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            height: Get.height * 0.365,
                            // color: Colors.blue,
                            width: Get.width * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      ui_23_item_list[index].imagePath,
                                    ),
                                    height: Get.height * 0.12,
                                  ),
                                ),

                                SizedBox(
                                  height: Get.height * 0.01,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: appcolor().mediumGreyColor,
                                      size: 15,
                                    ),
                                    Text(
                                      ui_23_item_list[index]
                                          .location
                                          .toString(),
                                      style: TextStyle(
                                          color: appcolor().mediumGreyColor,
                                          fontSize: 12),
                                    )
                                  ],
                                ).paddingOnly(
                                  left: 3,
                                  right: 3,
                                ),

                                Text(
                                  ui_23_item_list[index].itemname,
                                  style: TextStyle(
                                      color: appcolor().mainColor,
                                      fontSize: 14),
                                ).paddingOnly(
                                  left: 5,
                                  right: 5,
                                ),

                                Row(
                                  children: [
                                    Text(
                                      ui_23_item_list[index].itemPrice,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ).paddingOnly(
                                  left: 4,
                                  right: 4,
                                ),

                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                // contact shop button
                                SizedBox(
                                  width: Get.width * 0.4,
                                  // height: 50,
                                  child: blockButton(
                                    title: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                            // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
                                            'Contact Shop',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ontap: () {},
                                    color: appcolor().mainColor,
                                  ),
                                ).paddingOnly(
                                  left: 4,
                                  right: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        //  business name and icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              business_controller()
                                  .businessList[index]
                                  .imagepath,
                              height: 10,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              business_controller().businessList[index].name,
                              style: TextStyle(
                                fontSize: 12,
                                color: appcolor().mainColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        Container(
          child: Row(
            children: [
              Text(
                '5 Suggested Services',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: appcolor().mainColor,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // screen for the list of all services
                  // Get.to(() => SeeAllErands());
                },
                child: const Text('See All'),
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          height: Get.height * 0.45,
          child: ListView.builder(
              itemCount: profile_controller().service_list.length,
              primary: false,
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = profile_controller().service_list[index];

                return InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print("service item: ${item.name}");
                    }
                    Get.to(() => ServiceDetailsView(service: item));
                  },
                  child: Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: [
                        Card(
                          shadowColor: Colors.transparent,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            height: Get.height * 0.365,
                            // color: Colors.blue,
                            width: Get.width * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      profile_controller()
                                          .service_list[index]
                                          .imagePath
                                          .toString(),
                                    ),
                                    height: Get.height * 0.12,
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: appcolor().mediumGreyColor,
                                      size: 15,
                                    ),
                                    Text(
                                      ui_23_item_list[index]
                                          .location
                                          .toString(),
                                      style: TextStyle(
                                          color: appcolor().mediumGreyColor,
                                          fontSize: 12),
                                    )
                                  ],
                                ).paddingOnly(
                                  left: 3,
                                  right: 3,
                                ),

                                Text(
                                  ui_23_item_list[index].itemname,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: appcolor().mainColor),
                                ).paddingOnly(
                                  left: 5,
                                  right: 5,
                                ),

                                Row(
                                  children: [
                                    Text(
                                      ui_23_item_list[index].itemPrice,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ).paddingOnly(
                                  left: 4,
                                  right: 4,
                                ),

                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                // contact shop button
                                SizedBox(
                                  width: Get.width * 0.4,
                                  // height: 50,
                                  child: blockButton(
                                    title: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                            // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
                                            'Contact Shop',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ontap: () {},
                                    color: appcolor().mainColor,
                                  ),
                                ).paddingOnly(
                                  left: 4,
                                  right: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        //  business name and icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              business_controller()
                                  .businessList[index]
                                  .imagepath,
                              height: 10,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              business_controller().businessList[index].name,
                              style: TextStyle(
                                fontSize: 12,
                                color: appcolor().mainColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        // Container(
        //   child: Row(
        //     children: [
        //       Text(
        //         '4 Suggested Businesses',
        //         style: TextStyle(
        //           fontWeight: FontWeight.w700,
        //           fontSize: 20,
        //           color: appcolor().mainColor,
        //         ),
        //       ),
        //       const Spacer(),
        //       TextButton(
        //         onPressed: () {
        //           Get.to(() => BusinessesViewWithBar());
        //         },
        //         child: const Text('See All'),
        //       ),
        //     ],
        //   ).paddingSymmetric(horizontal: 20),
        // ),
        // FutureBuilder(
        //     future: BusinessAPI.businesses(1),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasError) {
        //         return Container(
        //           height: Get.height * 0.17,
        //           color: Colors.white,
        //           child: const Center(
        //             child: Text('Featured Businesses not found'),
        //           ),
        //         );
        //       } else if (snapshot.hasData) {
        //         return Container(
        //           padding: const EdgeInsets.symmetric(horizontal: 10),
        //           height: Get.height * 0.4,
        //           child: ListView.builder(
        //             primary: false,
        //             shrinkWrap: false,
        //             scrollDirection: Axis.horizontal,
        //             itemCount: 4,
        //             itemBuilder: (context, index) {
        //               var data = snapshot.data[index];
        //               return InkWell(
        //                 onTap: () {
        //                   Get.to(errandia_business_view(
        //                     businessData: data,));
        //                 },
        //                 child: Card(
        //                   shadowColor: Colors.transparent,
        //                   child: Container(
        //                     margin: const EdgeInsets.symmetric(horizontal: 6),
        //                     width: Get.width * 0.4,
        //                     height: Get.height * 0.43,
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Padding(
        //                           padding: const EdgeInsets.all(8.0),
        //                           child: Center(
        //                               child: Image.network(
        //                             getImagePath(data.imagepath.toString()
        //                               ),
        //                             fit: BoxFit.fill,
        //                             height: Get.height * 0.15,
        //                           )),
        //                         ),
        //                         SizedBox(
        //                           height: Get.height * 0.009,
        //                         ),
        //                         Text(
        //                           Featured_Businesses_Item_List[index]
        //                               .servicetype
        //                               .toString(),
        //                           style: TextStyle(
        //                               fontSize: 11,
        //                               // fontWeight: FontWeight.bold,
        //                               color: appcolor().mediumGreyColor),
        //                         ).paddingOnly(
        //                           left: 5,
        //                           right: 5,
        //                         ),
        //
        //                         SizedBox(
        //                           height: Get.height * 0.001,
        //                         ),
        //
        //                         Text(
        //                           data.name.toString(),
        //                           style: TextStyle(
        //                               fontSize: 15,
        //                               fontWeight: FontWeight.bold,
        //                               color: appcolor().mainColor),
        //                         ).paddingOnly(
        //                           left: 5,
        //                           right: 5,
        //                         ),
        //
        //                         SizedBox(
        //                           height: Get.height * 0.002,
        //                         ),
        //
        //                         Row(
        //                           mainAxisAlignment: MainAxisAlignment.start,
        //                           children: [
        //                             Icon(
        //                               Icons.location_on,
        //                               color: appcolor().mediumGreyColor,
        //                               size: 15,
        //                             ),
        //                             Text(
        //                               ui_23_item_list[index]
        //                                   .location
        //                                   .toString(),
        //                               style: TextStyle(
        //                                   color: appcolor().mediumGreyColor,
        //                                   fontSize: 13),
        //                             )
        //                           ],
        //                         ).paddingOnly(
        //                           left: 3,
        //                           right: 3,
        //                         ),
        //
        //                         SizedBox(
        //                           height: Get.height * 0.02,
        //                         ),
        //
        //                         // contact shop button
        //                         SizedBox(
        //                           width: Get.width * 0.43,
        //                           // height: 50,
        //                           child: blockButton(
        //                             title: const Padding(
        //                               padding: EdgeInsets.all(4.0),
        //                               child: Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.center,
        //                                 children: [
        //                                   Icon(
        //                                     Icons.call,
        //                                     color: Colors.white,
        //                                     size: 15,
        //                                   ),
        //                                   SizedBox(
        //                                     width: 7,
        //                                   ),
        //                                   Text(
        //                                     // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
        //                                     'Contact Shop',
        //                                     style: TextStyle(
        //                                       fontSize: 11,
        //                                       color: Colors.white,
        //                                       fontWeight: FontWeight.w600,
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                             ontap: () {},
        //                             color: appcolor().mainColor,
        //                           ),
        //                         ).paddingOnly(
        //                           left: 4,
        //                           right: 4,
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //         );
        //       } else {
        //         return Container(
        //           height: Get.height * 0.17,
        //           color: Colors.white,
        //           child: const Center(
        //             child: CircularProgressIndicator(),
        //           ),
        //         );
        //       }
        //     }),
        // SizedBox(
        //   height: Get.height * 0.02,
        // ),
      ],
    ).paddingOnly(
      left: 2,
      right: 2,
      top: 10,
    ),
  );
}

Widget Published(BuildContext ctx) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   height: Get.height * 0.01,
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '6 Suggested Products',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: appcolor().mainColor,
            ),
          ),
        ),
        GridView.count(
          childAspectRatio: (1 / 1.55),
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(ui_23_item_list.length - 4, (index) {
            var item = profile_controller().product_list[index];
            print("item: $item");
            return InkWell(
              onTap: () {
                Get.to(Product_view(
                  item: Recently_item_List[0],
                ));
              },
              child: Card(
                shadowColor: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: Get.height * 0.43,
                  // color: Colors.blue,
                  width: Get.width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image(
                          image: AssetImage(
                            item.imagePath.toString(),
                          ),
                          height: Get.height * 0.12,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: appcolor().mediumGreyColor,
                            size: 15,
                          ),
                          Text(
                            ui_23_item_list[index].location.toString(),
                            style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 12),
                          )
                        ],
                      ).paddingOnly(
                        left: 7,
                        right: 7,
                      ),

                      Text(
                        ui_23_item_list[index].itemname,
                        style: TextStyle(
                            color: appcolor().mainColor, fontSize: 14),
                      ).paddingOnly(
                        left: 10,
                        right: 10,
                      ),

                      Row(
                        children: [
                          Text(
                            ui_23_item_list[index].itemPrice,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ).paddingOnly(
                        left: 7,
                        right: 7,
                      ),

                      SizedBox(
                        height: Get.height * 0.02,
                      ),

                      // contact shop button
                      SizedBox(
                        width: Get.width * 0.4,
                        // height: 50,
                        child: blockButton(
                          title: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
                                  'Contact Shop',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ontap: () {},
                          color: appcolor().mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),

        SizedBox(
          height: Get.height * 0.02,
        ),
      ],
    ).paddingOnly(
      left: 2,
      right: 2,
      top: 10,
    ),
  );
}

Widget Drafts(BuildContext ctx) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   height: Get.height * 0.01,
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '5 Suggested Services',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: appcolor().mainColor,
            ),
          ),
        ),
        GridView.count(
          childAspectRatio: (1 / 1.55),
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children:
              List.generate(profile_controller().service_list.length, (index) {
            var item = profile_controller().service_list[index];
            print("item: $item");
            return InkWell(
              onTap: () {
                Get.to(Product_view(
                  item: Recently_item_List[0],
                ));
              },
              child: Card(
                shadowColor: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: Get.height * 0.43,
                  // color: Colors.blue,
                  width: Get.width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image(
                          image: AssetImage(
                            item.imagePath.toString(),
                          ),
                          height: Get.height * 0.12,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: appcolor().mediumGreyColor,
                            size: 15,
                          ),
                          Text(
                            ui_23_item_list[index].location.toString(),
                            style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 12),
                          )
                        ],
                      ).paddingOnly(
                        left: 7,
                        right: 7,
                      ),

                      SizedBox(
                        height: Get.height * 0.003,
                      ),

                      Row(
                        children: [
                          Text(
                            item.name.toString(),
                            style: TextStyle(
                                color: appcolor().mainColor, fontSize: 14),
                          ).paddingOnly(
                            left: 10,
                            right: 10,
                          )
                        ],
                      ),

                      Row(
                        children: [
                          Text(
                            ui_23_item_list[index].itemPrice,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ).paddingOnly(
                        left: 7,
                        right: 7,
                      ),

                      SizedBox(
                        height: Get.height * 0.02,
                      ),

                      // contact shop button
                      SizedBox(
                        width: Get.width * 0.4,
                        // height: 50,
                        child: blockButton(
                          title: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  // 'Call ${widget.item?.shop ? widget.item['shop']['phone'] : '673580194'}',
                                  'Contact Shop',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ontap: () {},
                          color: appcolor().mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),

        SizedBox(
          height: Get.height * 0.02,
        ),
      ],
    ).paddingOnly(
      left: 2,
      right: 2,
      top: 10,
    ),
  );
}

Widget filter_sort_container(
  Callback filter_button,
  Callback sort_button,
  Callback search_button,
) {
  return Container(
    // width: Get.width*0.4,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: filter_button,
          child: Container(
            width: Get.width * 0.35,
            decoration: BoxDecoration(
                border: Border.all(color: appcolor().greyColor),
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Filter List',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Icon(
                  FontAwesomeIcons.arrowDownWideShort,
                  color: appcolor().mediumGreyColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: sort_button,
          child: Container(
            width: Get.width * 0.35,
            decoration: BoxDecoration(
                border: Border.all(color: appcolor().greyColor),
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Sort List ',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Icon(
                  FontAwesomeIcons.arrowDownWideShort,
                  color: appcolor().mediumGreyColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: search_button,
          child: Container(
            // width: Get.width*0.4,

            decoration: BoxDecoration(
              border: Border.all(color: appcolor().greyColor),
              borderRadius: BorderRadius.circular(
                10,
              ),
              color: appcolor().skyblueColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.search,
                  color: appcolor().mainColor,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget managebottomSheetWidgetitem({
  required String title,
  required IconData icondata,
  required Callback callback,
  Color? color,
}) {
  return InkWell(
    // highlightColor: Colors.grey,

    hoverColor: Colors.grey,
    // focusColor: Colors.grey,
    // splashColor: Colors.grey,
    // overlayColor: Colors.grey,
    onTap: callback,
    child: Row(
      children: [
        Container(
          height: 24,
          child: Icon(
            icondata,
            color: color == null ? Colors.black : color,
          ),
        ),
        SizedBox(
          width: 18,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color == null ? Colors.black : color,
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 15),
  );
}

Widget publish_draft_widget(bool publish, int index) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 2,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: publish == true
          ? const Color.fromARGB(255, 218, 246, 187)
          : appcolor().greyColor,
    ),
    child: Text(
      publish == true ? 'Publish' : 'Draft',
      style: TextStyle(
        fontSize: 12,
        color: publish == true ? Colors.green : Colors.grey,
      ),
    ),
  );
}
