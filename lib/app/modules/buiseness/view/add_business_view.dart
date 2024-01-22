import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
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

business_controller controller = Get.put(business_controller());
add_business_controller add_controller = Get.put(add_business_controller());
imagePickercontroller imageController = Get.put(imagePickercontroller());

class add_business_view extends StatefulWidget {
  add_business_view({super.key});

  @override
  State<add_business_view> createState() => _add_business_viewState();
}

class _add_business_viewState extends State<add_business_view> {
  var country;
  var value = null;
  var regionCode;
  bool isLoading = false;
  List<String> selectedFilters = [];
  List<int> selectedFilterss = [];
  var town;
  Future<void> PanDocumentInfoupload(String title, description, websiteAddress,address,facebook,instagream,twitter,bussinessinfo) async {
    // var file;
    // // Create a MultipartRequest
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString('token');
    // var uri = Uri.parse('${apiDomain().domain}errands?image_count=${imageController.imageList.length}');
    // var request = http.MultipartRequest("POST", uri)
    //   ..headers['Authorization'] = 'Bearer $token';
    // for (int i =0; i < imageController.imageList.length; i++) {
    //   for (var image in imageController.imageList) {
    //     request.files.add(
    //       await http.MultipartFile.fromPath(
    //         'image_${i + 1}', // Field name for each image
    //         image.path,
    //       ),
    //     );
    //   }
    // }
    //
    // request.fields['title'] =  '$title';
    // request.fields['description'] =  '$description';
    // request.fields['categories'] =  '$category';
    // request.fields['street'] =  '$streetid';
    // request.fields['town'] =  '$townid';
    // request.fields['region'] =  '$regionid';
    // // Send the request
    // try {
    //   var response = await request.send();
    //   if (response.statusCode == 200) {
    //     Get.offAll(errand_view());
    //     setState(() {
    //       isLoading = false;
    //       imageController.imageList.clear();
    //     });
    //     // Handle the API response here
    //   } else {
    //     print('Failed to upload images. Status code: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   print('Error uploading images: $e');
    // }
    //
    var file = selectedFilterss[0].toString();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      for(int i = 1; i < selectedFilterss.length; i++){
        file = file +","+ selectedFilterss[i].toString();
      }
      print(file);
      var uri = Uri.parse('${apiDomain().domain}shops?name=$title}&description=$description &is_branch=${controller.headmainSwitch.value}&parent_slug&slogan=$bussinessinfo &street_id=${country}&phone&whatsapp=whatsapp&address=${address}&facebook=${facebook}&instagram=$instagream&website=$websiteAddress&email&categories=${file}'); // Replace with your server's endpoint

      var request = http.MultipartRequest("POST", uri)
        ..headers['Authorization'] = 'Bearer $token';
      // Add images to the request

      if (imageController.image_path.toString() != '') {
        request.files.add(await http.MultipartFile.fromPath('image', imageController.image_path.toString()));
      }
      // request.fields['name'] =  '$title';
      // request.fields['description'] =  '$description';
      // request.fields['categories'] =  '$selectedFilters';
      // request.fields['street_id'] =  '$country';
      // request.fields['town'] =  '$townid';
      // request.fields['region'] =  '$regionid';
      // request.fields['address'] =  '$streetid';
      // request.fields['facebook'] =  '$townid';
      // request.fields['instagram'] =  '$regionid';
      // request.fields['website'] =  '$twitter';
      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var rest = jsonDecode(res.body);
        setState(() {
          isLoading = false;
        });
        Get.offAll(manage_business_view());
        add_controller.company_name_controller.clear();
        add_controller.Business_information_controller.clear();
        add_controller.website_address_controller.clear();
        add_controller.address_controller.clear();
        add_controller.facebook_controller.clear();
        add_controller.instagram_controller.clear();
        add_controller.twitter_controller.clear();
       // imageController.image_path.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${rest['data']['message']}')));

      }else {
       // alertBoxdialogBox(context, 'Alert', 'P')
        print("Failed to upload images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 8,
        title: Text('Add Business'),
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
          color: appcolor().greyColor,
        ),
        actions: [
          TextButton(
              onPressed: () {
                var name = add_controller.company_name_controller.text.toString();
                var descripton = add_controller.Business_information_controller.text.toString();
                var websiteAddress = add_controller.website_address_controller.text.toString();
                var address = add_controller.address_controller.text.toString();
                var facebook = add_controller.facebook_controller.text.toString();
                var instagram = add_controller.instagram_controller.text.toString();
                var twitter = add_controller.twitter_controller.text.toString();
                var bussinessInfo = add_controller.Business_information_controller.text.toString();

                if(name =='' || descripton ==''|| country == null){
                  alertDialogBox(context, "Alert", 'Please Enter Fields');
                }else{
                  setState(() {
                    isLoading = true;
                  });
                  PanDocumentInfoupload(name, descripton, websiteAddress, address, facebook, instagram,twitter,bussinessInfo);
                }
              },
              child:isLoading == false? Text(
                'Publish',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ):SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(color:Colors.blue,))
          )
        ],
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
                'Company Details'.tr,
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

