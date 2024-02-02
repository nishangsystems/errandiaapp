import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/bottomsheet_item.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class edit_profile_view extends StatefulWidget {
  const edit_profile_view({Key? key}) : super(key: key);

  @override
  State<edit_profile_view> createState() => edit_profile_viewState();
}

class edit_profile_viewState extends State<edit_profile_view> {
  imagePickercontroller imageController = Get.put(imagePickercontroller());
  profile_controller profileController = Get.put(profile_controller());

  final TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> userData = {};

  SharedPreferences? prefs;

  // get user from shared preferences
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user');
    if (userDataString != null) {
      print("user data: $userDataString");
      setState(() {
        userData = jsonDecode(userDataString);
      });
      fullNameController.text = userData['name'];
      emailController.text = userData['email'];
      phoneController.text = userData['phone'];
      whatsappController.text = userData['whatsapp'];
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {

    if (kDebugMode) {
      print("user: ${userData.toString}");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: appcolor().mediumGreyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: appcolor().mediumGreyColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: const [
          // TextButton(
          //   onPressed: () {},
          //   child: const Text(
          //     'UPDATE',
          //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image container
            Container(
              height: Get.height * 0.26,
              width: Get.width,
              decoration: BoxDecoration(
                color: appcolor().mainColor,
              ),
              margin: const EdgeInsets.only(bottom: 15),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Obx(
                    () => imageController.image_path.value == ""
                        ? Container(
                            height: Get.height * 0.15,
                            width: Get.width * 0.30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 0.00,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 15,
                                  offset: Offset(10, 15),
                                ),
                              ],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                              color: Colors.grey,
                              image: userData['profile'] != null ? DecorationImage(
                                image: NetworkImage(
                                  userData['profile'] ?? "",
                                ),
                                fit: BoxFit.fill,
                              ) : const DecorationImage(
                                image: AssetImage(
                                  'assets/images/profilePlaceholder.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : Container(
                            height: Get.height * 0.23,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                image: FileImage(
                                  File(
                                    imageController.image_path.value,
                                  ),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                      bottom: 30,
                      right: Get.width * 0.33,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: appcolor().darkBlueColor,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white,
                            width: 0.2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.white,
                                child: Wrap(
                                  children: [
                                    const Center(
                                      child: Icon(
                                        Icons.horizontal_rule,
                                        size: 25,
                                      ),
                                    ),
                                    bottomSheetWidgetitem(
                                      title: 'Edit Image',
                                      imagepath:
                                          'assets/images/sidebar_icon/icon-edit.png',
                                      callback: () {
                                        Get.back();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return customDialogBox();
                                          },
                                        );
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                        imageController.reset();
                                      },
                                      child: const Row(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                            child: Icon(
                                              Icons.image,
                                              size: 30,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 18,
                                          ),
                                          Text(
                                            'Remove Photo',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ).paddingSymmetric(vertical: 15),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.camera_alt_sharp,
                            color: appcolor().iconcolor,
                            size: 20,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            // Divider(
            //   color: appcolor().greyColor,
            //   thickness: 1,
            //   height: 1,
            //   indent: 0,
            // ),
            // first name
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: TextFormField(
                controller: fullNameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        FontAwesomeIcons.user,
                        color: Colors.black,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      hintText: 'Full Name ',
                      suffixIcon:
                          Obx(() => profileController.isFullNameValid.value
                              ? InkWell(
                                  onTap: () {
                                    // firstNameController.clear();
                                    // setState(() {
                                    //   profileController.isFirstNameValid.value =
                                    //       false;
                                    // });
                                    print(
                                        "fullName: ${fullNameController.text}");
                                  },
                                  child: const Icon(
                                    Icons.save_sharp,
                                    color: Color(0xff113d6b),
                                  ),
                                )
                              : const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ))),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print("field length: ${fullNameController.text.length}");
                    }
                    if (value.length >= 3) {
                      fullNameController.text = value;
                      setState(() {
                        profileController.isFullNameValid.value = true;
                      });
                    } else {
                      setState(() {
                        profileController.isFullNameValid.value = false;
                      });
                    }
                  }),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            // email
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  hintText: 'Email',
                  suffixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                ),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print("field length: ${emailController.text.length}");
                    }
                    if (profileController.isEmail(value)) {
                      emailController.text = value;
                      setState(() {
                        profileController.isEmailValid.value = true;
                      });
                    } else {
                      setState(() {
                        profileController.isEmailValid.value = false;
                      });
                    }
                  }
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // Divider(
            //   color: appcolor().greyColor,
            //   thickness: 1,
            //   height: 1,
            //   indent: 0,
            // ),

            // whatsapp number
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                maxLength: 9,
                maxLines: 1,
                keyboardType: TextInputType.phone,
                controller: whatsappController,
                decoration: InputDecoration(
                  counter: const Offstage(),
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.black,
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'WhatsApp Number *',
                  suffixIcon:
                  Obx(() => profileController.isWhatsappValid.value
                      ? InkWell(
                    onTap: () {
                      // firstNameController.clear();
                      // setState(() {
                      //   profileController.isFirstNameValid.value =
                      //       false;
                      // });
                      print("whatsapp: ${whatsappController.text}");
                    },
                    child: const Icon(
                      Icons.save_sharp,
                      color: Color(0xff113d6b),
                    ),
                  )
                      : const Icon(
                    Icons.edit,
                    color: Colors.black,
                  )),
                ),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print("field length: ${whatsappController.text.length}");
                    }
                    if (value.length == 9) {
                      whatsappController.text = value;
                      setState(() {
                        profileController.isWhatsappValid.value = true;
                      });
                    } else {
                      setState(() {
                        profileController.isWhatsappValid.value = false;
                      });
                    }
                  }
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                enabled: false,
                keyboardType: TextInputType.phone,
                maxLength: 9,
                maxLines: 1,
                controller: phoneController,
                decoration: const InputDecoration(
                  counter: Offstage(),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.call,
                    color: Colors.grey,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  hintText: '6xx xxx xxx',
                  suffixIcon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                ),
                  onChanged: (value) {
                    if (kDebugMode) {
                      print("field length: ${phoneController.text.length}");
                    }
                    if (value.length == 9) {
                      whatsappController.text = value;
                      setState(() {
                        profileController.isPhoneValid.value = true;
                      });
                    } else {
                      setState(() {
                        profileController.isPhoneValid.value = false;
                      });
                    }
                  }
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget customDialogBox() {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 20,
      ),
      scrollable: true,
      content: Container(
        // height: Get.height * 0.7,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Images',
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.image,
                        color: appcolor().mainColor,
                        size: 22,
                      ),
                      Text(
                        '  Image Gallery',
                        style: TextStyle(color: appcolor().mainColor),
                      ),
                    ],
                  ),
                  ontap: () {
                    Get.back();
                    imageController.getImagefromgallery();
                  },
                  color: appcolor().greyColor,
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                blockButton(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    imageController.getimagefromCamera();
                  },
                  color: const Color(0xfffafafa),
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
  }
}
