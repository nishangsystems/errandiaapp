import 'dart:convert';
import 'dart:io';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:http/http.dart'as http;
import 'package:errandia/app/ImagePicker/imagePickercontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../APi/apidomain & api.dart';
import '../../buiseness/view/add_business_view.dart';
import '../../errands/view/errand_view.dart';
import '../../global/Widgets/blockButton.dart';
import '../../global/constants/color.dart';

class add_review_view extends StatefulWidget {
  final review;
  const add_review_view({super.key, this.review});

  @override
  State<add_review_view> createState() => _add_review_viewState();
}

class _add_review_viewState extends State<add_review_view> {
  TextEditingController reviewText = TextEditingController();
  var rating = 0.0;
  bool isLoading =false;
  @override
  Widget build(BuildContext context) {
    imagePickercontroller imageController = Get.put(imagePickercontroller());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: appcolor().mediumGreyColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Review Supplier',
          style: TextStyle(
            color: appcolor().mainColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(vertical: 25,),
                // decoration: BoxDecoration(
                //   border: Border.symmetric(
                //     horizontal: BorderSide(
                //       color: appcolor().mediumGreyColor,
                //     ),
                //   ),
                // ),
                height: Get.height * 0.12,
                child: Row(
                  children: [
                    Container(
                        width: Get.width * 0.2,
                        child: Image(
                          image: NetworkImage(
                            '${widget.review['featured_image'] ?? widget.review.featured_image}',
                          ),
                          fit: BoxFit.fill,
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.review['name']}',
                          style: const TextStyle(
                              // color: appcolor().mediumGreyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Get.height * 0.004,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: Get.width * 0.1,
                              child: const Image(
                                  image: AssetImage(
                                      'assets/images/ui_23_item.png')),
                            ),
                            Text(
                              ' ${widget.review['address'] ?? widget.review.address} \n ${widget.review['street'] ?? 'Some street'}',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).paddingOnly(left: 10),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
              Divider(
                color: appcolor().mediumGreyColor,
              ),
              Container(
                // decoration: BoxDecoration(
                //   border: Border.symmetric(
                //     horizontal: BorderSide(
                //       color: appcolor().mediumGreyColor,
                //     ),
                //   ),
                // ),
                // margin: EdgeInsets.symmetric(vertical: 25,),
                // height: Get.height * 0.12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Rating',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    RatingBar.builder(
                      allowHalfRating: true,
                      ignoreGestures: false,
                      initialRating: 1.0,
                      unratedColor: appcolor().greyColor,
                      itemSize: 40,
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 10,
                        );
                      },
                      onRatingUpdate: (ratingValue) {
                        rating = ratingValue;
                      },
                    ),
                  ],
                ).paddingSymmetric(
                  horizontal: 0,
                  vertical: 5,
                ),
              ),
              Divider(
                color: appcolor().mediumGreyColor,
              ),
              Obx(
                () => imageController.image_path.isEmpty
                    ? Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.solidImage,
                                ),
                                SizedBox(
                                  width: Get.width * 0.03,
                                ),
                                const Text(
                                  'Add Image',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    FontAwesomeIcons.pen,
                                    color: appcolor().blueColor,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        height: 300,
                        child: ListView(
                          children: const [],
                        ),
                      ),
              ),

              Obx(
                () => SizedBox(
                  height: imageController.imageList.isEmpty ? null : null,
                  child: imageController.imageList.isEmpty
                      ? InkWell(
                          onTap: () {
                            imageController.getmultipleImage();
                          },
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
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                            imageController
                                                .imageList[index].path
                                                .toString(),
                                          ),
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Row(
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
                          onTap: () {
                            imageController.getmultipleImage();
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: appcolor().skyblueColor,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            height: Get.height * 0.08,
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

              // add more images
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                color: Colors.white,
                height: Get.height * 0.25,
                child: TextFormField(
                  controller: reviewText,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.message_outlined,
                    ),
                    hintText: 'Write your Review',
                    suffixIcon: Icon(
                      FontAwesomeIcons.pen,
                    ),
                  ),
                ),
              ),
              const Divider(),
              SizedBox(
                height: Get.height * 0.02,
              ),
              blockButton(
                title:isLoading == false? const Text(
                  'Submit Review',
                  style: TextStyle(color: Colors.white),
                ):const Center(child: CircularProgressIndicator(color: Colors.blue,),),
                ontap: () {
                  var RatingText = reviewText.text.toString();
                  var productid = widget.review['id'].toString();
                  if(RatingText != ''){
                    PanDocumentInfoupload(RatingText,productid);
                    setState(() {
                      isLoading = true;
                    });
                  }else{
                    alertDialogBox(context, 'Alert', 'Please Enter fill fields ');
                  }
                },
                color: appcolor().mainColor,
              ).paddingSymmetric(
                horizontal: 15,
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
            ],
          )
        ],
      ),
    );
  }
  Future<void> PanDocumentInfoupload(String RatingText, productid) async {
    // Create a MultipartRequest
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');


    var uri = Uri.parse('${apiDomain().domain}reviews?item_id=$productid&rating=$rating&review=${RatingText}&image_count=${imageController.imageList.length}');
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
        final res = await http.Response.fromStream(response);
        var rest = jsonDecode(res.body);
        print('Failed to upload images. Status code: ${rest['data']['error']}');
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