            // company name
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                controller: add_controller.company_name_controller,
                decoration: InputDecoration(
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

            // Business categories
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                readOnly: true,
                controller: add_controller.Business_category_controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    color: Colors.black,
                    Icons.category,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Business Categories *',
                  suffixIcon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            subCetegoryData.Items !=null && subCetegoryData.Items.isNotEmpty?
            Container(
              height: 70,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: subCetegoryData.Items.length,
                  itemBuilder: (context, index){
                    var data = subCetegoryData.Items[index];
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
                                    selectedFilterss.add(int.parse(data.id.toString()));
                                  } else if(!value){
                                    selectedFilters.remove(data.name.toString());
                                    selectedFilterss.remove(int.parse(data.id.toString()));
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

            // Business info
            Container(
              height: Get.height * 0.2,
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                controller: add_controller.Business_information_controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
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
              () => Container(
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
                                                  .getImagefromgallery();
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Row(
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
                    : Container(
                        height: Get.height * 0.15,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.image),
                                Text(
                                  '  Company Logo *',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {},
                                  child: Icon(
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
                                Container(
                                  height: Get.height * 0.19,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          imageController.getImagefromgallery();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 60,
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
                                          imageController.reset();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 60,
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
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: TextFormField(
                controller: add_controller.website_address_controller,
                decoration: InputDecoration(
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
            // shop head
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Row(
                children: [
                  Text(
                    'Shop Head/Main Office *',
                    style: TextStyle(fontSize: 15),
                  ),
                  Spacer(),
                  Obx(
                    () => SizedBox(
                      width: Get.width * 0.2,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: controller.headmainSwitch.value,
                          onChanged: (val) {
                            controller.headmainSwitch.value = val;
                          },
                        ),
                      ),
                    ),
                  ),
                  Text('Active')
                ],
              ),
            ),
            Divider(
              color: appcolor().greyColor,
              thickness: 1,
              height: 1,
              indent: 0,
            ),

            //Business Location
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Text(
                'Business Location'.tr,
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

            // country


            ListTile(
              leading:Icon(
                FontAwesomeIcons.earthAmericas,
              ),

                trailing:   Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(right: 10,bottom: 10),
                  child: DropdownButtonFormField(
                    iconSize: 0.0,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Region',
                    ),
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        regionCode = value as int;
                      });
                    },
                    items:Regions.Items.map((e)=>DropdownMenuItem(child: Text(e.name.toString(),style: TextStyle(fontSize: 11),),value: e.id,)).toList(),
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
              leading:
              Icon(
                FontAwesomeIcons.locationCrosshairs,
              ),

                trailing:   Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(right: 10,bottom: 10),
                  child: DropdownButtonFormField(
                    iconSize: 0.0,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Town',

                    ),
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        town = value as int;
                      });
                    },
                    items:Towns.Items.map((e)=>DropdownMenuItem(child: Text(e.name.toString(),style: TextStyle(fontSize: 11),),value: e.id,)).toList(),
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
              leading: Icon(FontAwesomeIcons.locationArrow),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              title: Padding(
                padding: const EdgeInsets.only(right: 10,bottom: 10),
                child: DropdownButtonFormField(
                  iconSize: 0.0,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Street'
                  ),
                  value: value,
                  onChanged: (value) {
                    setState(() {
                      country = value as int;
                    });
                  },
                  items:Street.Items .map((e)=>DropdownMenuItem(child: Text(e.name.toString(),style: TextStyle(fontSize: 11),),value: e.id,)).toList(),
                ),
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
              height: Get.height * 0.2,
              // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: TextFormField(
                controller: add_controller.address_controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    color: Colors.black,
                    FontAwesomeIcons.mapLocationDot,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: 'Address *',
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
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Text(
                'Social Links'.tr,
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

            //facebook
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                controller: add_controller.facebook_controller,
                decoration: InputDecoration(
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
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                controller: add_controller.instagram_controller,
                decoration: InputDecoration(
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
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TextFormField(
                controller: add_controller.twitter_controller,
                decoration: InputDecoration(
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
    return Container(
      height: Get.height * 0.27,
      child: ListView.builder(
        itemCount: add_controller.managerList.length,
        itemBuilder: (context, index) => Row(
          children: [
            Text(add_controller.managerList[index]),
            Spacer(),
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
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      scrollable: true,
      content: Container(
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
            Text(
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
                  color: Color(0xffe0e6ec),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: TextFormField(
                    controller:
                        add_controller.add_manager_first_name_controller,
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
            ),

            Text(
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
                  color: Color(0xffe0e6ec),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: TextFormField(
                    controller: add_controller.add_manager_last_name_controller,
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: Get.height * 0.02,
            ),

            //  phone number
            Text(
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
                  color: Color(0xffe0e6ec),
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
                        color: Color(0xffe0e6ec),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image(
                        image: AssetImage(
                          'assets/images/flag_icon.png',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.2,
                    child: Center(
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
                      padding: EdgeInsets.only(top: 1),
                      child: TextFormField(
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
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
              title: Text(
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
                    add_controller.add_manager_last_name_controller.text.toString();
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
