import 'package:errandia/app/modules/errands/controller/errandia_detail_view_controller.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class errand_detail_view extends StatelessWidget {
  final data;

  errand_detail_view({super.key, this.data});

  late errandia_detail_view_controller detailcontroller =
      Get.put(errandia_detail_view_controller());

  @override
  Widget build(BuildContext context) {
    print("errand details: $data");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            // size: 30,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Errand Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width * 0.3,
                  child: const Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.035,
                ),
                SizedBox(
                  width: Get.width * 0.55,
                  height: Get.height * 0.08,
                  child: Text(
                    capitalizeAll(data['title']),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: appcolor().mainColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.3,
                  child: const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.035,
                ),
                //   // Obx(
                //   //   () => Expanded(
                //   //     child: Container(
                //   //       child: Text(
                //   //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                //   //         style: TextStyle(
                //   //           fontSize: 18,
                //   //           // fontWeight: FontWeight.w600,
                //   //           // color: appcolor().mainColor,
                //   //         ),
                //   //         maxLines:
                //   //            detailcontroller.isRead.value?null:null,
                //   //         overflow: TextOverflow.ellipsis,
                //   //       ),
                //   //     ),
                //   //   ),
                //   // ),
                //   Obx(
                //     () => Expanded(
                //       child: Container(
                //         child: Text(
                //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                //           style: TextStyle(
                //             fontSize: 18,
                //             // fontWeight: FontWeight.w600,
                //             // color: appcolor().mainColor,
                //           ),
                //           maxLines: detailcontroller.isRead.value ? 7 : null,
                //           //    detailcontroller.isRead.value?null:null,
                //           overflow: detailcontroller.isRead.value
                //               ? TextOverflow.ellipsis
                //               : null,
                //         ),
                //       ),
                //     ),
                //   ),
                // ],

                Expanded(
                  child: ReadMoreText(
                    capitalize(data['description']),
                    trimLength: 200,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.left,
                    trimMode: TrimMode.Length,
                    trimCollapsedText: 'read more',
                    trimExpandedText: '   read less',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            data['categories'] != "" ? Row(
              children: [
                SizedBox(
                  width: Get.width * 0.3,
                  child: const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.035,
                ),
                 Expanded(
                  child: ReadMoreText(
                   data['categories'].toString(),
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    trimLength: 50,
                    textAlign: TextAlign.left,
                    trimMode: TrimMode.Length,
                    trimCollapsedText: 'read more',
                    trimExpandedText: 'read less',
                  ),
                ),
              ],
            ) : Container(),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Posted By',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: Get.width * 0.3,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor:
                    appcolor().mainColor,
                    child: data['user']
                    ['photo'] ==
                        ""
                        ? const Icon(Icons.person)
                        : FadeInImage
                        .assetNetwork(
                      placeholder:
                      'assets/images/errandia_logo.jpeg',
                      image: getImagePath(
                          data['user']
                          ['photo']
                              .toString()),
                      fit: BoxFit.fill,
                      imageErrorBuilder:
                          (context, error,
                          stackTrace) {
                        return Icon(
                            Icons.person,
                            color: appcolor()
                            .lightgreyColor,
                            size: 45,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.035,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['user']['name'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: appcolor().mainColor,
                        ),
                      ),
                      data['user']['street'] != "" ?
                      Text(
                        data['user']['street'],
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: appcolor().mainColor,
                        ),
                      ): Text(
                        "No location provided",
                        style: TextStyle(
                          fontSize: 11,
                          color: appcolor().mediumGreyColor,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.3,
                  child: const Text(
                    'Phone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.035,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '+237 ${data['user']['phone']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            launchCaller(data['user']['phone']);
                          },
                          child: Container(
                            width: data['user']['whatsapp'] != null &&
                                data['user']['whatsapp'] != ""
                                ? Get.width * 0.15
                                : Get.width * 0.32,
                            padding: const EdgeInsets.symmetric(
                              // horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: appcolor().skyblueColor,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  color: appcolor().mainColor,
                                  size: 17,
                                ),
                                const Text(
                                  ' Call',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ).marginOnly(left: 0),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        data['user']['whatsapp'] != null && data['user']['whatsapp'] != "" ? InkWell(
                          onTap: () {
                            if (data['user']['whatsapp'] != null &&
                                data['user']['whatsapp'] != "") {
                              launchWhatsapp(
                                  '+237 ${data['user']['whatsapp']}');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: appcolor().skyblueColor,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: appcolor().mainColor,
                                ),
                                const Text(
                                  ' Whatsapp',
                                )
                              ],
                            ),
                          ),
                        ) : Container(),
                      ],
                    ).paddingOnly(top: 5)
                  ],
                )
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            data['user']['email'] != "" && data['user']['email'] != null ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.3,
                  child: const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.035,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['user']['email'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                             launchEmail(data['user']['email']);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: appcolor().skyblueColor,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  // color: appcolor().mainColor,
                                ),
                                Text(
                                  '  Send Email',
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).paddingOnly(top: 5)
                  ],
                )
              ],
            ): Container(),

            const SizedBox(
              height: 30,
            ),

            //photo container
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Photos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                data['images'].length > 0 ? SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: data['images'].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        height: 80,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/errandia_logo.jpeg',
                            image: getImagePath(
                                data['images'][index]['url'].toString()),
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/errandia_logo.jpeg',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ) :
                 Center(
                   child: Text(
                    'No photos provided',
                    style: TextStyle(
                      fontSize: 15,
                      color: appcolor().mediumGreyColor,
                      fontStyle: FontStyle.italic,
                    ),
                ),
                 ),
              ],
            ),
          ],
        ).paddingOnly(
          left: 20,
          top: 20,
          right: 10,
          bottom: 20,
        ),
      ),
    );
  }
}
