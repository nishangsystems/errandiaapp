import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:errandia/modal/subcategory.dart';
import 'package:errandia/modal/subcatgeory.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_field/image_field.dart';
import 'package:image_field/linear_progress_indicator_if.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../APi/apidomain & api.dart';
import '../../../AlertDialogBox/alertBoxContent.dart';
import '../../global/Widgets/blockButton.dart';
import 'errand_view.dart';

add_product_cotroller product_controller = Get.put(add_product_cotroller());

imagePickercontroller imageController = Get.put(imagePickercontroller());

class EditErrand2 extends StatefulWidget {
  final data;

  const EditErrand2(
      {super.key,
      this.data});

  @override
  State<EditErrand2> createState() => _EditErrand2();
}

class _EditErrand2 extends State<EditErrand2> {
  late add_product_cotroller product_controller;

  var selectedOption;

  bool ischip1 = false;
  List<bool> ischip2 = [];
  List<int?> selectedFilters = [];
  List<int> selectedFilterss = [];
  List<int> selectedFilters_ = [];
  bool ischip3 = false;
  var like;

  late PopupBox popup;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  dynamic remoteFiles;


  Future<Map<String, dynamic>?> uploadToServer(XFile? file, String errandId,
      {Progress? uploadProgress}) async {

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${apiDomain().domain}/user/errands/$errandId/images'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Field name for each image
          file!.path,
        ),
      );

      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = jsonDecode(responseString);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }


  @override
  void initState() {
    super.initState();
    product_controller = Get.put(add_product_cotroller());
    product_controller.loadCategories();
    // ischip2 = List.filled(
    //   subCetegoryData.Items.length,
    //   false,
    // );

    imageController.imageList.clear();
    imageController.imagePaths.clear();

    for (var image in widget.data['images']) {
      imageController.imageList.add(File(getImagePath(image['image_path'])));
      imageController.imagePaths.add(getImagePath(image['image_path']));
    }
  }

  // convert a list to a string separated by comma
  String listToString(List<int?> list) {
    String result = "";
    for (int i = 0; i < list.length; i++) {
      if (result == "") {
        result = list[i].toString();
      } else {
        result = "$result,${list[i]}";
      }
    }
    return result;
  }

  void updateErrand(BuildContext context) async {
    print("categories listing: ${listToString(selectedFilters)}");
    print("imageList: ${imageController.imageList}");
    if (selectedFilters.isEmpty) {
      alertDialogBox(context, "Error", 'Please select at least one category');
    } else if (imageController.imageList.isEmpty) {
      alertDialogBox(context, "Error", 'Please select at least one image');
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
        'title': widget.data['title'].toString(),
        'description': widget.data['description'].toString(),
        'categories': listToString(selectedFilters).toString(),
        'region_id': widget.data['region']['id'].toString() ?? "",
        'town_id': widget.data['town']['id'].toString() ?? "",
      };

      print("value: $value");

      await ErrandsAPI.createErrand(value, imageController.imagePaths).then((response_) {
        print("response: $response_");
        var response = jsonDecode(response_);
        if (response['status'] == 'success') {
          if (kDebugMode) {
            print("Errand created successfully");
          }
          setState(() {
            isLoading = false;
            imageController.imageList.clear();
            imageController.imagePaths.clear();
            selectedFilters.clear();
          });
          popup = PopupBox(
            title: 'Success',
            description: response['message'],
            type: PopupType.success,
            callback: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => errand_view(),
                ),
                (route) => false,
              );
            },
          );
          popup.showPopup(context);
        } else {
          setState(() {
            isLoading = false;
          });
          alertDialogBox(context, "Error", response['message']);
        }
      }).catchError((error) {
        if (kDebugMode) {
          print("Error creating errand: $error");
        }
        setState(() {
          isLoading = false;
        });
        alertDialogBox(context, "Error", "Failed to create errand");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 8,
        title: Text(
          'New Errand'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff113d6b),
          ),
        ),
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
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xff113d6b),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Text(
                    '2- Upload Photos'.tr,
                    style: TextStyle(
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

                // cover image

                Divider(
                  color: appcolor().greyColor,
                  thickness: 1,
                  height: 1,
                  indent: 0,
                ),

                // multiple image
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.image,
                      ),
                      const Text(
                        '  Upload screenshots of sample(s)of \n   products you are looking for on Errandia',
                        style: TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.edit,
                        color: appcolor().darkBlueColor,
                      ),
                    ],
                  ),
                ),

                // Obx(
                //   () => Container(
                //     height: imageController.imageList.isEmpty ? null : null,
                //     child: imageController.imageList.isEmpty
                //         ? InkWell(
                //             onTap: () {
                //               showDialog(
                //                 context: context,
                //                 builder: (context) {
                //                   return AlertDialog(
                //                     insetPadding: const EdgeInsets.symmetric(
                //                       horizontal: 20,
                //                     ),
                //                     contentPadding: const EdgeInsets.symmetric(
                //                       horizontal: 8,
                //                       vertical: 20,
                //                     ),
                //                     scrollable: true,
                //                     content: Container(
                //                       // height: Get.height * 0.7,
                //                       width: Get.width,
                //                       child: Column(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           Text(
                //                             'Select Images',
                //                             style: TextStyle(
                //                               color: appcolor().mainColor,
                //                               fontSize: 18,
                //                               fontWeight: FontWeight.bold,
                //                             ),
                //                           ),
                //                           SizedBox(
                //                             height: Get.height * 0.05,
                //                           ),
                //                           Column(
                //                             children: [
                //                               blockButton(
                //                                 title: Row(
                //                                   mainAxisAlignment:
                //                                       MainAxisAlignment.center,
                //                                   children: [
                //                                     Icon(
                //                                       FontAwesomeIcons.image,
                //                                       color:
                //                                           appcolor().mainColor,
                //                                       size: 22,
                //                                     ),
                //                                     Text(
                //                                       '  Image Gallery',
                //                                       style: TextStyle(
                //                                           color: appcolor()
                //                                               .mainColor),
                //                                     ),
                //                                   ],
                //                                 ),
                //                                 ontap: () {
                //                                   Get.back();
                //                                   imageController
                //                                       .getmultipleImage();
                //                                 },
                //                                 color: appcolor().greyColor,
                //                               ),
                //                               SizedBox(
                //                                 height: Get.height * 0.015,
                //                               ),
                //                               blockButton(
                //                                 title: Row(
                //                                   mainAxisAlignment:
                //                                       MainAxisAlignment.center,
                //                                   children: [
                //                                     Icon(
                //                                       FontAwesomeIcons.camera,
                //                                       color:
                //                                           appcolor().mainColor,
                //                                       size: 22,
                //                                     ),
                //                                     Text(
                //                                       '  Take Photo',
                //                                       style: TextStyle(
                //                                         color: appcolor()
                //                                             .mainColor,
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                                 ontap: () {
                //                                   Get.back();
                //                                   imageController
                //                                       .getMultipleimagefromCamera();
                //                                 },
                //                                 color: Color(0xfffafafa),
                //                               ),
                //                             ],
                //                           )
                //                         ],
                //                       ).paddingSymmetric(
                //                         horizontal: 10,
                //                         vertical: 10,
                //                       ),
                //                     ),
                //                   );
                //                 },
                //               );
                //             },
                //             child: Container(
                //                 child: Column(
                //               children: [
                //                 Container(
                //                   color: appcolor().greyColor,
                //                   height: Get.height * 0.22,
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.spaceEvenly,
                //                     children: [
                //                       // SizedBox(height: Get.height*0.05,),
                //                       Center(
                //                         child: Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.center,
                //                           children: [
                //                             Icon(
                //                               FontAwesomeIcons.images,
                //                               size: 60,
                //                               color: appcolor().mediumGreyColor,
                //                             ),
                //                             Text(
                //                               '     Browse Images',
                //                               style: TextStyle(
                //                                 color: appcolor().bluetextcolor,
                //                                 fontWeight: FontWeight.w400,
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                       // SizedBox(
                //                       //   height: Get.height * 0.05,
                //                       // ),
                //                       Text(
                //                         'Other variations of the main product image',
                //                         style: TextStyle(
                //                           fontSize: 10,
                //                           color: appcolor().mediumGreyColor,
                //                           fontWeight: FontWeight.w500,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             )),
                //           )
                //         : Container(
                //             padding: EdgeInsets.symmetric(
                //                 horizontal: 10, vertical: 10),
                //             height: Get.height * 0.24,
                //             child: Center(
                //               child: ListView.builder(
                //                 shrinkWrap: true,
                //                 itemCount: imageController.imageList.length,
                //                 scrollDirection: Axis.horizontal,
                //                 itemBuilder: (context, index) {
                //                   return Column(
                //                     children: [
                //                       Container(
                //                         height: Get.height * 0.15,
                //                         width: Get.width * 0.40,
                //                         decoration:
                //                             BoxDecoration(border: Border.all()),
                //                         child: Image(
                //                           image: FileImage(
                //                             File(
                //                               imageController
                //                                   .imageList[index].path
                //                                   .toString(),
                //                             ),
                //                           ),
                //                           fit: BoxFit.fill,
                //                         ),
                //                       ),
                //                       Container(
                //                         child: Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.center,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.end,
                //                           children: [
                //                             InkWell(
                //                               onTap: () {
                //                                 imageController.edit(index);
                //                               },
                //                               child: Container(
                //                                 height: 35,
                //                                 width: Get.width * 0.20,
                //                                 color: Colors.lightGreen,
                //                                 child: const Center(
                //                                   child: Text(
                //                                     'Edit',
                //                                     style: TextStyle(
                //                                       color: Colors.white,
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                             InkWell(
                //                               onTap: () {
                //                                 imageController.removeat(index);
                //                               },
                //                               child: Container(
                //                                 height: 35,
                //                                 width: Get.width * 0.2,
                //                                 color: appcolor().greyColor,
                //                                 child: const Center(
                //                                   child: Text(
                //                                     'Remove',
                //                                     style: TextStyle(),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       )
                //                     ],
                //                   ).paddingSymmetric(horizontal: 5);
                //                 },
                //               ),
                //             ),
                //           ),
                //   ),
                // ),
                //
                // //  image container
                // Obx(
                //   () => Container(
                //     child: imageController.imageList.isEmpty
                //         ? null
                //         : InkWell(
                //             onTap: () {
                //               showDialog(
                //                 context: context,
                //                 builder: (context) {
                //                   return AlertDialog(
                //                     insetPadding: const EdgeInsets.symmetric(
                //                       horizontal: 20,
                //                     ),
                //                     contentPadding: const EdgeInsets.symmetric(
                //                       horizontal: 8,
                //                       vertical: 20,
                //                     ),
                //                     scrollable: true,
                //                     content: Container(
                //                       // height: Get.height * 0.7,
                //                       width: Get.width,
                //                       child: Column(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           Text(
                //                             'Select Images',
                //                             style: TextStyle(
                //                               color: appcolor().mainColor,
                //                               fontSize: 18,
                //                               fontWeight: FontWeight.bold,
                //                             ),
                //                           ),
                //                           SizedBox(
                //                             height: Get.height * 0.05,
                //                           ),
                //                           Column(
                //                             children: [
                //                               blockButton(
                //                                 title: Row(
                //                                   mainAxisAlignment:
                //                                       MainAxisAlignment.center,
                //                                   children: [
                //                                     Icon(
                //                                       FontAwesomeIcons.image,
                //                                       color:
                //                                           appcolor().mainColor,
                //                                       size: 22,
                //                                     ),
                //                                     Text(
                //                                       '  Image Gallery',
                //                                       style: TextStyle(
                //                                           color: appcolor()
                //                                               .mainColor),
                //                                     ),
                //                                   ],
                //                                 ),
                //                                 ontap: () {
                //                                   Get.back();
                //                                   imageController
                //                                       .getmultipleImage();
                //                                 },
                //                                 color: appcolor().greyColor,
                //                               ),
                //                               SizedBox(
                //                                 height: Get.height * 0.015,
                //                               ),
                //                               blockButton(
                //                                 title: Row(
                //                                   mainAxisAlignment:
                //                                       MainAxisAlignment.center,
                //                                   children: [
                //                                     Icon(
                //                                       FontAwesomeIcons.camera,
                //                                       color:
                //                                           appcolor().mainColor,
                //                                       size: 22,
                //                                     ),
                //                                     Text(
                //                                       '  Take Photo',
                //                                       style: TextStyle(
                //                                         color: appcolor()
                //                                             .mainColor,
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                                 ontap: () {
                //                                   Get.back();
                //                                   imageController
                //                                       .getimagefromCamera();
                //                                 },
                //                                 color: Color(0xfffafafa),
                //                               ),
                //                             ],
                //                           )
                //                         ],
                //                       ).paddingSymmetric(
                //                         horizontal: 10,
                //                         vertical: 10,
                //                       ),
                //                     ),
                //                   );
                //                 },
                //               );
                //             },
                //             child: Container(
                //               margin:
                //                   const EdgeInsets.symmetric(horizontal: 15),
                //               decoration: BoxDecoration(
                //                 color: appcolor().skyblueColor,
                //                 borderRadius: BorderRadius.circular(
                //                   10,
                //                 ),
                //               ),
                //               height: Get.height * 0.08,
                //               child: const Row(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Icon(
                //                     Icons.image,
                //                   ),
                //                   Text(
                //                     '   Add more images',
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //   ),
                // ),


                // image field
                // ImageField(
                //     texts: const {
                //       'fieldFormText': 'Upload to server',
                //       'titleText': 'Upload to server'
                //     },
                //     enabledCaption: false,
                //     onSave: (List<ImageAndCaptionModel>? imageAndCaptionList) {
                //       // remoteFiles = imageAndCaptionList;
                //       print("image remote List: ${imageAndCaptionList.}");
                //     }
                // ),

                Divider(
                  color: appcolor().greyColor,
                  thickness: 1,
                  height: 1,
                  indent: 0,
                ),

                // product tags

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: const ListTile(
                    title: Text('Categories '),
                    leading: Icon(
                      FontAwesomeIcons.tags,
                      color: Color.fromARGB(255, 108, 105, 105),
                    ),
                    trailing: Icon(
                      color: Colors.black,
                      Icons.edit,
                    ),
                  ),

                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     border: InputBorder.none,
                  //     prefixIcon: Icon(
                  //       FontAwesomeIcons.tags,
                  //       color: Color.fromARGB(255, 108, 105, 105),
                  //     ),
                  //     hintStyle: TextStyle(
                  //       color: Colors.black,
                  //     ),
                  //     hintText: 'Categories ',
                  //     suffixIcon: Icon(
                  //       color: Colors.black,
                  //       Icons.edit,
                  //     ),
                  //   ),
                  // ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  // height: Get.height * 0.2,
                  child: Obx(() {
                    if (product_controller.isLoadingCategories.isTrue) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (product_controller.categoryList.isEmpty) {
                      return const Center(
                        child: Text('No Categories found'),
                      );
                    } else {
                      return Column(
                        children: [
                          MultiSelectDialogField(
                            checkColor: Colors.white,
                            searchable: true,
                            items: subCategories.Items.map((item) =>
                                MultiSelectItem(
                                    item.id, item.name.toString())).toList(),
                            title: const Text("Select Categories"),
                            selectedColor: appcolor().mainColor,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onConfirm: (selectedList) {
                              // Update your selectedFilters list with the selected categories
                              print("selectedList: $selectedList");

                              setState(() {
                                selectedFilters = selectedList.cast<int>();
                              });
                            },
                          )
                        ],
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

                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    // setState(() {
                    //   isLoading = true;
                    // });
                    // uploadImage(widget.title, widget.description, selectedFilters, widget.street, widget.town, widget.region);
                    //  PanDocumentInfoupload(widget.title, widget.description, selectedFilters, widget.street, widget.town, widget.region);
                    // updateErrand(context);
                    Get.snackbar("Info", "😔 Still working on this feature", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.yellow[200], colorText: Colors.black);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Container(
                      height: Get.height * 0.09,
                      width: Get.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffe0e6ec),
                      ),
                      child: const Center(
                        child: Text(
                          'RUN ERRAND',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey),
                        ),
                      ),
                    ),
                  ),
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
                    'We\'re creating your errand...',
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
    );
  }

  Future<void> PanDocumentInfoupload(
    String title,
    description,
    category,
    streetid,
    townid,
    regionid,
  ) async {
    var file = selectedFilterss[0].toString();
    // Create a MultipartRequest
//print(selectedFilterss);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    for (int i = 1; i < selectedFilterss.length; i++) {
      file = file + "," + selectedFilterss[i].toString();
    }
    print(file);
    var uri = Uri.parse(
        '${apiDomain().domain}errands?title=${title}&description=${description}&categories=$file&image_count=${imageController.imageList.length}');
    var request = http.MultipartRequest("POST", uri)
      ..headers['Authorization'] = 'Bearer $token';
    for (int i = 0; i < imageController.imageList.length; i++) {
      for (var image in imageController.imageList) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image_${i + 1}', // Field name for each image
            image.path,
          ),
        );
      }
    }

    // request.fields['title'] =  '$title';
    //   request.fields['description'] =  '$description';
    //   request.fields['categories'] =  '$category';
    //   request.fields['street'] =  '$streetid';
    //   request.fields['town'] =  '$townid';
    //   request.fields['region'] =  '$regionid';
    // Send the request
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        Get.offAll(() => errand_view());
        setState(() {
          isLoading = false;
          imageController.imageList.clear();
        });
        // Handle the API response here
      } else {
        print('Failed to upload images. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
    //
    // try {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var token = prefs.getString('token');
    //   var uri = Uri.parse('${apiDomain().domain}errands'); // Replace with your server's endpoint
    //
    //   var request = http.MultipartRequest("POST", uri)
    //     ..headers['Authorization'] = 'Bearer $token';
    //   // Add images to the request
    //
    //   if (imageController.imageList != null) {
    //     request.files.add(await http.MultipartFile.fromPath('image_count', imageController.imageList));
    //   }
    //
    //   request.fields['title'] =  '$title';
    //   request.fields['description'] =  '$description';
    //   request.fields['categories'] =  '$category';
    //   request.fields['street'] =  '$streetid';
    //   request.fields['town'] =  '$townid';
    //   request.fields['region'] =  '$regionid';
    //
    //
    //   var response = await request.send();
    //   if (response.statusCode == 200) {
    //     final res = await http.Response.fromStream(response);
    //     var rest = jsonDecode(res.body);
    //     if (rest['status'] == true) {
    //       setState(() {
    //
    //       });
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${rest['message']}')));
    //     } else {
    //       alertBoxdialogBox(context, 'Alert', '${rest['message']}');
    //     }
    //   }else {
    //     print("Failed to upload images. Status code: ${response.statusCode}");
    //   }
    // } catch (e) {
    //   print("Error: $e");
    // }
  }
}
