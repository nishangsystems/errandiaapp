import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SeeAllErrands extends StatefulWidget {
  const SeeAllErrands({super.key});

  @override
  State<SeeAllErrands> createState() => _SeeAllErrandsState();
}

class _SeeAllErrandsState extends State<SeeAllErrands>
    with WidgetsBindingObserver {
  late ScrollController scrollController;
  late errand_controller errandController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      errandController.fetchErrands();
    });

    errandController = Get.put(errand_controller());

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 20) {
        errandController.fetchErrands();
      }
    });
  }

  String _formatAddress(Map<String, dynamic> item) {
    print("item: $item");
    // String street = item['street'].toString() != '[]' && '';
    String townName = item['town'].toString() != '[]' ? item['town']['name'] : '';
    String regionName = item['region'].toString() != '[]' ? item['region']['name'].split(" -")[0] : '';

    return [townName, regionName].where((s) => s.isNotEmpty).join(", ").trim();
  }

  @override
  void dispose() {
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      errandController.reloadErrands();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildRPIErrorWidget(String message, VoidCallback onReload) {
      return !errandController.isErrandLoading.value
          ? Container(
              height: Get.height * 0.9,
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
              // actions: [
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.notifications,
                //     size: 30,
                //   ),
                //   color: appcolor().mediumGreyColor,
                // )
              // ],
            ),
            body:
                // SingleChildScrollView(
                //             child:
                Container(
                    height: Get.height * 0.9,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        errandController.reloadErrands();
                      },
                      child: Obx(() {
                        if (errandController.isErrandError.value) {
                          return _buildRPIErrorWidget(
                              'Failed to load recently posted items',
                              errandController.reloadErrands);
                        } else if (errandController.isErrandLoading.value) {
                          return buildLoadingWidget();
                        } else if (errandController.errandList.isEmpty) {
                          return buildErrorWidget(
                              message: 'No recent errands found',
                              actionText: 'Reload',
                              callback: errandController.reloadErrands
                          );
                        } else {
                          return ListView.builder(
                            key: const PageStorageKey('recentlyPostedItemsList'),
                            controller: scrollController,
                            primary: false,
                            shrinkWrap: false,
                            scrollDirection: Axis.vertical,
                            itemCount: errandController.errandList.length,
                            itemBuilder: (context, index) {
                              var data = errandController.errandList[index];
                              print("errands data: $data");
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    backgroundColor: appcolor().mainColor,
                                                    backgroundImage: data['user']['photo'] == ""
                                                        ? const AssetImage('assets/images/errandia_logo.png') // Fallback image
                                                        : NetworkImage(getImagePath(data['user']['photo'].toString())) as ImageProvider,
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
                                                      SizedBox(
                                                        width: Get.width * 0.4,
                                                        child: Text(
                                                          capitalizeAll(
                                                              data['user']['name']),
                                                          style: const TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                              FontWeight.bold),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
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
                                              child:  data['images'].length > 0
                                                  ? FadeInImage.assetNetwork(
                                                placeholder:
                                                'assets/images/errandia_logo.png',
                                                image: getImagePathWithSize(
                                                    data['images'][0]['image_path']
                                                        .toString(), width: 550, height: 350),
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
                                                SizedBox(
                                                  width: Get.width * 0.5,
                                                  child: Text(
                                                    capitalizeAll(data['title'].toString()),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color:
                                                        appcolor().mainColor),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                ),
                                                SizedBox(
                                                  height: Get.height * 0.003,
                                                ),
                                                data['region'].toString() != '[]' ||
                                                    data['town'].toString() != '[]'
                                                    ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 13,
                                                      color: appcolor()
                                                          .mediumGreyColor,
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.35,
                                                      child: Text(
                                                        _formatAddress(data),
                                                        style: TextStyle(
                                                          color: appcolor()
                                                              .mediumGreyColor,
                                                          fontSize: 12,
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                    : const SizedBox(
                                                  height: 6,
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
                        }
                      }),
                    )

                    // )
                    )));
  }
}
