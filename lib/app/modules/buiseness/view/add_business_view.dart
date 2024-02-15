import 'dart:convert';
import 'dart:io';
import 'package:errandia/app/APi/business.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/modal/category.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/modal/subcatgeory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../modal/Region.dart';
import '../../../../modal/Street.dart';
import '../../../../modal/Town.dart';
import '../../../APi/apidomain & api.dart';
import '../../../AlertDialogBox/alertBoxContent.dart';
import '../../global/Widgets/blockButton.dart';
import '../controller/add_business_controller.dart';
import 'manage_business_view.dart';

class add_business_view extends StatefulWidget {
  add_business_view({super.key});

  @override
  State<add_business_view> createState() => _add_business_viewState();
}

class _add_business_viewState extends State<add_business_view> {
  final business_controller controller = Get.put(business_controller());
  final add_business_controller add_controller =
      Get.put(add_business_controller());
  final imagePickercontroller imageController =
      Get.put(imagePickercontroller());

  var country;
  var value = null;
  var regionCode;
  bool isLoading = false;
  List<String> selectedFilters = [];
  List<int> selectedFilters_ = [];
  var town;
  var category;

  @override
  void initState() {
    super.initState();
    add_controller.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 8,
        title: const Text('Add Business'),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: appcolor().mediumGreyColor,
            fontSize: 18),
        automaticallyImplyLeading: false,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: appcolor().mediumGreyColor,
        ),
        actions: [
          TextButton(
              onPressed: () {
                var name =
                    add_controller.company_name_controller.text.toString();
                var description = add_controller
                    .Business_information_controller.text
                    .toString();
                var websiteAddress =
                    add_controller.website_address_controller.text.toString();
                var address = add_controller.address_controller.text.toString();
                var facebook =
                    add_controller.facebook_controller.text.toString();
                var instagram =
                    add_controller.instagram_controller.text.toString();
                var twitter = add_controller.twitter_controller.text.toString();
                var businessInfo = add_controller
                    .Business_information_controller.text
                    .toString();
                var phone = add_controller.phone_controller.text.toString();
                // var categories =
                //     add_controller.Business_category_controller.text.toString();

                if (name == '' || description == '') {
                  alertDialogBox(context, "Alert", 'Please Enter Fields');
                } else {
                  var file = "";

                  for (int i = 1; i < selectedFilters_.length; i++) {
                    file = "$file,${selectedFilters_[i]}";
                  }
                  if (kDebugMode) {
                    print("logo to upload: $file");
                  }

                  setState(() {
                    isLoading = true;
                  });

                  var value = {
                    "name": name,
                    "description": description,
                    "slogan": businessInfo,
                    "phone": phone,
                    "whatsapp": "whatsapp",
                    "category_id": category.toString(),
                    // "image_path": imageController.image_path.toString(),
                    "street": address,
                    "facebook": facebook,
                    "instagram": instagram,
                    "twitter": twitter,
                    "website": websiteAddress,
                    "region_id": regionCode.toString(),
                    "town_id": town.toString(),
                  };

                  PopupBox popup;
                  var response;

                  // check if logo image is empty
                  if (imageController.image_path.toString() == '') {
                    BusinessAPI.createBusiness(value, context)
                        .then((response_) => {
                              response = jsonDecode(response_),
                              print("added business: $response"),
                              if (response['status'] == 'success')
                                {
                                  popup = PopupBox(
                                    title: 'Success',
                                    description: response['data']['message'],
                                    type: PopupType.success,
                                  )
                                }
                              else
                                {
                                  popup = PopupBox(
                                    title: 'Error',
                                    description: response['data']['data']
                                        ['error'],
                                    type: PopupType.error,
                                  )
                                },
                              Future.delayed(const Duration(seconds: 3), () {
                                setState(() {
                                  isLoading = false;
                                });
                              }),
                              popup.showPopup(context),
                            });
                  } else {
                    print(
                        "image path: ${imageController.image_path.toString()}");
                    BusinessAPI.createBusinessWithImageLogo(value, context,
                            imageController.image_path.toString())
                        .then((response_) => {
                              response = jsonDecode(response_),
                              print("added business: $response"),
                              if (response['status'] == 'success')
                                {
                                  popup = PopupBox(
                                    title: 'Success',
                                    description: response['data']['message'],
                                    type: PopupType.success,
                                  )
                                }
                              else
                                {
                                  popup = PopupBox(
                                    title: 'Error',
                                    description: response['data']['data']
                                        ['error'],
                                    type: PopupType.error,
                                  )
                                },
                              Future.delayed(const Duration(seconds: 3), () {
                                setState(() {
                                  isLoading = false;
                                });
                              }),
                              popup.showPopup(context),
                            });
                  }
                }
              },
              child: isLoading == false
                  ? const Text(
                      'Publish',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  : const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      )))
        ],
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
                'Company Details'.tr,
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
                controller: add_controller.company_name_controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesomeIcons.buildingUser,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Company Name *',
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
              title: DropdownButtonFormField(
                iconSize: 0.0,
                isDense: true,
                isExpanded: true,
                padding: EdgeInsets.zero,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Business Category *',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                value: value,
                onChanged: (value) {
                  setState(() {
                    category = value as int;
                  });
                  print("category_id: $category");
                },
                items: categor.Items.map((e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(
                        e.name.toString(),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    )).toList(),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            // Business info
            Container(
              height: Get.height * 0.2,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                controller: add_controller.Business_information_controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    color: Colors.black,
                    FontAwesomeIcons.info,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Business Information *',
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

            // upload company logo
            Obx(
              () => SizedBox(
                height: imageController.image_path.isEmpty
                    ? null
                    : Get.height * 0.28,
                child: imageController.image_path.isEmpty
                    ? InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 20,
                                ),
                                scrollable: true,
                                content: SizedBox(
                                  // height: Get.height * 0.7,
                                  width: Get.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Upload Company Logo',
                                        style: TextStyle(
                                          color: appcolor().mainColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.05,
                                      ),
                                      Column(
                                        children: [
                                          blockButton(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.image,
                                                  color: appcolor().mainColor,
                                                  size: 22,
                                                ),
                                                Text(
                                                  '  Image Gallery',
                                                  style: TextStyle(
                                                      color:
                                                          appcolor().mainColor),
                                                ),
                                              ],
                                            ),
                                            ontap: () {
                                              Get.back();
                                              imageController
                                                  .getImageFromGallery();
                                            },
                                            color: appcolor().greyColor,
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.015,
                                          ),
                                          blockButton(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.camera,
                                                  color: appcolor().mainColor,
                                                  size: 22,
                                                ),
                                                Text(
                                                  '  Take Photo',
                                                  style: TextStyle(
                                                    color: appcolor().mainColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ontap: () {
                                              Get.back();
                                              imageController
                                                  .getimagefromCamera();
                                            },
                                            color: Color(0xfffafafa),
                                          ),
                                        ],
                                      )
                                    ],
                                  ).paddingSymmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: const Row(
                            children: [
                              Icon(Icons.image),
                              Text('  Upload Company Logo *'),
                              Spacer(),
                              Icon(
                                Icons.edit,
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: Get.height * 0.15,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.image),
                                const Text(
                                  '  Company Logo *',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.edit,
                                  ),
                                )
                              ],
                            ).paddingSymmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                            Divider(
                              color: appcolor().greyColor,
                              thickness: 1,
                              height: 1,
                              indent: 0,
                            ),
                            Stack(
                              children: [
                                Image(
                                  image: FileImage(
                                    File(
                                      imageController.image_path.toString(),
                                    ),
                                  ),
                                  height: Get.height * 0.19,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ).paddingSymmetric(horizontal: 20),
                                SizedBox(
                                  height: Get.height * 0.19,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          imageController.getImageFromGallery();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 60,
                                          color: Colors.lightGreen,
                                          child: const Center(
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          imageController.reset();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 60,
                                          color: appcolor().greyColor,
                                          child: const Center(
                                            child: Text(
                                              'Remove',
                                              style: TextStyle(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
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

            // website address
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                controller: add_controller.website_address_controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.category,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Website Address *',
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
            // phone number
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                controller: add_controller.phone_controller,
                keyboardType: TextInputType.phone,
                maxLength: 9,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Phone Number *',
                  counterText: '',
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

            // shop head
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Shop Head/Main Office *',
            //         style: TextStyle(fontSize: 15),
            //       ),
            //       Spacer(),
            //       Obx(
            //         () => SizedBox(
            //           width: Get.width * 0.2,
            //           child: FittedBox(
            //             fit: BoxFit.fill,
            //             child: Switch(
            //               value: controller.headmainSwitch.value,
            //               onChanged: (val) {
            //                 controller.headmainSwitch.value = val;
            //               },
            //             ),
            //           ),
            //         ),
            //       ),
            //       const Text('Active')
            //     ],
            //   ),
            // ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            //Business Location
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Text(
                'Business Location'.tr,
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
                padding: EdgeInsets.zero,
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
                  setState(() {
                    regionCode = value as int;
                  });
                  print("regionCode: $regionCode");
                   add_controller.loadTownsData(regionCode);
                },
                items: Regions.Items.map((e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(
                        e.name.toString(),
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    )).toList(),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.only(left: 15, right: 0),
                child:  Icon(
                  FontAwesomeIcons.city,
                  color: regionCode == null
                      ? Colors.grey
                      : Colors.black
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.only(left: 0, right: 15),
                child:  Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: regionCode == null
                      ? Colors.grey
                      : Colors.black
                ),
              ),
              contentPadding: EdgeInsets.zero,
              title: Obx(
                  () {
                    if (add_controller.isTownsLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return DropdownButtonFormField(
                      iconSize: 0.0,
                      isDense: true,
                      isExpanded: true,
                      padding: EdgeInsets.zero,
                      decoration:  InputDecoration.collapsed(
                        hintText: 'Town *',
                        hintStyle: TextStyle(
                            color: regionCode == null
                                ? Colors.grey
                                : Colors.black
                        ),
                      ),
                      value: value,
                      onChanged: (value) {
                        setState(() {
                          town = value as int;
                        });
                        print("townId: $town");
                      },
                      items: Towns.Items.map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(
                          e.name.toString(),
                          style:
                          const TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      )).toList(),
                    );
                  }
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),


            // address
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                controller: add_controller.address_controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    color: Colors.black,
                    FontAwesomeIcons.mapLocationDot,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Street *',
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

            // social links
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Text(
                'Social Links'.tr,
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

            //facebook
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                controller: add_controller.facebook_controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesomeIcons.facebookF,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Facebook *',
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

            //instagram

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                controller: add_controller.instagram_controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesomeIcons.instagram,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Instagram *',
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

            // twitter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                controller: add_controller.twitter_controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesomeIcons.twitter,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Twitter *',
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

            // assign manager
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 15,
            //     vertical: 15,
            //   ),
            //   child: Text(
            //     'Assign Manager'.tr,
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.w600,
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
            // // select manager
            // InkWell(
            //   onTap: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) => AlertDialog(
            //         insetPadding: EdgeInsets.symmetric(horizontal: 0),
            //         scrollable: true,
            //         contentPadding:
            //             EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            //         content: Container(
            //           width: Get.width,
            //           color: Colors.white,
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 'Select Branch Manager'.tr,
            //                 style: TextStyle(
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.bold,
            //                   color: appcolor().mainColor,
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: Get.height * 0.03,
            //               ),
            //               Obx(() => BranchManagerListWidget(),)
            //             ],
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            //     child: Row(
            //       children: [
            //         Icon(Icons.person),
            //         Text(
            //           '  Select Manager *',
            //           style: TextStyle(
            //             fontSize: 16,
            //           ),
            //         ),
            //         Spacer(),
            //         Icon(
            //           Icons.arrow_forward_ios_outlined,
            //         )
            //       ],
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
            // //add manager
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            //   height: Get.height * 0.08,
            //   width: Get.width * 0.7,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //     border: Border.all(
            //       color: appcolor().mainColor,
            //     ),
            //   ),
            //   child: InkWell(
            //     onTap: () {
            //       showDialog(
            //         context: context,
            //         builder: (context) => addManager_Widget(),
            //       );
            //     },
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.add_outlined,
            //           color: appcolor().mainColor,
            //         ),
            //         Text(
            //           '  Add New Manager',
            //           style: TextStyle(
            //             fontSize: 16,
            //             color: appcolor().mainColor,
            //           ),
            //         ),
            //       ],
            //     ).paddingSymmetric(
            //       horizontal: 10,
            //     ),
            //   ),
            // ),
            // Divider(
            //   color: appcolor().greyColor,
            //   thickness: 1,
            //   height: 1,
            //   indent: 0,
            // ),

            SizedBox(
              height: Get.height * 0.06,
            ),
          ],
        ),
      ),
    );
  }

  Widget BranchManagerListWidget() {
    return SizedBox(
      height: Get.height * 0.27,
      child: ListView.builder(
        itemCount: add_controller.managerList.length,
        itemBuilder: (context, index) => Row(
          children: [
            Text(add_controller.managerList[index]),
            const Spacer(),
            Obx(
              () => Radio(
                value: add_controller.managerList[index].toString(),
                groupValue: add_controller.group_value.value,
                onChanged: (val) {
                  add_controller.group_value.value = val.toString();
                },
              ),
            ),
          ],
        ),
      ),
    );

    // return Container(
    //   child: Column(
    //     children: [
    //       Row(
    //         children: [
    //          Text(add_controller.managerList[]),
    //           Spacer(),
    //           Obx(
    //             () => Radio(
    //               value: 'sort descending',
    //               groupValue: add_controller.group_value.value,
    //               onChanged: (val) {
    //                 add_controller.group_value.value = val.toString();
    //               },
    //             ),
    //           )
    //         ],
    //       ),

    //       // a-z
    // Row(
    //   children: [
    //     RichText(
    //       text: TextSpan(
    //         style: TextStyle(fontSize: 16),
    //         children: [
    //           TextSpan(
    //             text: 'Business Name : ',
    //             style: TextStyle(
    //               color: appcolor().mainColor,
    //             ),
    //           ),
    //           TextSpan(
    //             text: 'Asc A-Z',
    //             style: TextStyle(
    //               color: appcolor().mediumGreyColor,
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //     Spacer(),
    //     Obx(() => Radio(
    //           value: 'sort acending',
    //           groupValue: add_controller.group_value.value,
    //           onChanged: (val) {
    //             add_controller.group_value.value = val.toString();
    //           },
    //         ))
    //   ],
    // ),

    // // distance nearest to me
    // Row(
    //   children: [
    //     RichText(
    //         text: TextSpan(style: TextStyle(fontSize: 16), children: [
    //       TextSpan(
    //         text: 'Distance: Nearest to my location',
    //         style: TextStyle(
    //           color: appcolor().mainColor,
    //         ),
    //       ),
    //     ])),
    //     Spacer(),
    //     Obx(() => Radio(
    //           value: 'distance nearest to my location',
    //           groupValue: add_controller.group_value.value,
    //           onChanged: (val) {
    //             add_controller.group_value.value = val.toString();
    //           },
    //         ))
    //   ],
    // ),

    //       //recentaly added
    //       Row(
    //         children: [
    //           Text(
    //             'Recently Added ',
    //             style: TextStyle(color: appcolor().mainColor, fontSize: 16),
    //           ),
    //           Icon(
    //             Icons.arrow_upward,
    //             size: 25,
    //             color: appcolor().mediumGreyColor,
    //           ),
    //           Spacer(),
    //           Obx(
    //             () => Radio(
    //               value: 'recentaly added',
    //               groupValue: add_controller.group_value.value,
    //               onChanged: (val) {
    //                 add_controller.group_value.value = val.toString();
    //                 print(val.toString());
    //               },
    //             ),
    //           )
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget addManager_Widget() {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      scrollable: true,
      content: SizedBox(
        // height: Get.height * 0.7,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add branch manager
            Text(
              'Add Branch Manager',
              style: TextStyle(
                color: appcolor().mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // first name
            const Text(
              'First Name',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            SizedBox(
              height: Get.height * 0.001,
            ),

            // text form field
            Container(
              height: Get.height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xffe0e6ec),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: add_controller.add_manager_first_name_controller,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ),

            const Text(
              'Last Name',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            SizedBox(
              height: Get.height * 0.001,
            ),

            // text form field
            Container(
              height: Get.height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xffe0e6ec),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: add_controller.add_manager_last_name_controller,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ),

            SizedBox(
              height: Get.height * 0.02,
            ),

            //  phone number
            const Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            SizedBox(
              height: Get.height * 0.001,
            ),

            // phone number text field
            Container(
              height: Get.height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xffe0e6ec),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: Get.width * 0.2,
                    height: Get.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xffe0e6ec),
                      ),
                      color: Colors.white,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Image(
                        image: AssetImage(
                          'assets/images/flag_icon.png',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.2,
                    child: const Center(
                      child: Text(
                        '+237',
                        style: TextStyle(
                            color: Color.fromARGB(255, 171, 173, 175),
                            fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 1),
                      child: TextFormField(
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counter: Offstage(),
                        ),
                      ),
                    ),
                  ),

                  // by registering
                ],
              ),
            ),

            SizedBox(
              height: Get.height * 0.08,
            ),

            // add manager
            blockButton(
              title: const Text(
                'Add Manager',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              ontap: () {
                Get.back();
                String fullName = add_controller
                        .add_manager_first_name_controller.text
                        .toString() +
                    add_controller.add_manager_last_name_controller.text
                        .toString();
                add_controller.add_Manager(fullName);
                print(fullName);
              },
              color: appcolor().mainColor,
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
