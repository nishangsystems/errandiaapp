import 'dart:convert';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/modules/errands/controller/errand_controller.dart';
import 'package:errandia/app/modules/errands/controller/errandia_detail_view_controller.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class errand_detail_view extends StatefulWidget {
  final data;

  const errand_detail_view({super.key, this.data});

  @override
  _errand_detail_viewState createState() => _errand_detail_viewState();
}

class _errand_detail_viewState extends State<errand_detail_view> {
  late errandia_detail_view_controller detailController;
  late errand_controller errandController;
  late home_controller homeController;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late PopupBox popup;

  @override
  void initState() {
    super.initState();
    detailController = Get.put(errandia_detail_view_controller());
    errandController = Get.put(errand_controller());
    homeController = Get.put(home_controller());
  }

  // convert categories to string
  String categoriesString(List categories) {
    String categoryString = "";
    for (int i = 0; i < categories.length; i++) {
      categoryString += categories[i]['name'];
      if (i != categories.length - 1) {
        categoryString += ", ";
      }
    }
    return categoryString;
  }

// rerun an errand
  void rerunAnErrand(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use dialogContext
        var response;
        return CustomAlertDialog(
            title: "Alert!",
            message:
                "This action will rerun the errand and send notifications to corresponding businesses. \n"
                "Are you willing to proceed?\n",
            dialogType: MyDialogType.info,
            onConfirm: () {
              // delete product
              print("rerun errand: $id");
              ErrandsAPI.runErrand(id.toString()).then((response_) {
                if (response_ != null) {
                  response = jsonDecode(response_);
                  print("rerun errand response: $response");

                    // Check if the widget is still in the tree
                    if (response["status"] == 'success') {
                      errandController.reloadMyErrands();
                      homeController.reloadRecentlyPostedItems();

                      Navigator.of(dialogContext).pop(); // Close the dialog

                      // Show success popup
                      Get.snackbar("Info", response['message'],
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 5),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,)
                      );
                    } else {
                      Navigator.of(dialogContext).pop(); // Close the dialog

                      Get.snackbar("Error", response['message'],
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 5),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,)
                      );
                      print("rerun errand error: ${response}");
                    }

                    // popup.showPopup(context); // Show the popup
                }
              });
            },
            onCancel: () {
              // cancel delete
              print("cancel rerun");
              Navigator.of(dialogContext).pop(); // Close the dialog
            });
      },
    ).then((_) {
      if (mounted) {
        try {
          popup.dismissPopup(navigatorKey.currentContext!); // Dismiss the popup
        } catch (e) {
          print("error dismissing popup: $e");
        }
        errandController.reloadMyErrands();
        // Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("errand details: ${widget.data}");
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
        actions: [
          IconButton(
            onPressed: () {
              // rerun an errand
              rerunAnErrand(context, widget.data['id']);
            },
            icon: const Icon(
              Icons.replay,
              // size: 30,
            ),
          ),
        ],
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
                    capitalizeAll(widget.data['title']),
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
                //   //            detailController.isRead.value?null:null,
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
                //           maxLines: detailController.isRead.value ? 7 : null,
                //           //    detailController.isRead.value?null:null,
                //           overflow: detailController.isRead.value
                //               ? TextOverflow.ellipsis
                //               : null,
                //         ),
                //       ),
                //     ),
                //   ),
                // ],

                Expanded(
                  child: ReadMoreText(
                    capitalize(widget.data['description']),
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
            widget.data['categories'].toString() != "[]"
                ? Row(
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
                          categoriesString(widget.data['categories']),
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
                  )
                : Container(),
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
                  // width: Get.width * 0.5,
                  height: Get.height * 0.1,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: appcolor().mainColor,
                    backgroundImage: widget.data['user']['photo'] == ""
                        ? const AssetImage(
                            'assets/images/errandia_logo.png') // Fallback image
                        : NetworkImage(getImagePath(
                                widget.data['user']['photo'].toString()))
                            as ImageProvider,
                    child: widget.data['user']['photo'] == ""
                        ? const Icon(Icons.person)
                        : null, // Only show the icon if there is no photo
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.2,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data['user']['name'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: appcolor().mainColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      widget.data['user']['street'] != ""
                          ? Text(
                              widget.data['user']['street'],
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: appcolor().mainColor,
                              ),
                            )
                          : Text(
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
            widget.data['user']['phone'] != null &&
                    widget.data['user']['phone'] != ''
                ? Row(
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
                          // Text(
                          //   '+237 ${data['user']['phone']}',
                          //   style: const TextStyle(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  launchCaller(widget.data['user']['phone']);
                                },
                                child: Container(
                                  width: widget.data['user']['whatsapp'] !=
                                              null &&
                                          widget.data['user']['whatsapp'] != ""
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
                              widget.data['user']['whatsapp'] != null &&
                                      widget.data['user']['whatsapp'] != ""
                                  ? InkWell(
                                      onTap: () {
                                        if (widget.data['user']['whatsapp'] !=
                                                null &&
                                            widget.data['user']['whatsapp'] !=
                                                "") {
                                          launchWhatsapp(
                                              '+237 ${widget.data['user']['whatsapp']}');
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
                                    )
                                  : Container(),
                            ],
                          ).paddingOnly(top: 5)
                        ],
                      )
                    ],
                  )
                : Container(),

            widget.data['user']['phone'] != null &&
                    widget.data['user']['phone'] != ''
                ? const SizedBox(
                    height: 15,
                  )
                : Container(),

            widget.data['user']['email'] != "" &&
                    widget.data['user']['email'] != null
                ? Row(
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
                          SizedBox(
                              width: Get.width * 0.55,
                              child: Text(widget.data['user']['email'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  launchEmail(widget.data['user']['email']);
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
                  )
                : Container(),

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
                widget.data['images'].length > 0
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: widget.data['images'].length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                child: Center(
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/errandia_logo.png',
                                    image: getImagePathWithSize(
                                        widget.data['images'][index]
                                            ['image_path'],
                                        width: 100,
                                        height: 100),
                                    fit: BoxFit.contain,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/errandia_logo.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
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
