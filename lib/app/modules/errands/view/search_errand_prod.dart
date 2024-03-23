import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/APi/business.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/featured_buiseness/view/featured_list_item.dart';
import 'package:errandia/app/modules/buiseness/view/businesses_view_with_bar.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/errands/controller/search_errand_prod_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/Widgets/search_item_widget.dart';
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

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
  late ScrollController _scrollController;
  late ScrollController _scrollController2;
  late ScrollController _scrollController3;


  late String _localSearchTerm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localSearchTerm = widget.searchTerm;
    searchProdController = Get.put(SearchErrandProdController());
    _scrollController = ScrollController();
    _scrollController2 = ScrollController();
    _scrollController3 = ScrollController();

    print("search term: $_localSearchTerm");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // manageProductController.loadAllProducts(_localSearchTerm);
      searchProdController.searchItem(_localSearchTerm);
      searchProdController.searchItemProducts(_localSearchTerm);
      searchProdController.searchItemServices(_localSearchTerm);
      print("product List: ${searchProdController.productsList}");
      searchProdController.drawerSearchCtl.text = _localSearchTerm;
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // manageProductController.loadAllProducts(_localSearchTerm);
        searchProdController.searchItem(_localSearchTerm);
      }
    });

    _scrollController2.addListener(() {
      if (_scrollController2.position.pixels ==
          _scrollController2.position.maxScrollExtent) {
        // manageProductController.loadAllProducts(_localSearchTerm);
        searchProdController.searchItemProducts(_localSearchTerm);
      }
    });

    _scrollController3.addListener(() {
      if (_scrollController3.position.pixels ==
          _scrollController3.position.maxScrollExtent) {
        // manageProductController.loadAllProducts(_localSearchTerm);
        searchProdController.searchItemServices(_localSearchTerm);
      }
    });
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("App State: $state");
    if (state == AppLifecycleState.resumed) {
      // manageProductController.loadAllProducts(_localSearchTerm);
      // searchProdController.searchItem(_localSearchTerm);
      searchProdController.reloadAll();
      searchProdController.reloadProducts();
      searchProdController.reloadServices();
    }
  }

  String _formatAddress(Map<String, dynamic> shop) {
    String street = shop['street'] ?? '';
    // String townName = shop['town'] != null ? shop['town']['name'] : '';
    String regionName = shop['region'] != null ? shop['region']['name'].split(' -')[0] : '';

    return capitalizeAll([street, regionName]
        .where((s) => s.isNotEmpty)
        .join(", ")
        .trim());
  }

  @override
  Widget build(BuildContext context) {

    Widget all(BuildContext ctx) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
                () {
                  if (searchProdController.isLoading.isTrue) {
                    return SizedBox(
                      height: Get.height * 0.68,
                      child: buildLoadingWidget(),
                    );
                  } else if (searchProdController.isSearchError.isTrue) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      height: Get.height * 0.68,
                      child: buildErrorWidget(
                        message: 'There was an error loading products, please try again later',
                        callback: () {
                          searchProdController.reloadAll();
                        },
                      ),
                    );
                  } else if (searchProdController.itemList.isEmpty) {
                    return SizedBox(
                      height: Get.height * 0.68,
                      child: Center(
                        child: Text(
                          'No items found',
                          style: TextStyle(
                            color: appcolor().mediumGreyColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GridView.builder(
                        key: UniqueKey(),
                        controller: _scrollController,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.74,
                          crossAxisSpacing: 1 / 2.66,
                          mainAxisSpacing: 1 / 1.88,
                        ),
                        itemCount: searchProdController.itemList.length,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var item = searchProdController.itemList[index];
                          print("item: $item");
                          return InkWell(
                            onTap: () {
                              if (item['is_service'] == 1) {
                                Get.to(() => ServiceDetailsView(service: item));
                              } else {
                                Get.to(() => Product_view(
                                  item: item,
                                ));
                              }
                            },
                            child: SearchItemWidget(
                              item: item, key: UniqueKey(),
                            ),
                          );
                        });
                  }
                }
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

    Widget Products(BuildContext ctx) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: Obx(
            //           () {
            //         if (searchProdController.isLoading.isTrue) {
            //           return Text(
            //             'Loading...',
            //             style: TextStyle(
            //               fontWeight: FontWeight.w500,
            //               fontSize: 20,
            //               color: appcolor().mainColor,
            //             ),
            //           );
            //         } else if (searchProdController.isSearchError.isTrue) {
            //           return Container();
            //         } else if (searchProdController.productsList.isEmpty) {
            //           return Container();
            //         } else {
            //           return Text(
            //             '${searchProdController.productsList.length} Suggested Product${searchProdController.productsList.length > 1 ? 's' : ''}',
            //             style: TextStyle(
            //               fontWeight: FontWeight.w700,
            //               fontSize: 20,
            //               color: appcolor().mainColor,
            //             ),
            //           );
            //         }
            //       }
            //   ),
            // ),

            Obx(
                () {
                  if (searchProdController.isProductLoading.isTrue) {
                    return SizedBox(
                      height: Get.height * 0.68,
                      child: buildLoadingWidget(),
                    );
                  } else if (searchProdController.isProductSearchError.isTrue) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      height: Get.height * 0.68,
                      child: buildErrorWidget(
                        message: 'There was an error loading products, please try again later',
                        callback: () {
                          searchProdController.reloadProducts();
                        },
                      ),
                    );
                  } else if (searchProdController.productItemList.isEmpty) {
                    return SizedBox(
                      height: Get.height * 0.68,
                      child: Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(
                            color: appcolor().mediumGreyColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      key: UniqueKey(),
                      controller: _scrollController2,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.64,
                        crossAxisSpacing: 1 / 2.66,
                        mainAxisSpacing: 1 / 1.88,
                      ),
                      itemCount: searchProdController.productItemList.length,
                      primary: false,
                        scrollDirection: Axis.vertical,

                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = searchProdController.productItemList[index];
                        print("item: $item");
                        return InkWell(
                          onTap: () {
                            Get.to(() => Product_view(
                              item: item,
                            ));
                          },
                          child: SearchItemWidget(
                            item: item, key: UniqueKey(), showShop: false,
                          ),
                        );
                      });
                  }
                }
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

    Widget Services(BuildContext ctx) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: Get.height * 0.01,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: Obx(
            //       () {
            //         if (searchProdController.isLoading.isTrue) {
            //           return Text(
            //             'Loading...',
            //             style: TextStyle(
            //               fontWeight: FontWeight.w500,
            //               fontSize: 20,
            //               color: appcolor().mainColor,
            //             ),
            //           );
            //         } else if (searchProdController.isSearchError.isTrue) {
            //           return Container();
            //         } else if (searchProdController.servicesList.isEmpty) {
            //           return Container();
            //         } else {
            //           return Text(
            //             '${searchProdController.servicesList.length} Suggested Service${searchProdController.servicesList.length > 1 ? 's' : ''}',
            //             style: TextStyle(
            //               fontWeight: FontWeight.w700,
            //               fontSize: 20,
            //               color: appcolor().mainColor,
            //             ),
            //           );
            //         }
            //       }
            //   )
            // ),

            Obx(
                () {
                  if (searchProdController.isServiceLoading.isTrue) {
                    return SizedBox(
                      height: Get.height * 0.68,
                      child: buildLoadingWidget(),
                    );
                  } else if (searchProdController.isServiceSearchError.isTrue) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      height: Get.height * 0.68,
                      child: buildErrorWidget(
                        message: 'There was an error loading services, please try again later',
                        callback: () {
                          searchProdController.reloadServices();
                        },
                      ),
                    );
                  } else if (searchProdController.serviceItemList.isEmpty) {
                    return SizedBox(
                      height: Get.height * 0.68,
                      child: Center(
                        child: Text(
                          'No services found',
                          style: TextStyle(
                            color: appcolor().mediumGreyColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      key: UniqueKey(),
                      controller: _scrollController3,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.64,
                        crossAxisSpacing: 1 / 2.66,
                        mainAxisSpacing: 1 / 1.88,
                      ),
                      itemCount: searchProdController.serviceItemList.length,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = searchProdController.serviceItemList[index];

                        return InkWell(
                          onTap: () {
                            if (kDebugMode) {
                              print("service item: $item");
                            }
                            Get.to(() => ServiceDetailsView(service: item));
                          },
                          child: SearchItemWidget(
                            item: item, key: UniqueKey(), showShop: false,
                          ),
                        );
                      });
                  }
                }
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

      return Stack(
        children: [
          Scaffold(
            key: scaffoldKey,
              endDrawer: Drawer(
                width: Get.width * 0.7,
                child: SafeArea(
                  child: Column(
                    children: [
                      blockButton(
                        title: TextFormField(
                          controller: searchProdController.drawerSearchCtl,
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
                        ontap: () {
                          setState(() {
                            _localSearchTerm = searchProdController.drawerSearchCtl.text;
                          });
                          searchProdController.resetFilters();
                          searchProdController.itemList.clear();
                          searchProdController.productsList.clear();
                          searchProdController.servicesList.clear();
                          searchProdController.currentPage.value = 1;
                          searchProdController.total.value = 0;
                          searchProdController.searchItem(_localSearchTerm);
                          Get.back();
                        },
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
                title: Text(
                  capitalizeAll(_localSearchTerm),
                  style:
                  const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal
                  ),
                ),
                iconTheme: IconThemeData(
                  color: appcolor().mediumGreyColor,
                  size: 30,
                ),
                // filter icon buttons
                actions: [
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.filter,
                      size: 20,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      Get.to(() => filter_product_view())?.then((value) {
                        if (value != null) {
                          print("Filter Value: $value");
                          // searchProdController.filterItem(value);
                          pcontroller.tabController.animateTo(0);
                        }
                      });
                    },
                  ),

                  // IconButton(
                  //   icon: const Icon(
                  //     FontAwesomeIcons.arrowDownWideShort,
                  //     size: 20,
                  //     color: Colors.blueGrey,
                  //   ),
                  //   onPressed: () {
                  //     Get.bottomSheet(
                  //       Container(
                  //         color: const Color.fromRGBO(255, 255, 255, 1),
                  //         child: Wrap(
                  //           crossAxisAlignment: WrapCrossAlignment.start,
                  //           children: [
                  //             Text(
                  //               'Sort List',
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 22,
                  //                 color: appcolor().mainColor,
                  //               ),
                  //             ),
                  //             // z-a
                  //             Row(
                  //               children: [
                  //                 RichText(
                  //                   text: TextSpan(
                  //                     style: TextStyle(fontSize: 16),
                  //                     children: [
                  //                       TextSpan(
                  //                         text: 'Product Name : ',
                  //                         style: TextStyle(
                  //                           color: appcolor().mainColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: 'Desc Z-A',
                  //                         style: TextStyle(
                  //                           color: appcolor().mediumGreyColor,
                  //                         ),
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Spacer(),
                  //                 Obx(
                  //                       () => Radio(
                  //                     value: 'sort descending',
                  //                     groupValue: manageProductController
                  //                         .allProducts_sort_group_value.value,
                  //                     onChanged: (val) {
                  //                       manageProductController
                  //                           .allProducts_sort_group_value
                  //                           .value = val.toString();
                  //                     },
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //
                  //             // a-z
                  //             Row(
                  //               children: [
                  //                 RichText(
                  //                   text: TextSpan(
                  //                     style: TextStyle(fontSize: 16),
                  //                     children: [
                  //                       TextSpan(
                  //                         text: 'Product Name : ',
                  //                         style: TextStyle(
                  //                           color: appcolor().mainColor,
                  //                         ),
                  //                       ),
                  //                       TextSpan(
                  //                         text: 'Asc A-Z',
                  //                         style: TextStyle(
                  //                           color: appcolor().mediumGreyColor,
                  //                         ),
                  //                       )
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Spacer(),
                  //                 Obx(() => Radio(
                  //                   value: 'sort ascending',
                  //                   groupValue: manageProductController
                  //                       .allProducts_sort_group_value.value,
                  //                   onChanged: (val) {
                  //                     manageProductController
                  //                         .allProducts_sort_group_value
                  //                         .value = val.toString();
                  //                   },
                  //                 ))
                  //               ],
                  //             ),
                  //
                  //             // distance nearest to me
                  //             Row(
                  //               children: [
                  //                 RichText(
                  //                     text: TextSpan(
                  //                         style: TextStyle(fontSize: 16),
                  //                         children: [
                  //                           TextSpan(
                  //                             text: 'Date',
                  //                             style: TextStyle(
                  //                               color: appcolor().mainColor,
                  //                             ),
                  //                           ),
                  //                           TextSpan(
                  //                             text: 'Last Modified',
                  //                           ),
                  //                         ])),
                  //                 Spacer(),
                  //                 Obx(() => Radio(
                  //                   value: 'Date Last modified ',
                  //                   groupValue: manageProductController
                  //                       .allProducts_sort_group_value.value,
                  //                   onChanged: (val) {
                  //                     manageProductController
                  //                         .allProducts_sort_group_value
                  //                         .value = val.toString();
                  //                   },
                  //                 ))
                  //               ],
                  //             ),
                  //
                  //             //recentaly added
                  //             Row(
                  //               children: [
                  //                 Text(
                  //                   'Price',
                  //                   style: TextStyle(
                  //                       color: appcolor().mainColor, fontSize: 16),
                  //                 ),
                  //                 Icon(
                  //                   Icons.arrow_upward,
                  //                   size: 25,
                  //                   color: appcolor().mediumGreyColor,
                  //                 ),
                  //                 Spacer(),
                  //                 Obx(
                  //                       () => Radio(
                  //                     value: 'Price',
                  //                     groupValue: manageProductController
                  //                         .allProducts_sort_group_value.value,
                  //                     onChanged: (val) {
                  //                       manageProductController
                  //                           .allProducts_sort_group_value
                  //                           .value = val.toString();
                  //                       print(val.toString());
                  //                     },
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //           ],
                  //         ).paddingSymmetric(
                  //           horizontal: 20,
                  //           vertical: 10,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),

                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      scaffoldKey.currentState!.openEndDrawer();
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
                              all(ctx),
                              Products(ctx),
                              Services(ctx),
                            ]),
                      ),
                    ],
                  ),
                ),
              )
          ),


        ],
      );
  }
}

Widget filter_sort_container(
  Callback filterButton,
  Callback sortButton,
  Callback searchButton,
) {
  return Container(
    // width: Get.width*0.4,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: filterButton,
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
          onTap: sortButton,
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
          onTap: searchButton,
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
