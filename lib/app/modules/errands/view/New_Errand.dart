import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../modal/Region.dart';
import '../../../../modal/Street.dart';
import '../../../../modal/Town.dart';
import '../../../APi/apidomain & api.dart';
import '../../buiseness/controller/add_business_controller.dart';
import '../../global/Widgets/blockButton.dart';
import '../controller/newErradiaController.dart';
import '2nd_screen_new_errand.dart';
import 'errand_view.dart';


imagePickercontroller imageController = Get.put(imagePickercontroller());

class New_Errand extends StatefulWidget {
  const New_Errand({super.key});

  @override
  State<New_Errand> createState() => _NewErrandState();
}

class _NewErrandState extends State<New_Errand> {
  late errand_controller errandController;
  late new_errandia_controller newErrandController;

  var value;
  var streetvalue;
  var town_;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // street();
    errandController = Get.put(errand_controller());
    newErrandController = Get.put(new_errandia_controller());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 8,
        title: const Text(
          'New Errand',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff113d6b),
          ),
        ),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: appcolor().mediumGreyColor,
            fontSize: 18),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xff113d6b),
        ),
        // actions: [
        //   TextButton(
        //       onPressed: () {},
        //       child: Text(
        //         'Publish',
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        //       ))
        // ],
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Text(
                '1- Enter Search Details'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            // company name
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                controller: newErrandController.titleController,
                onChanged: (value) {
                  newErrandController.update();
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesomeIcons.buildingUser,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Product/Service Name *',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'e.g laptop,charger',
                style: TextStyle(fontSize: 10),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Text(
                'Specify Search Location'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
                value: value,
                onChanged: (value) async {
                  // setState(() {
                  //
                  // });
                  newErrandController.regionCode.value = value as String;
                  newErrandController.town.value = '';
                  print("regionCode: ${newErrandController.regionCode.value}");
                  errandController.loadTownsData(int.parse(newErrandController.regionCode.value));
                  newErrandController.update();
                },
                items: Regions.Items.map((e) => DropdownMenuItem(
                  value: e.id.toString(),
                  child: Text(
                    e.name.toString(),
                    style: const TextStyle(
                        fontSize: 15, color: Colors.black),
                  ),
                )).toList(),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 4,
              indent: 0,
            ),

            //  towns
            ListTile(
              leading: Container(
                padding: const EdgeInsets.only(left: 15, right: 0),
                child: Icon(FontAwesomeIcons.city,
                    color:
                    newErrandController.regionCode.value == '' ? Colors.grey : Colors.black),
              ),
              trailing: Container(
                padding: const EdgeInsets.only(left: 0, right: 15),
                child: Icon(Icons.arrow_forward_ios_outlined,
                    color:
                    newErrandController.regionCode.value == '' ? Colors.grey : Colors.black),
              ),
              contentPadding: EdgeInsets.zero,
              title: Obx(() {
                if (errandController.isTownsLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return DropdownButtonFormField(
                    iconSize: 0.0,
                    isDense: true,
                    isExpanded: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Town *',
                      hintStyle: TextStyle(
                          color: newErrandController.regionCode.value == ''
                              ? Colors.grey
                              : Colors.black),
                    ),
                    value: town_,
                    onChanged: (value) {
                      setState(() {
                      });
                      newErrandController.town.value = value.toString();
                      print("townId: ${newErrandController.town.value}");
                      newErrandController.update();
                    },
                    items: errandController.townList.map((e) {
                      return DropdownMenuItem(
                        value: e['id'],
                        child: Text(
                          e['name'].toString(),
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                      );
                    }).toList(),
                  );
                }
              }),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 4,
              indent: 0,
            ),
            // ListTile(
            //   leading: const Icon(
            //     FontAwesomeIcons.locationCrosshairs,
            //   ),
            //   trailing: const Icon(
            //     Icons.arrow_forward_ios_outlined,
            //   ),
            //   title: Padding(
            //     padding: const EdgeInsets.only(right: 10, bottom: 10),
            //     child: DropdownButtonFormField(
            //       iconSize: 0.0,
            //       decoration: const InputDecoration.collapsed(
            //         hintText: 'Street',
            //       ),
            //       value: value,
            //       onChanged: (value) {
            //         setState(() {
            //           streetvalue = value as int;
            //         });
            //       },
            //       items: Street.Items.map((e) => DropdownMenuItem(
            //             value: e.id,
            //             child: Text(
            //               e.name.toString(),
            //               style: const TextStyle(fontSize: 11),
            //             ),
            //           )).toList(),
            //     ),
            //   ),
            // ),

            // Divider(
            //   color: appcolor().greyColor,
            //   thickness: 1,
            //   height: 4,
            //   indent: 0,
            // ),
            //  info
            Container(
              height: Get.height * 0.2,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                controller: newErrandController.descriptionController,
                minLines: 1,
                maxLines: 4,
                onChanged: (value) {
                  newErrandController.update();
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    color: Colors.black,
                    FontAwesomeIcons.info,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Description *',
                  suffixIcon: Icon(
                    color: Colors.black,
                    Icons.edit,
                  ),
                ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                if (newErrandController.titleController.text != '' &&
                    newErrandController.descriptionController.text != '') {
                  Get.to(nd_screen(
                    title: newErrandController.titleController.text.toString(),
                    description: newErrandController.descriptionController.text.toString(),
                    region: newErrandController.regionCode,
                    street: street,
                    town: newErrandController.town,
                  ));
                } else {
                  alertDialogBox(context, 'Alert', 'Please Fill Fields');
                }
                // newErrandController.title..clear();
                // newErrandController.description.clear();
              },
              child: Obx(() {
                if (newErrandController.isFormFilled) {
                  return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Container(
                        height: Get.height * 0.09,
                        width: Get.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: appcolor().mainColor,
                        ),
                        child: const Center(
                          child: Text(
                            'Next',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                  );
                } else {
                  return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Container(
                        height: Get.height * 0.09,
                        width: Get.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffe0e6ec),
                        ),
                        child: const Center(
                          child: Text(
                            'Next',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey),
                          ),
                        ),
                      )
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
