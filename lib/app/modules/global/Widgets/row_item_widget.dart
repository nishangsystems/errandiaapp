import 'package:errandia/app/modules/errands/view/search_errand_prod.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/view/edit_product_view.dart';
import 'package:errandia/app/modules/services/view/edit_service_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RowItemWidget extends StatelessWidget {
  final String? name;
  final String? price;
  final String? image;
  final int index;
  final VoidCallback? onTap;

  const RowItemWidget(
      {Key? key, this.name, this.price, this.image, required this.index, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          // Image container
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            width: Get.width * 0.16,
            height: Get.height * 0.06,
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/errandia_logo.png',
              image: getImagePath(image!),
              fit: BoxFit.contain,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/errandia_logo.png',
                    fit: BoxFit.fill
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.5,
                  child: Text(
                    name!,
                    style: TextStyle(
                      color: appcolor().mainColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ),
                Text(
                  formatPrice(double.parse(price!)),
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
            onTap: onTap ?? () {},
            child: Column(
              children: [
                Text(
                  'Edit',
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
}

Widget func(context, data) {
  return Container(
    padding: const EdgeInsets.all(
      10,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        10,
      ),
    ),
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
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/errandia_logo.png',
            image: getImagePath(data['featured_image']),
            fit: BoxFit.fill,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/errandia_logo.png');
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['name'].length >= 15
                  ? '${data['name'] + '..'}'.substring(
                  0, 15)
                  : data['name'].toString(),
              style: TextStyle(
                color: appcolor().mainColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  formatPrice(double.parse(data['unit_price'].toString())),
                  style: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.1,
                ),
                // publish_draft_widget(
                //     index.isEven, index),
              ],
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            // print(index.toString());
            Get.bottomSheet(
              // backgroundColor: Colors.white,
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20),
                color: Colors.white,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment
                      .center,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.horizontal_rule,
                        size: 25,
                      ),
                    ),
                    // Text(index.toString()),
                    managebottomSheetWidgetitem(
                      title: 'Edit Product',
                      icondata: Icons.edit,
                      callback: () async {
                        print('tapped');
                        Get.back();
                        Get.to(() =>
                            EditProductView(
                              data: data,));
                      },
                    ),
                    managebottomSheetWidgetitem(
                      title: 'Edit Photo',
                      icondata: FontAwesomeIcons
                          .fileImage,
                      callback: () {
                        Get.back();
                      },
                    ),
                    managebottomSheetWidgetitem(
                      title: 'UnPublish Product',
                      icondata: FontAwesomeIcons
                          .minusCircle,
                      callback: () {},
                    ),
                    managebottomSheetWidgetitem(
                      title: 'Move to trash',
                      icondata: Icons.delete,
                      callback: () {},
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
                'Edit',
                style: TextStyle(
                    color: appcolor().bluetextcolor,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: appcolor().greyColor),
                  borderRadius: BorderRadius.circular(
                      5),
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

Widget fonc(context, data) {
  return Container(
    padding: const EdgeInsets.all(
      10,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        10,
      ),
    ),
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
              'assets/images/hair_cut.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Low Cut',
              style: TextStyle(
                color: appcolor().mainColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  'XAF 20',
                  style: TextStyle(
                    color: appcolor().mediumGreyColor,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.1,
                ),
                // publish_draft_widget(index.isEven, index),
              ],
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            // print(index.toString());
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
                    managebottomSheetWidgetitem(
                      title: 'Edit Service',
                      icondata: Icons.edit,
                      callback: () async {
                        print('tapped');
                        Get.back();
                        // Get.to(() => EditServiceView(data: profile_controller().service_list[index].toJson(),));
                      },
                    ),
                    managebottomSheetWidgetitem(
                      title: 'Edit Photo',
                      icondata: FontAwesomeIcons.fileImage,
                      callback: () {
                        Get.back();
                      },
                    ),
                    managebottomSheetWidgetitem(
                      title: 'Unpublish Product',
                      icondata: FontAwesomeIcons.minusCircle,
                      callback: () {},
                    ),
                    managebottomSheetWidgetitem(
                      title: 'Move to trash',
                      icondata: Icons.delete,
                      callback: () {},
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
                'Edit',
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
