import 'package:errandia/app/modules/buiseness/view/add_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/manage_review/controller/manage_review_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../global/constants/color.dart';

class manage_review_view extends StatelessWidget {
  manage_review_view({super.key});

  manage_review_controller controller = Get.put(manage_review_controller());
  manage_review_tab_controller tabController =
      Get.put(manage_review_tab_controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            // size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Manage Reviews',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
          size: 30,
        ),
        actions: [
          Container(),
        ],
      ),
      body: SafeArea(
        child: Builder(
          builder: (ctx) => Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: appcolor().greyColor,
                    ),
                  ),
                ),
                height: Get.height * 0.08,
                child: TabBar(
                  padding: EdgeInsets.zero,
                  dividerColor: appcolor().bluetextcolor,
                  isScrollable: false,
                  unselectedLabelColor: appcolor().mediumGreyColor,
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                  indicatorColor: appcolor().mainColor,
                  labelColor: appcolor().bluetextcolor,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appcolor().mainColor,
                    fontSize: 18,
                  ),
                  controller: tabController.tab_controller,
                  tabs: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text('Posted'),
                    ),
                    SizedBox(
                      width: Get.width * 0.26,
                      child: const Text('Received'),
                    ),
                    const Text('Trashed'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController.tab_controller,
                  children: [
                    reviewTypeList(ctx),
                    reviewTypeList(ctx),
                    reviewTypeList(ctx),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
  }
}

Widget reviewTypeList(BuildContext context) {
  return SizedBox(
    height: Get.height * 0.06,
    child: ListView.builder(
      itemCount:  manage_review_controller().review_list.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                // if (controller.selectedCounter.value > 0) {
                //   if (controller.allenquiry_list[index].isSelected ==
                //       false) controller.selectedCounter.value++;
                //   controller.allenquiry_list[index].isViewed = true;
                //   controller.allenquiry_list[index].isSelected = true;
                // } else {
                //   controller.allenquiry_list[index].isViewed =
                //       !controller.allenquiry_list[index].isViewed!;
                // }
                // setState(() {});
              },
              onLongPress: () {
                // controller.allenquiry_list[index].isViewed = true;
                // controller.selectedCounter.value++;
                // controller.allenquiry_list[index].isSelected = true;

                // setState(() {});
              },
              child: Container(
                // height: Get.height * 0.2,
                padding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        right: 10,
                        left: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      width: Get.width * 0.12,
                      height: Get.height * 0.06,
                      child: Image(
                        image: AssetImage(
                          manage_review_controller().review_list[index].image_url
                              .toString(),
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    manage_review_controller()
                                        .review_list[index].title
                                        .toString(),
                                    style: TextStyle(
                                      color: appcolor().mainColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.6,
                                    child: Text(
                                      manage_review_controller().review_list[index]
                                          .description
                                          .toString(),
                                      style: TextStyle(
                                        color:
                                        appcolor().mediumGreyColor,
                                        fontSize: 10,
                                        // fontWeight: FontWeight.w300,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  Get.bottomSheet(
                                      customBottomSheet());
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                manage_review_controller().review_list[index].Date
                                    .toString(),
                                style: TextStyle(
                                  color: appcolor().mediumGreyColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                    color: const Color.fromARGB(
                                        255, 247, 236, 199)),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${manage_review_controller()
                                          .review_list[index].rating} Rating',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            indent: 5,
                            height: 25,
                            color: appcolor().mediumGreyColor,
                          ).paddingSymmetric(
                            vertical: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),
                                color: appcolor().greyColor),
                            child: Wrap(
                              children: [
                                SizedBox(
                                  height: 15,
                                  child: Image(
                                    image: AssetImage(
                                      manage_review_controller()
                                          .review_list[index].image_url
                                          .toString(),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const Text(
                                  '  Universal Laptop Charger',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    )
  );
}

Widget customBottomSheet() {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 15,
    ),
    color: Colors.white,
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        const Icon(
          Icons.horizontal_rule_outlined,
          size: 30,
        ),
        SizedBox(
          height: Get.height * 0.06,
        ),
        InkWell(
          onTap: () {},
          child: const Row(
            children: [
              Icon(
                FontAwesomeIcons.eye,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'View Detail',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 10),
        ),
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Icon(FontAwesomeIcons.fileCircleExclamation,
                  color: appcolor().redColor),
              const SizedBox(
                width: 20,
              ),
              Text(
                'Report Review',
                style: TextStyle(
                  fontSize: 16,
                  color: appcolor().redColor,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 15),
        ),
        Container(
          height: 15,
        ),
      ],
    ),
  );
}
