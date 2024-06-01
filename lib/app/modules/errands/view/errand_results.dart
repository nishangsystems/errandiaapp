import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/Widgets/search_item_widget.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/app/modules/services/view/service_details_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrandResults extends StatefulWidget {
  final Map<dynamic, dynamic>? data;
  final String errandId;

  const ErrandResults({super.key, this.data, required this.errandId});

  @override
  _ErrandResultsState createState() => _ErrandResultsState();
}

class _ErrandResultsState extends State<ErrandResults>
    with WidgetsBindingObserver {
  late errand_controller errandController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    errandController = Get.put(errand_controller());
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.data != null) {
        setState(() {
          errandController.resultsList.value = widget.data!['items'];
        });
      } else {
        errandController.fetchErrandResults(widget.errandId);
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        errandController.fetchErrandResults(widget.errandId);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    errandController.resetErrandResults();
    // Get.delete<errand_controller>();
    super.dispose();
  }

  @override
  void deactivate() {
    // errandController.resetErrandResults();
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      errandController.reloadErrandResults(widget.errandId);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("errand results: ${errandController.resultsList}");
    print("errand results count: ${errandController.resultsList.length}");
    return WillPopScope(
      onWillPop: () async {
        errandController.resetErrandResults();
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            "Errand Results",
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          iconTheme: IconThemeData(
            color: appcolor().mediumGreyColor,
            size: 30,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (errandController.resultsList.isEmpty && widget.data != null)
                Container(
                  padding: const EdgeInsets.all(30),
                  height: Get.height * 0.68,
                  child: buildErrorWidget(
                    message: 'No results found',
                    callback: () {
                      errandController.reloadErrandResults(widget.errandId);
                    },
                  ),
                ),
              if (errandController.isResultsError.value)
                Container(
                  padding: const EdgeInsets.all(30),
                  height: Get.height * 0.68,
                  child: buildErrorWidget(
                    message:
                        'There was an error loading your errand results, please try again later',
                    callback: () {
                      errandController.reloadErrandResults(widget.errandId);
                    },
                  ),
                ),
              if (errandController.isResultsLoading.value)
                SizedBox(
                  height: Get.height * 0.68,
                  child: buildLoadingWidget(),
                ),
              if (widget.data == null)
                Obx(() {
                  if (errandController.isResultsLoading.value) {
                    return SizedBox(
                      height: Get.height * 0.68,
                      child: buildLoadingWidget(),
                    );
                  } else if (errandController.isResultsError.value) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      height: Get.height * 0.68,
                      child: buildErrorWidget(
                        message:
                            'There was an error loading your errand results, please try again later',
                        callback: () {
                          errandController.reloadErrandResults(widget.errandId);
                        },
                      ),
                    );
                  } else if (errandController.resultsList.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      height: Get.height * 0.68,
                      child: buildErrorWidget(
                        message: 'No results found',
                        callback: () {
                          errandController.reloadErrandResults(widget.errandId);
                        },
                      ),
                    );
                  } else {
                    return GridView.builder(
                      key: const PageStorageKey("errand_results"),
                      controller: _scrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.74,
                        crossAxisSpacing: 1 / 2.66,
                        mainAxisSpacing: 1 / 1.88,
                      ),
                      itemCount: errandController.resultsList.length,
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var item = errandController.resultsList[index];
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
                            item: item,
                            key: UniqueKey(),
                          ),
                        );
                      },
                    );
                  }
                }),
              if (widget.data != null)
                GridView.builder(
                  key: const PageStorageKey("errand_results"),
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.74,
                    crossAxisSpacing: 1 / 2.66,
                    mainAxisSpacing: 1 / 1.88,
                  ),
                  itemCount: widget.data!['items'].length,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var item = widget.data!['items'][index];
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
                        item: item,
                        key: UniqueKey(),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
