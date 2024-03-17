import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:errandia/modal/Region.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class filter_product_view extends StatefulWidget {
  filter_product_view({super.key});

  @override
  _filter_product_viewState createState() => _filter_product_viewState();
}

class _filter_product_viewState extends State<filter_product_view> {

  late add_product_cotroller product_controller;
  var category;
  var regionCode;


  @override
  void initState() {
    super.initState();
    product_controller = Get.put(add_product_cotroller());
    product_controller.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Filter By',
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: appcolor().mediumGreyColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Apply',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          // // sort
          // const Text(
          //   'Status',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ).paddingSymmetric(horizontal: 10,),
          // // radion button
          // radio_button_widget().paddingSymmetric(horizontal: 5,),
          // date
          // const Text(
          //   'Date',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ).paddingSymmetric(horizontal: 10,),
          //
          // Divider(
          //   color: appcolor().greyColor,
          //   thickness: 1,
          //   height: 1,
          //   indent: 0,
          // ),
          // // date picker from
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          //   child: TextFormField(
          //     keyboardType: TextInputType.datetime,
          //     decoration: const InputDecoration(
          //       border: InputBorder.none,
          //       prefixIcon: Icon(
          //         Icons.date_range,
          //         color: Colors.black,
          //       ),
          //       hintStyle: TextStyle(
          //         color: Colors.black,
          //       ),
          //       hintText: 'From : 01/03/2023',
          //       suffixIcon: Icon(
          //         Icons.edit,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(
          //   color: appcolor().greyColor,
          //   thickness: 1,
          //   height: 1,
          //   indent: 0,
          // ),

          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          //   child: TextFormField(
          //     keyboardType: TextInputType.datetime,
          //     decoration: const InputDecoration(
          //       border: InputBorder.none,
          //       prefixIcon: Icon(
          //         Icons.date_range,
          //         color: Colors.black,
          //       ),
          //       hintStyle: TextStyle(
          //         color: Colors.black,
          //       ),
          //       hintText: 'To : 02/03/2023',
          //       suffixIcon: Icon(
          //         Icons.edit,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          //
          // Divider(
          //   color: appcolor().greyColor,
          //   thickness: 1,
          //   height: 1,
          //   indent: 0,
          // ),
          //
          Text(
            'Category'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ).paddingSymmetric(horizontal: 10, vertical: 5),

          Divider(
            color: appcolor().greyColor,
            thickness: 1,
            height: 1,
            indent: 0,
          ),

          SizedBox(
            height: Get.height * 0.01,
          ),
          // categories
          ListTile(
            leading: Container(
              padding: const EdgeInsets.only(left: 12, right: 0),
              child: const Icon(
                Icons.category,
                color: Colors.black,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(left: 0, right: 12),
              child: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            title: Obx(
                    () {
                  if (product_controller.isLoadingCategories.value) {
                    return Text('Loading Categories...',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    );
                  } else if (product_controller.categoryList.isEmpty) {
                    return Text('No Categories found',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    );
                  } else {
                    return DropdownButtonFormField<dynamic>(
                      value: category,
                      iconSize: 0.0,
                      isDense: true,
                      isExpanded: true,
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Select a Category *',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      onChanged: (dynamic newValue) {
                        setState(() {
                          category = newValue as int;
                        });
                        print("selected category: $category");
                      },
                      items: product_controller.categoryList.map<DropdownMenuItem<dynamic>>((dynamic category) {
                        return DropdownMenuItem<dynamic>(
                          value: category['id'],
                          child: Text(capitalizeAll(category['name']),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                }
            ),
          ),

          SizedBox(
            height: Get.height * 0.1,
          ),

          const Text(
            'Regions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ).paddingSymmetric(horizontal: 10, vertical: 5),

          Divider(
            color: appcolor().greyColor,
            thickness: 1,
            height: 1,
            indent: 0,
          ),

          // regions
          ListTile(
            leading: Container(
              padding: const EdgeInsets.only(left: 15, right: 0),
              child: const Icon(
                FontAwesomeIcons.earthAmericas,
                color: Colors.black,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(left: 0, right: 15),
              child: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.black,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            title: DropdownButtonFormField(
              iconSize: 0.0,
              padding: const EdgeInsets.only(bottom: 8),
              isDense: true,
              isExpanded: true,
              decoration: const InputDecoration.collapsed(
                hintText: 'Region *',
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              value: regionCode,
              onChanged: (value) async {
                setState(() {
                  regionCode = value as int;
                });
                print("regionCode: $regionCode");
                // add_controller.loadTownsData(regionCode);
              },
              items: Regions.Items.map((e) => DropdownMenuItem(
                value: e.id,
                child: Text(
                  e.name.toString(),
                  style: const TextStyle(
                      fontSize: 15, color: Colors.black),
                ),
              )).toList(),
            ),
          ),

        ],
      ),),
    );
  }

//   Widget radio_button_widget() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Obx(
//               () => Radio(
//                 visualDensity: const VisualDensity(
//                   horizontal: VisualDensity.minimumDensity,
//                 ),
//                 value: 'Publish',
//                 groupValue: groupValue.value,
//                 onChanged: (val) {
//                   groupValue.value = val.toString();
//                 },
//               ),
//             ),
//             const Text(
//               'Publish',
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Obx(
//               () => Radio(
//                 visualDensity: const VisualDensity(
//                   horizontal: VisualDensity.minimumDensity,
//                 ),
//                 value: 'Draft',
//                 groupValue: groupValue.value,
//                 onChanged: (val) {
//                   groupValue.value = val.toString();
//                 },
//               ),
//             ),
//             const Text(
//               'Draft',
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Obx(
//               () => Radio(
//                 visualDensity: const VisualDensity(
//                   horizontal: VisualDensity.minimumDensity,
//                 ),
//                 value: 'Trash',
//                 groupValue: groupValue.value,
//                 onChanged: (val) {
//                   groupValue.value = val.toString();
//                 },
//               ),
//             ),
//             const Text(
//               'Trash',
//             ),
//           ],
//         ),
//       ],
//     );
//   }
}
