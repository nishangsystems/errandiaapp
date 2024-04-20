import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/Widgets/bottomsheet_item.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  home_controller homeController = Get.put(home_controller());

  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> userData = {};
  late String userProfileImage = "";

  bool isLoading = false;
  bool isImageUpload = false;

  SharedPreferences? prefs;

  // get user from shared preferences
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user');
    String? userProfileImg = prefs.getString('userProfileImg');
    if (userDataString != null) {
      print("user data: $userDataString");
      setState(() {
        userData = jsonDecode(userDataString);
        userData['photo'] =
            userProfileImg == null || userProfileImg.toString() == ""
                ? null
                : getImagePath(userProfileImg);
      });
      profileController.fullNameController.text = userData['name'];
      profileController.emailController.text = userData['email'];
      profileController.phoneController.text = userData['phone'];
      profileController.whatsappController.text =
          userData['whatsapp_number'] ?? "";
      // var url = userData['photo'].substring(1);
      // // remove any trailing quotes from url
      // url = url.replaceAll('"', '');
      // imageController.image_path.value = getImagePath(userProfileImage);
      // imageController.image_path.value = userData['photo'];
      print("userData photo: ${userData['photo']}");
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
      body: Stack(children: [
        SingleChildScrollView(
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
                    Container(
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
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Obx(() => imageController.image_path.value == ""
                            ? (userData['photo'] != null
                                ? Image.network(
                                    userData['photo'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Image(
                                        image: AssetImage(
                                            'assets/images/profilePlaceholder.png'),
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : const Image(
                                    image: AssetImage(
                                        'assets/images/profilePlaceholder.png'),
                                    fit: BoxFit.cover,
                                  ))
                            : Image.file(
                                File(imageController.image_path.value),
                                fit: BoxFit.cover,
                              )),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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

              // full name
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: TextFormField(
                    controller: profileController.fullNameController,
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
                                    onTap: () {},
                                    child: IconButton(
                                      onPressed: () {
                                        if (kDebugMode) {
                                          print(
                                              "edit full name ${profileController.fullNameController.text}");
                                        }
                                        var value = {
                                          "field_name": "name",
                                          "field_value": profileController
                                              .fullNameController.text
                                        };

                                        setState(() {
                                          isLoading = true;
                                        });
                                        print("loading: $isLoading");

                                        api()
                                            .updateProfile(
                                                value, context, navigator)
                                            .then((data) {
                                          print("response: ${data['message']}");

                                          PopupBox popupBox = PopupBox(
                                            title: 'Success',
                                            description: '${data['message']}',
                                            type: PopupType.success,
                                          );

                                          // 3 seconds delay
                                          Future.delayed(
                                              const Duration(seconds: 3), () {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });

                                          popupBox.showPopup(context);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.save_sharp,
                                        color: Color(0xff113d6b),
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ))),
                    onChanged: (value) {
                      if (kDebugMode) {
                        print(
                            "field length: ${profileController.fullNameController.text.length}");
                      }
                      if (value.length >= 3) {
                        profileController.fullNameController.text = value;
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: profileController.emailController,
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
                        print(
                            "field length: ${profileController.emailController.text.length}");
                      }
                      if (profileController.isEmail(value)) {
                        profileController.emailController.text = value;
                        setState(() {
                          profileController.isEmailValid.value = true;
                        });
                      } else {
                        setState(() {
                          profileController.isEmailValid.value = false;
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: TextFormField(
                    maxLength: 15,
                    maxLines: 1,
                    keyboardType: TextInputType.phone,
                    controller: profileController.whatsappController,
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
                      hintText: 'WhatsApp Number',
                      suffixIcon:
                          Obx(() => profileController.isValidWhatsappNumber.value
                              ? InkWell(
                                  onTap: () {},
                                  child: IconButton(
                                    onPressed: () {
                                      if (kDebugMode) {
                                        print(
                                            "edit whatsapp ${profileController.whatsappController.text}");
                                      }
                                      var value = {
                                        "field_name": "whatsapp_number",
                                        "field_value": profileController
                                            .whatsappController.text
                                      };

                                      setState(() {
                                        isLoading = true;
                                      });

                                      api()
                                          .updateProfile(
                                              value, context, navigator)
                                          .then((data) {
                                        print("response: ${data['message']}");

                                        PopupBox popupBox = PopupBox(
                                          title: 'Success',
                                          description: '${data['message']}',
                                          type: PopupType.success,
                                        );

                                        // 3 seconds delay
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });

                                        popupBox.showPopup(context);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save_sharp,
                                      color: Color(0xff113d6b),
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                )),
                    ),
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          !RegExp(phonePattern).hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      profileController.isWhatsappValid.value = true;
                      return null;
                    },
                    onChanged: (value) {
                      if (kDebugMode) {
                        print(
                            "field length: ${profileController.whatsappController.text.length}");
                      }
                      if (value.isNotEmpty &&
                          !RegExp(phonePattern).hasMatch(value)) {
                        // profileController.whatsappController.text = value;
                        profileController.updateWhatsappNumberValidity();

                        profileController.isWhatsappValid.value = true;
                      } else {
                        profileController.updateWhatsappNumberValidity();

                        profileController.isWhatsappValid.value = false;
                      }
                    }),
              ),
              Obx(() {
                if (!profileController.isValidWhatsappNumber.value) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.phone,
                    maxLength: 9,
                    maxLines: 1,
                    controller: profileController.phoneController,
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
                        print(
                            "field length: ${profileController.phoneController.text.length}");
                      }
                      if (value.length == 9) {
                        // profileController.whatsappController.text = value;
                        setState(() {
                          profileController.isPhoneValid.value = true;
                        });
                      } else {
                        setState(() {
                          profileController.isPhoneValid.value = false;
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
            ],
          ),
        ),
        if (isLoading)
          const Opacity(
            opacity: 0.4,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (isLoading)
          Center(
            child: !isImageUpload
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Uploading Image...',
                        style: TextStyle(
                          color: appcolor().bluetextcolor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
          ),
      ]),
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
                  ontap: () async {
                    Get.back();
                    File? file = await imageController.getImageFromGallery();
                    if (file != null) {
                      print("Selected image path: ${file.path}");

                      imageController.update();

                      setState(() {
                        isLoading = true;
                        isImageUpload = true;
                      });

                      api().uploadProfileImage(file, context).then((response) {
                        print("Upload response: $response");
                        // Handle the response as needed

                        if (response['image_path'] != '') {
                          homeController.reloadRecentlyPostedItems();
                          PopupBox popupBox = PopupBox(
                            title: 'Success',
                            description: 'Profile Image Updated',
                            type: PopupType.success,
                          );

                          // 3 seconds delay
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              isLoading = false;
                              isImageUpload = false;
                            });
                          });

                          popupBox.showPopup(context);
                        } else {
                          PopupBox popupBox = PopupBox(
                            title: 'Error',
                            description: 'Sorry, something went wrong',
                            type: PopupType.error,
                          );

                          // 3 seconds delay
                          Future.delayed(const Duration(seconds: 3), () {
                            setState(() {
                              isLoading = false;
                              isImageUpload = false;
                            });
                          });

                          popupBox.showPopup(context);
                        }
                      });
                    } else {
                      print("No image selected.");
                    }
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
                  ontap: () async {
                    Get.back();
                    var path = await imageController.getimagefromCamera();
                    print("photo path: ${path}");

                    if (path != null) {
                      File? file = File(path);

                      print("Original file size: ${file.lengthSync()}");

                      try {
                        file = (await compressFile(file: file));
                        print("Compressed file size: ${file.lengthSync()}");
                      } catch (e) {
                        print("Error compressing file: $e");
                      }

                      print("Selected image path: ${file?.path}");

                      imageController.update();

                      setState(() {
                        isLoading = true;
                        isImageUpload = true;
                      });

                      api().uploadProfileImage(file, context).then(
                        (response) {
                          print("Upload response: $response");
                          // Handle the response as needed

                          if (response['image_path'] != '') {
                            PopupBox popupBox = PopupBox(
                              title: 'Success',
                              description: 'Profile Image Updated',
                              type: PopupType.success,
                            );

                            // 3 seconds delay
                            Future.delayed(const Duration(seconds: 3), () {
                              setState(() {
                                isLoading = false;
                                isImageUpload = false;
                              });
                            });

                            popupBox.showPopup(context);
                          } else {
                            PopupBox popupBox = PopupBox(
                              title: 'Error',
                              description: 'Sorry, something went wrong',
                              type: PopupType.error,
                            );

                            // 3 seconds delay
                            Future.delayed(const Duration(seconds: 3), () {
                              setState(() {
                                isLoading = false;
                                isImageUpload = false;
                              });
                            });

                            popupBox.showPopup(context);
                          }
                        },
                      ).catchError((error) {
                        print("Error: $error");
                        PopupBox popupBox = PopupBox(
                          title: 'Error',
                          description: 'Sorry, something went wrong',
                          type: PopupType.error,
                        );

                        // 3 seconds delay
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            isLoading = false;
                            isImageUpload = false;
                          });
                        });

                        popupBox.showPopup(context);
                      });
                    } else {
                      print("No image selected.");
                    }
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
