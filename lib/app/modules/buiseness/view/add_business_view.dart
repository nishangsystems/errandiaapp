import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/business.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/modal/category.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../modal/Region.dart';
import '../../../../modal/Town.dart';
import '../../../AlertDialogBox/alertBoxContent.dart';
import '../../global/Widgets/blockButton.dart';
import '../controller/add_business_controller.dart';

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
  final profile_controller profileController = Get.put(profile_controller());
  final home_controller homeController = Get.put(home_controller());

  var country;

  // var value = null;
  var regionCode;
  bool isLoading = false;
  List<String> selectedFilters = [];
  List<int> selectedFilters_ = [];
  var filteredCountries = ["CM"];
  List<Country> filter = [];
  var town;
  var category;
  var phoneNumber;
  var whatsappNumber;
  bool focusInEmailField = false;

  // var regionValue;
  // var townValue;

  @override
  void initState() {
    super.initState();
    add_controller.loadCategories();

    countries.forEach((element) {
      filteredCountries.forEach((filteredC) {
        if (element.code == filteredC) {
          filter.add(element);
        }
      });
    });
  }

  void createBusiness(BuildContext context) {
    var name = add_controller.company_name_controller.text.toString();
    var description = add_controller.description_controller.text.toString();
    var websiteAddress =
        add_controller.website_address_controller.text.toString();
    var address = add_controller.address_controller.text.toString();
    // var facebook =
    //     add_controller.facebook_controller.text.toString();
    // var instagram =
    //     add_controller.instagram_controller.text.toString();
    // var twitter = add_controller.twitter_controller.text.toString();
    var businessInfo =
        add_controller.Business_information_controller.text.toString();
    var phone = add_controller.phone_controller.text.toString();
    // var categories =
    //     add_controller.Business_category_controller.text.toString();
    var email = add_controller.email_controller.text.toString();
    var whatsapp = add_controller.whatsapp_controller.text.toString();

    print("whatsapp number controller: $whatsapp");

    if (name == '') {
      alertDialogBox(context, "Error", 'Please enter company name');
    } else if (category == null) {
      alertDialogBox(context, "Error", 'Please select category');
    } else if (description == '') {
      alertDialogBox(context, "Error", 'Please enter description');
    } else if (phoneNumber == '' || phoneNumber == null) {
      alertDialogBox(context, "Error", 'Please enter phone number');
    } else if (email != '' && add_controller.emailValid.value == false) {
      alertDialogBox(context, "Error", 'Please enter a valid email address');
    } else if (regionCode == null) {
      alertDialogBox(context, "Error", 'Please select region');
    } else if (imageController.image_path.isEmpty) {
      alertDialogBox(context, "Error", "Business Logo is required");
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
        "phone": phoneNumber.toString(),
        "whatsapp": whatsapp ?? "",
        "category_id": category.toString(),
        // "image_path": imageController.image_path.toString(),
        "street": address ?? "",
        "email": email ?? "",
        // "facebook": facebook,
        // "instagram": instagram,
        // "twitter": twitter,
        "website": websiteAddress ?? "",
      };

      if (regionCode != null) {
        value['region_id'] = regionCode.toString();
      }

      if (town != null) {
        value['town_id'] = town.toString();
      }

      PopupBox popup;
      var response;

      print("phone number: $phoneNumber");
      // print("whatsapp number: $whatsappNumber");

      // check if logo image is empty
      // if (imageController.image_path.toString() == '') {
      //   BusinessAPI.createBusiness(value, context).then((response_) => {
      //         response = jsonDecode(response_),
      //         print("added business: $response"),
      //         if (response['status'] == 'success')
      //           {
      //             popup = PopupBox(
      //               title: 'Success',
      //               description: response['data']['message'],
      //               type: PopupType.success,
      //             ),
      //             // reset all form fields
      //             add_controller.resetFields(),
      //             setState(() {
      //               regionCode = null;
      //               town = null;
      //               category = null;
      //               selectedFilters_.clear();
      //             }),
      //             imageController.reset(),
      //             // home_controller()
      //             //     .featuredBusinessData
      //             //     .clear(),
      //             // home_controller()
      //             //     .fetchFeaturedBusinessesData(),
      //             profileController.reloadMyBusinesses(),
      //           }
      //         else
      //           {
      //             popup = PopupBox(
      //               title: 'Error',
      //               description: response['data']['data']['error'],
      //               type: PopupType.error,
      //             )
      //           },
      //         Future.delayed(const Duration(seconds: 2), () {
      //           setState(() {
      //             isLoading = false;
      //           });
      //         }),
      //         popup.showPopup(context),
      //       });
      // } else {
      print("image path: ${imageController.image_path.toString()}");
      BusinessAPI.createBusinessWithImageLogo(
              value, context, imageController.image_path.toString())
          .then((response_) => {
                response = jsonDecode(response_),
                print("added business: $response"),
                if (response['status'] == 'success')
                  {
                    popup = PopupBox(
                      title: 'Success',
                      description: response['data']['message'],
                      type: PopupType.success,
                    ),
                    add_controller.resetFields(),
                    setState(() {
                      regionCode = null;
                      town = null;
                      category = null;
                      selectedFilters_.clear();
                    }),
                    imageController.reset(),
                    // home_controller()

                    //     .featuredBusinessData
                    //     .clear(),
                    homeController.reloadRecentlyPostedItems(),
                    homeController.reloadFeaturedBusinessesData(),
                    profileController.reloadMyBusinesses(),
                  }
                else
                  {
                    popup = PopupBox(
                      title: 'Error',
                      description: response['data']['data']['error'],
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
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        profileController.reloadMyBusinesses();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appcolor().mainColor,
          titleSpacing: 8,
          title: const Text('Add Business'),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18),
          automaticallyImplyLeading: false,
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  createBusiness(context);
                },
                child: const Text(
                  'Publish',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.white38,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ))
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                      value: category,
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
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
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

                  // business description
                  Container(
                    height: Get.height * 0.2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 10,
                    ),
                    child: TextFormField(
                      controller: add_controller.description_controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          color: Colors.black,
                          Icons.info_outlined,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Business Description *',
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

                  // Business info
                  Container(
                    height: Get.height * 0.1,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                    child: TextFormField(
                      controller:
                          add_controller.Business_information_controller,
                      minLines: 1,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          color: Colors.black,
                          FontAwesomeIcons.info,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Business Slogan (optional)',
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
                          : Get.height * 0.40,
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 20,
                                      ),
                                      scrollable: true,
                                      content: SizedBox(
                                        // height: Get.height * 0.7,
                                        width: Get.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons.image,
                                                        color: appcolor()
                                                            .mainColor,
                                                        size: 22,
                                                      ),
                                                      Text(
                                                        '  Image Gallery',
                                                        style: TextStyle(
                                                            color: appcolor()
                                                                .mainColor),
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
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons.camera,
                                                        color: appcolor()
                                                            .mainColor,
                                                        size: 22,
                                                      ),
                                                      Text(
                                                        '  Take Photo',
                                                        style: TextStyle(
                                                          color: appcolor()
                                                              .mainColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ontap: () async {
                                                    Get.back();
                                                    var path =
                                                        await imageController
                                                            .getimagefromCamera();

                                                    print("image path: $path");

                                                    if (path != null) {
                                                      File? file = File(path);

                                                      print(
                                                          "original file size: ${file.lengthSync()}");

                                                      try {
                                                        file =
                                                            (await compressFile(
                                                                file: file));
                                                        print(
                                                            "Compressed file size: ${file.lengthSync()}");
                                                      } catch (e) {
                                                        print(
                                                            "Error compressing file: $e");
                                                      }
                                                      imageController.image_path
                                                          .value = file!.path;

                                                      imageController.update();

                                                      print(
                                                          "compressed file path: ${file.path}");
                                                    }
                                                  },
                                                  color:
                                                      const Color(0xfffafafa),
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
                              height: Get.height * 0.38,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.image),
                                      const Text(
                                        '  Company Logo',
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
                                      Obx(() {
                                        return imageController
                                                .image_path.isEmpty
                                            ? Container()
                                            : Image(
                                                image: FileImage(
                                                  File(
                                                    imageController.image_path
                                                        .toString(),
                                                  ),
                                                ),
                                                height: Get.height * 0.32,
                                                width: Get.width * 0.9,
                                                fit: BoxFit.fill,
                                              ).paddingSymmetric(
                                                horizontal: 50);
                                      }),
                                      SizedBox(
                                        height: Get.height * 0.32,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                imageController
                                                    .getImageFromGallery();
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                        hintText: 'Website Address (optional)',
                        suffixIcon: Icon(
                          color: Colors.black,
                          Icons.edit,
                        ),
                      ),
                    ),
                  ),

                  // phone number
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xffe0e6ec),
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        // intl phone field
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 0, left: 10),
                          child: SizedBox(
                            width: Get.width * 0.86,
                            child: IntlPhoneField(
                              controller: add_controller.phone_controller,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(top: 12),
                                border: InputBorder.none,
                                counter: SizedBox(),
                                hintText: 'Phone Number *',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                              keyboardType: TextInputType.number,
                              initialCountryCode: 'CM',
                              countries: filter,
                              showDropdownIcon: false,
                              dropdownTextStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  print(value);
                                }
                                return null;
                              },
                              onChanged: (phone) {
                                // add_controller.phone_controller.text = phone.completeNumber;
                                print("phone: ${phone.completeNumber}");
                                setState(() {
                                  phoneNumber = phone.completeNumber;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  //   child: TextFormField(
                  //     controller: add_controller.phone_controller,
                  //     keyboardType: TextInputType.phone,
                  //     maxLength: 9,
                  //     decoration: const InputDecoration(
                  //       border: InputBorder.none,
                  //       prefixIcon: Icon(
                  //         Icons.phone,
                  //         color: Colors.black,
                  //       ),
                  //       hintStyle: TextStyle(
                  //         color: Colors.black,
                  //       ),
                  //       hintText: 'Phone Number *',
                  //       counterText: '',
                  //       suffixIcon: Icon(
                  //         color: Colors.black,
                  //         Icons.edit,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // whatsapp number

                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  //   child: Row(
                  //     children: [
                  //     //    intl whatsapp phone field
                  //       Padding(
                  //         padding: const EdgeInsets.only(top: 5, bottom: 0, left: 10),
                  //         child: SizedBox(
                  //           width: Get.width * 0.86,
                  //           child: IntlPhoneField(
                  //             controller: add_controller.whatsapp_controller,
                  //             decoration: const InputDecoration(
                  //                 contentPadding: EdgeInsets.only(top: 12),
                  //                 border: InputBorder.none,
                  //               counter: SizedBox(),
                  //               hintText: 'Whatsapp (optional)',
                  //               hintStyle: TextStyle(
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //             style: const TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 17,
                  //             ),
                  //             keyboardType: TextInputType.number,
                  //             initialCountryCode: 'CM',
                  //             showDropdownIcon: false,
                  //             dropdownTextStyle: const TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 17,
                  //             ),
                  //             validator: (value) {
                  //               if (value == null) {
                  //                 print(value);
                  //               }
                  //               return null;
                  //             },
                  //             onChanged: (phone) {
                  //               // add_controller.phone_controller.text = phone.completeNumber;
                  //               print("phone: ${phone.completeNumber}");
                  //               setState(() {
                  //                 whatsappNumber = "${phone.countryCode} ${phone.number}";
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ]
                  //   )
                  // ),

                  // whatsapp number
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: TextFormField(
                      controller: add_controller.whatsapp_controller,
                      keyboardType: TextInputType.phone,
                      maxLength: 15,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            !RegExp(phonePattern).hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            !RegExp(phonePattern).hasMatch(value)) {
                          add_controller.updateWhatsappNumberValidity();
                        } else {
                          add_controller.updateWhatsappNumberValidity();
                        }
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'WhatsApp Number (optional)',
                        counterText: '',
                        suffixIcon: Icon(
                          color: Colors.black,
                          Icons.edit,
                        ),
                      ),
                    ),
                  ),
                  // a text hinting the user the correct format for a whatsapp number
                  Obx(() {
                    if (!add_controller.isValidWhatsappNumber.value) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: const Text(
                          'Please enter your whatsapp number in the format: +237 6XX XXX XXX or +1 123 456 7890',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),

                  Divider(
                    color: appcolor().greyColor,
                    thickness: 1,
                    height: 1,
                    indent: 0,
                  ),

                  // email
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: TextFormField(
                      controller: add_controller.email_controller,
                      keyboardType: TextInputType.emailAddress,
                      onTapOutside: (val) {
                        setState(() {
                          focusInEmailField = false;
                        });
                      },
                      onChanged: (val) {
                        setState(() {
                          focusInEmailField = true;
                        });

                        // if it's a valid email address
                        if (val.contains('@') && val.contains('.')) {
                          add_controller.emailValid.value = true;
                        } else {
                          add_controller.emailValid.value = false;
                        }
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Email Address (optional)',
                        suffixIcon: Icon(
                          color: Colors.black,
                          Icons.edit,
                        ),
                      ),
                    ),
                  ),

                  // show invalid email error
                  focusInEmailField
                      ? Obx(
                          () => add_controller.emailValid.value
                              ? Container()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: const Text(
                                    'Invalid email address',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                        )
                      : Container(),

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
                          town = null;
                        });
                        print("regionCode: $regionCode");
                        add_controller.loadTownsData(regionCode);
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
                    height: 1,
                    indent: 0,
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.only(left: 15, right: 0),
                      child: Icon(FontAwesomeIcons.city,
                          color:
                              regionCode == null ? Colors.grey : Colors.black),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.only(left: 0, right: 15),
                      child: Icon(Icons.arrow_forward_ios_outlined,
                          color:
                              regionCode == null ? Colors.grey : Colors.black),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Obx(() {
                      if (add_controller.isTownsLoading.value) {
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
                            hintText: 'Town (optional)',
                            hintStyle: TextStyle(
                                color: regionCode == null
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                          value: town,
                          onChanged: (value) {
                            setState(() {
                              town = value as int;
                            });
                            print("townId: $town");
                          },
                          items: add_controller.townList.map((e) {
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
                    height: 1,
                    indent: 0,
                  ),

                  // address
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                        hintText: 'Location (optional)',
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

                  SizedBox(
                    height: Get.height * 0.06,
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Opacity(
                opacity: 0.6,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.black87,
                ),
              ),
            if (isLoading)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'We\'re creating your business profile,',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
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
