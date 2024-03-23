
import 'package:errandia/app/modules/buiseness/view/edit_business_view.dart';
import 'package:errandia/app/modules/buiseness/view/manage_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/bottomsheet_item.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/services/view/add_service_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessItem extends StatelessWidget {
  final String name;
  final String address;
  final String image;
  final VoidCallback onTap;

  const BusinessItem({
    Key? key,
    required this.name,
    required this.address,
    required this.image,
    required this.onTap,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        children: [
          // Image container
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            width: Get.width * 0.16,
            height: Get.height * 0.06,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/errandia_logo.jpeg',
              image: getImagePath(image),
              fit: BoxFit.contain,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/errandia_logo.jpeg',
                  fit: BoxFit.fill,
                );
              }
            )
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: appcolor().mainColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  address,
                  style: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Column(
              children: [
                Text(
                  'MANAGE',
                  style: TextStyle(
                    color: appcolor().bluetextcolor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: appcolor().greyColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child:  Icon(Icons.more_horiz, color: appcolor().greyColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget func(context, data) {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    child: Row(
      children: [
        // image container
        Container(
          margin: const EdgeInsets.only(
            right: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          width: Get.width * 0.16,
          height: Get.height * 0.06,
          child: const Image(
            image: AssetImage(
              'assets/images/barber_logo.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data['name']}',
                style: TextStyle(
                  color: appcolor().mainColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Text(
                '${data['address']}',
                style: TextStyle(
                  color: appcolor().mediumGreyColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Get.bottomSheet(
              // backgroundColor: Colors.white,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                color: Colors.white,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.horizontal_rule,
                        size: 25,
                      ),
                    ),
                    // Text(index.toString()),
                    bottomSheetWidgetitem(
                      title: 'Edit Business',
                      imagepath:
                      'assets/images/sidebar_icon/icon-edit.png',
                      callback: () async {
                        print('tapped');
                        Get.back();
                        Get.to(() => EditBusinessView(data: data,));
                      },
                    ),
                    bottomSheetWidgetitem(
                      title: 'Add New Product',
                      imagepath:
                      'assets/images/sidebar_icon/add_products.png',
                      callback: () async {
                        print('add new product');
                        Get.back();
                        // show a popup with a dropdown to select the shop to add the product to

                      },
                    ),
                    bottomSheetWidgetitem(
                      title: 'Add New Service',
                      imagepath:
                      'assets/images/sidebar_icon/services.png',
                      callback: () async {
                        print('add new service');
                        Get.back();
                        Get.to(() => add_service_view());
                      },
                    ),
                    bottomSheetWidgetitem(
                      title: 'Suspend Business',
                      imagepath:
                      'assets/images/sidebar_icon/icon-suspend.png',
                      callback: () {
                        Get.back();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return businessDialog(BusinessAction.suspend);
                          },
                        );
                      },
                    ),
                    bottomSheetWidgetitem(
                      title: 'Update Location',
                      imagepath:
                      'assets/images/sidebar_icon/icon-location.png',
                      callback: () {},
                    ),
                    bottomSheetWidgetitem(
                      title: 'Move to trash',
                      imagepath:
                      'assets/images/sidebar_icon/icon-trash.png',
                      callback: () {
                        Get.back();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return businessDialog(BusinessAction.delete);
                          },
                        );
                        //   var value = {
                        //     "errand_id": data['id']
                        //   };
                        //   api().deleteUpdate('shops/delete', 1, value);
                        //   Future.delayed(Duration(seconds: 2),(){
                        //     Get.offAll(manage_business_view());
                        //   });
                      },
                    ),
                  ],
                ),
              ),

              enableDrag: true,
            );
          },
          child: Column(
            children: [
              Text(
                'MANAGE',
                style: TextStyle(
                    color: appcolor().bluetextcolor,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: appcolor().greyColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: appcolor().greyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
