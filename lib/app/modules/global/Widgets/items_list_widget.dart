
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/errandia_widget.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/product_controller.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/app/modules/services/view/service_details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemListWidget extends StatefulWidget {
  final dynamic data;
  final bool isService;
  
  const ItemListWidget({super.key, this.data, required this.isService});
  
  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> with WidgetsBindingObserver {
  late ProductController productController;
  late ScrollController scrollController;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    productController = Get.put(ProductController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isService) {
        productController.loadAllShopServices(widget.data['slug']);
      } else {
        productController.loadAllShopProducts(widget.data['slug']);
      }
    });
    
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (widget.isService) {
          productController.loadAllShopServices(widget.data['slug']);
        } else {
          productController.loadAllShopProducts(widget.data['slug']);
        }
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
    if (state == AppLifecycleState.resumed) {
      // productController.reloadAll();

      if (widget.isService) {
        productController.reloadAllShopServices();
        productController.loadAllShopServices(widget.data['slug']);
      } else {
        productController.reloadAllShopProducts();
        productController.loadAllShopProducts(widget.data['slug']);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      titledAppBar(
        widget.isService ? 'Services' : 'Products', [
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
             productController.reloadAll();

              if (widget.isService) {
                productController.loadAllShopServices(widget.data['slug']);
              } else {
                productController.loadAllShopProducts(widget.data['slug']);
              }
            },
            child: Obx(() {
              if (productController.isAllShopProductsLoading.isTrue ||
                  productController.isAllShopServicesLoading.isTrue) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                key: const PageStorageKey('item_list'),
                controller: scrollController,
                itemCount: widget.isService
                    ? productController.allShopServiceList.length
                    : productController.allShopProductList.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.47,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  var item = widget.isService
                      ? productController.allShopServiceList[index]
                      : productController.allShopProductList[index];

                  return GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print("service item: ${item['name']}");
                      }
                      if (widget.isService) {
                        Get.to(() => ServiceDetailsView(service: item));
                      } else {
                        Get.to(() => Product_view(item: item));
                      }
                    },
                    child:  errandia_widget(
                      cost: item['unit_price'].toString(),
                      imagePath: item['featured_image'],
                      name: item['name'],
                      location: item['shop'] != null ? item['shop']['street'] : "",
                    ),
                  );
                },
              );
            }),
          ),
        )
        ],
      ),
    );
  }
}