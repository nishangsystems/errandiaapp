import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/errands/view/2nd_screen_edit_errand.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../modal/Region.dart';
import '../controller/newErradiaController.dart';


imagePickercontroller imageController = Get.put(imagePickercontroller());

class EditErrand extends StatefulWidget {
  final data;
  const EditErrand({super.key, this.data});

  @override
  State<EditErrand> createState() => _EditErrandState();
}

class _EditErrandState extends State<EditErrand> {
  late errand_controller errandController;
  late new_errandia_controller newErrandController;

  var value;
  var streetvalue;
  var town_;

  @override
  void initState() {
    super.initState();
    // street();
    errandController = Get.put(errand_controller());
    newErrandController = Get.put(new_errandia_controller());

    print("errand data: ${widget.data}");

    newErrandController.titleController.text = widget.data['title'];
    newErrandController.descriptionController.text = widget.data['description'] ?? '';
    newErrandController.regionCode.value = widget.data['region'].toString() != '[]' ? widget.data['region']['id'].toString() : '';
    newErrandController.town.value = widget.data['town'].toString() != '[]' ?  widget.data['town']['id'].toString() : '';

    setState(() {
      value = widget.data['region'].toString() != '[]' ? widget.data['region']['id'] as int : null;

      if (value != null) {
        errandController.loadTownsData(int.parse(newErrandController.regionCode.value));
      }

      town_ = widget.data['town'].toString() != '[]' ? widget.data['town']['id'] as int : null;


    });

    // errandController.loadTownsData(int.parse(newErrandController.regionCode.value));

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          newErrandController.titleController.clear();
          newErrandController.descriptionController.clear();
          newErrandController.regionCode.value = '';
          newErrandController.town.value = '';
          newErrandController.update();
          // widget.data['categories'] = [];
          // widget.data['images'] = [];
        });

        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.blue[700],
          titleSpacing: 8,
          title: const Text(
            'Edit Errand',
          ),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 20),
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white
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
                    hintText: 'Region',
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  value: value,
                  onChanged: (value) async {
                    // setState(() {
                    //
                    // });
                    newErrandController.regionCode.value = value.toString();
                    newErrandController.town.value = '';
                    print("regionCode: ${newErrandController.regionCode.value}");
                    errandController.loadTownsData(int.parse(newErrandController.regionCode.value));
                    newErrandController.update();
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
                        hintText: 'Town',
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
                    hintText: 'Description',
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
                    Get.to(() => EditErrand2(
                      data: {
                        ...widget.data,
                        "title": newErrandController.titleController.text,
                        "description": newErrandController.descriptionController.text,
                        "region": {
                          "id": newErrandController.regionCode.value,
                        },
                        "town": {
                          "id": newErrandController.town.value,
                        },
                      },
                    ), transition: Transition.rightToLeft, duration: const Duration(milliseconds: 500))?.then((value) {
                      if (value != null) {
                        setState(() {
                          // widget.data['title'] = value['title'];
                          // widget.data['description'] = value['description'];
                          // widget.data['region'] = value['region'];
                          // widget.data['town'] = value['town'];
                          widget.data['images'] = value['images'];
                          widget.data['categories'] = value['categories'];
                        });
                      }
                    });
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
                            color: Colors.blue[700],
                          ),
                          child: const Center(
                            child: Text(
                              'NEXT',
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
      ),
    );
  }
}
