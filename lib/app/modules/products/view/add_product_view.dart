import 'dart:convert';
import 'dart:io';
import 'package:errandia/app/modules/profile/view/profile_view.dart';
import 'package:errandia/modal/Shop.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart'as http;
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:path/path.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/products/controller/add_product_controller.dart';
import 'package:errandia/modal/subcatgeory.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../../APi/apidomain & api.dart';
import '../../buiseness/controller/add_business_controller.dart';
import '../../buiseness/view/manage_business_view.dart';
import '../../global/Widgets/blockButton.dart';


imagePickercontroller imageController = Get.put(imagePickercontroller());

class add_product_view extends StatefulWidget {
  final Shop shop;
  add_product_view({super.key, required this.shop});

  @override
  State<add_product_view> createState() => _add_product_viewState();
}

class _add_product_viewState extends State<add_product_view> {
  late add_product_cotroller product_controller;

  List<String> selectedFilters = [];
  List<int> selectedFilters_ = [];
  bool isLoading = false;


  Future<void> PanDocumentInfoupload(context,String name, shopId, unitPrice,productDescription,tags,) async {
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
    var file = '';
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      for(int i = 1; i < selectedFilters_.length; i++){
        file = "$file,${selectedFilters_[i]}";
      }
      // print(file);
      var uri = Uri.parse('${apiDomain().domain}products?name=$name&shop_id=25&description=Luxery car &unit_price=50&service=false&categories=1,3,4,8&image_count=1'); // Replace with your server's endpoint
      var request = http.MultipartRequest("POST", uri)
        ..headers['Authorization'] = 'Bearer $token';
      // Add images to the request

      if (imageController.image_path.toString() != '') {
        request.files.add(await http.MultipartFile.fromPath('featured_image', imageController.image_path.toString()));
      }
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
      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var rest = jsonDecode(res.body);
        setState(() {
          isLoading = false;
        });
        Get.offAll(() => manage_business_view());

        // imageController.image_path.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('success')));

      }else {
        // alertBoxdialogBox(context, 'Alert', 'P')
        print("Failed to upload images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    product_controller = Get.put(add_product_cotroller());
    product_controller.shop_Id_controller.text = widget.shop.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    print("shop id: ${widget.shop.id}");
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          titleSpacing: 8,
          title: Text('Add Product'.tr),
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
            color: appcolor().greyColor,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  var namesed = product_controller.product_name_controller.text.toString();
                  var shopid = product_controller.shop_Id_controller.text;
                  var unitPrice = product_controller.unit_price_controller.text;
                  var productDescription = product_controller.product_desc_controller.text.toString();
                  var tags = product_controller.product_tags_controller.text.toString();
                  if(namesed == '' && shopid == ''&& unitPrice == '' && productDescription == '' && tags ==''){

                  }else{
                    PanDocumentInfoupload(context, namesed, shopid, unitPrice, productDescription, tags);
                  }
                },
                child: const Text(
                  'Publish',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ))
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
                child: const Text(
                  'New Product Detail',
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
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: TextFormField(
                  controller: product_controller.product_name_controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      FontAwesomeIcons.buildingUser,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Product Name *',
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: TextFormField(
                  controller: product_controller.shop_Id_controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      FontAwesomeIcons.shop,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Shop Id *',
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
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextFormField(
                  readOnly: true,
                  controller: product_controller.category_controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      color: Colors.black,
                      Icons.category,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Categories *',
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
                                      selectedFilters_.add(int.parse(data.id.toString()));
                                    } else if(!value){
                                      selectedFilters.remove(data.name.toString());
                                      selectedFilters_.remove(int.parse(data.id.toString()));
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

              // Business categories
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextFormField(
                  controller: product_controller.unit_price_controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      color: Colors.black,
                      FontAwesomeIcons.dollarSign,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Unit Price *',
                    suffix: Text('XAF 0'),
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

              // Business info
              Container(
                height: Get.height * 0.2,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextFormField(
                  controller: product_controller.product_desc_controller,
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
                    hintText: 'Product Description *',
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
                                          'Cover Image',
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
                                                imageController.getImageFromGallery();
                                                Get.back();
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
                                                imageController.getimagefromCamera();
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
                                Text('  Cover Image *'),
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
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: const Row(
                  children: [
                    Icon(
                      Icons.image,
                    ),
                    Text(
                      'Product Image Gallery',
                    ),
                    Spacer(),
                    Icon(Icons.edit),
                  ],
                ),
              ),

              Obx(
                () => SizedBox(
                  height: imageController.imageList.isEmpty ? null : null,
                  child: imageController.imageList.isEmpty
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
                                              imageController.removeat(index);
                                            },
                                            child: Container(
                                              height: 35,
                                              width: Get.width * 0.2,
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
                                ).paddingSymmetric(horizontal: 5);
                              },
                            ),
                          ),
                        ),
                ),
              ),
              Obx(
                () => Container(
                  child: imageController.imageList.isEmpty
                      ? null
                      : InkWell(
                        onTap: (){
                          imageController.getmultipleImage();
                        },
                        child: Container(
                          margin:const  EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: appcolor().skyblueColor,
                            borderRadius: BorderRadius.circular(10,),
                          ),
                          height: Get.height*0.08,
                            child: const Row(
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
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: TextFormField(
                  controller: product_controller.product_tags_controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      FontAwesomeIcons.tags,
                      color: Color.fromARGB(255, 108, 105, 105),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    hintText: 'Product Tags *',
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

              Text(
                'Enter words related to product separated by comma',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ).paddingSymmetric(
                horizontal: 16,
                vertical: 10,
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
