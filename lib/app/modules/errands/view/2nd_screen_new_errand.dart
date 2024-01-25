import 'dart:convert';
import 'dart:io';
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:errandia/modal/category.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../modal/Street.dart';
import '../../../APi/apidomain & api.dart';
import '../../../AlertDialogBox/alertBoxContent.dart';
import '../../buiseness/controller/add_business_controller.dart';
import '../../global/Widgets/blockButton.dart';
import 'Product/serivces.dart';
import 'package:errandia/modal/subcatgeory.dart';

import 'errand_view.dart';

add_product_cotroller product_controller = Get.put(add_product_cotroller());

imagePickercontroller imageController = Get.put(imagePickercontroller());

class nd_screen extends StatefulWidget {
  final title;
  final description;
  final region;
  final town;
  final street;
  nd_screen({super.key, this.title, this.description, this.region, this.town, this.street});

  @override
  State<nd_screen> createState() => _nd_screenState();
}

class _nd_screenState extends State<nd_screen> {
var selectedOption ;
bool ischip1 = false;
List<bool> ischip2 = [];
List<String> selectedFilters = [];
List<int> selectedFilterss = [];
bool ischip3= false;
var like ;
bool isLoading = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    ischip2 = List.filled(subCetegoryData.Items.length, false,);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 8,
        title: Text('New Errand'.tr, style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff113d6b),
        ),),
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
      body: SingleChildScrollView(
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
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.image,
                  ),
                  Text(
                    '  Upload screenshots of sample(s)of \n   products you are looking for on Errandia',
                    style: TextStyle(fontSize: 12),
                  ),
                  Spacer(),
                  Icon(Icons.edit,color: appcolor().darkBlueColor,),
                ],
              ),
            ),

            Obx(
                  () => Container(
                   height: imageController.imageList.isEmpty ? null : null,
                    child: imageController.imageList.isEmpty
                    ? InkWell(
                      onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 20,
                          ),
                          scrollable: true,
                          content: Container(
                            // height: Get.height * 0.7,
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                                            .getmultipleImage();
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
                                            .getMultipleimagefromCamera();
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
                      child: Column(
                        children: [
                          Container(
                            color: appcolor().greyColor,
                            height: Get.height * 0.22,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                // SizedBox(height: Get.height*0.05,),
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.images,
                                        size: 60,
                                        color: appcolor().mediumGreyColor,
                                      ),
                                      Text(
                                        '     Browse Images',
                                        style: TextStyle(
                                          color: appcolor().bluetextcolor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //   height: Get.height * 0.05,
                                // ),
                                Text(
                                  'Other variations of the main product image',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: appcolor().mediumGreyColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                )
                    : Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: Get.height * 0.24,
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: imageController.imageList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: Get.height * 0.15,
                              width: Get.width * 0.40,
                              decoration:
                              BoxDecoration(border: Border.all()),
                              child: Image(
                                image: FileImage(
                                  File(
                                    imageController.imageList[index].path
                                        .toString(),
                                  ),
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      imageController.edit(index);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: Get.width * 0.20,
                                      color: Colors.lightGreen,
                                      child: Center(
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
                                      imageController.removeat(index);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: Get.width * 0.2,
                                      color: appcolor().greyColor,
                                      child: Center(
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
                        ).paddingSymmetric(horizontal: 5);
                      },
                    ),
                  ),
                ),
              ),
            ),

            //  image container
            Obx(
                  () => Container(
                child: imageController.imageList.isEmpty
                    ? null
                    : InkWell(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 20,
                          ),
                          scrollable: true,
                          content: Container(
                            // height: Get.height * 0.7,
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                                            .getmultipleImage();
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
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: appcolor().skyblueColor,
                      borderRadius: BorderRadius.circular(10,),
                    ),
                    height: Get.height * 0.08,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                        ),
                        Text(
                          '   Add more images',
                        ),
                      ],
                    ),
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

            // product tags


            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child:ListTile(
                title: Text('Categories '),
                leading:  Icon(
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

            subCetegoryData.Items !=null && subCetegoryData.Items .isNotEmpty?
            Container(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: subCetegoryData.Items .length,
                  itemBuilder: (context, index){
                    var data = subCetegoryData.Items [index];
                    return  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        child: Wrap(
                          direction: Axis.vertical,
                          spacing: 20.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          children: <Widget>[
                            InputChip(
                              label: Text('${data.name}'),
                              selectedColor: Colors.green,
                              selected: selectedFilters.contains(data.name),
                              onSelected: ( value) {
                                setState(() {
                                  if (value) {
                                    selectedFilters.add(data.name.toString());
                                    selectedFilterss.add(int.parse('${index + 1}'));
                                  } else if(!value){
                                    selectedFilters.remove(data.name.toString());
                                  }
                                });
                              },
                            ),
                          ],
                        ),

                      ),
                    );
                  }),
            ):Center(child: CircularProgressIndicator()),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: InkWell(
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context){
                        return Container(
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Should Errand be visible?',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontSize: 20),),
                                SizedBox(height: 20,),
                                ListTile(
                                  title: const Text('Yes, Publish on Errandia to everyone'),
                                  leading: Radio(
                                    value: 1,
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                        like = 'Yes, Publish on Errandia to everyone';
                                        Get.back();
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 10,),
                                ListTile(
                                  title: const Text('Do not Publish(send only to bussiness)'),
                                  leading: Radio(
                                    value: 2,
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      selectedOption = value!;
                                      like = 'Do not Publish(send only to bussiness)';
                                      Get.back();
                                    },
                                  ),
                                ),
                                SizedBox(height: 10,),
                                ListTile(
                                  title: const Text('Yes,but publish as Anonymous)'),
                                  leading: Radio(
                                    value: 3,
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = value!;
                                        like = 'Yes,but publish as Anonymous';
                                        Get.back();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                child:ListTile(
                  title: Text('${like == null?'Would you like to make your Errand visible to the public? ':like}',style: TextStyle(fontSize: 14),),
                  leading: Icon(
                    FontAwesomeIcons.eyeSlash,
                    color: Color.fromARGB(255, 108, 105, 105),
                  ),
                  trailing: Icon(
                    color: Colors.black,
                    Icons.edit,
                  ),
                )

                // TextFormField(
                //   readOnly: true,
                //   decoration: InputDecoration(
                //     border: InputBorder.none,
                //     prefixIcon: Icon(
                //       FontAwesomeIcons.eyeSlash,
                //       color: Color.fromARGB(255, 108, 105, 105),
                //     ),
                //     hintStyle: TextStyle(
                //       color: Colors.black,
                //     ),
                //     hintText: 'Would you like to make your Errand \nvisible to the public? ',
                //     suffixIcon: Icon(
                //       color: Colors.black,
                //       Icons.edit,
                //     ),
                //   ),
                // ),
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),
            SizedBox(height: 70,),
            InkWell(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
               // uploadImage(widget.title, widget.description, selectedFilters, widget.street, widget.town, widget.region);
                PanDocumentInfoupload(widget.title, widget.description, selectedFilters, widget.street, widget.town, widget.region);


              },
              child: isLoading == false?Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                child: Container(
                  height: Get.height * 0.09,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffe0e6ec),
                  ),
                  child: Center(
                    child: Text(
                      'RUN ERRAND',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey),
                    ),
                  ),
                ),
              ):Center(child: CircularProgressIndicator(),),
            ),
          ],
        ),
      ),
    );
  }
Future<void> PanDocumentInfoupload(String title, description, category,streetid,townid,regionid,) async {
var file = selectedFilterss[0].toString();
  // Create a MultipartRequest
//print(selectedFilterss);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
  for(int i = 1;i<selectedFilterss.length; i++){
      file = file +","+ selectedFilterss[i].toString();
  }
  print(file);
  var uri = Uri.parse('${apiDomain().domain}errands?title=${title}&description=${description}&categories=$file&image_count=${imageController.imageList.length}');
  var request = http.MultipartRequest("POST", uri)
      ..headers['Authorization'] = 'Bearer $token';
for (int i =0; i < imageController.imageList.length; i++) {
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




