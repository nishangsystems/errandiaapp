import 'package:errandia/app/modules/errands/view/errand_detail_view.dart';
import 'package:errandia/app/modules/global/Widgets/filter_product_view.dart';
import 'package:errandia/app/modules/services/controller/manage_service_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../../APi/apidomain & api.dart';
import '../../global/Widgets/blockButton.dart';
import '../../global/constants/color.dart';
import '../controller/errand_controller.dart';
import 'New_Errand.dart';

manage_service_controller service_controller =
    Get.put(manage_service_controller());

class errand_view extends StatelessWidget {
  errand_view({super.key});

  errand_tab_controller tabController = Get.put(errand_tab_controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // InkWell(
            //   onTap: ()async {
            //     final SharedPreferences prefs = await SharedPreferences.getInstance();
            //     var token = prefs.getString('token');
            //     if(token == ''){
            //       Get.to(const register_signin_screen());
            //     }else{
            //       Get.offAll(New_Errand());
            //     }
            //   },
            //   child: Container(
            //     width: Get.width * 0.44,
            //     padding: const EdgeInsets.all(15),
            //     decoration: BoxDecoration(
            //       color: appcolor().skyblueColor,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     // child: Row(
            //     //   children: [
            //     //     Icon(
            //     //       Icons.add,
            //     //       color: appcolor().mainColor,
            //     //       size: 28,
            //     //     ),
            //     //     Spacer(),
            //     //     Text(
            //     //       'New Errand',
            //     //       style: TextStyle(
            //     //         fontSize: 16,
            //     //         color: appcolor().mainColor,
            //     //       ),
            //     //     ),
            //     //   ],
            //     // ),
            //   ),
            // ),
            // SizedBox(height: 20,),
            InkWell(
              onTap: () {
                Get.offAll(New_Errand());
              },
              child: Container(
                width: Get.width * 0.44,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: appcolor().skyblueColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: appcolor().mainColor,
                      size: 28,
                    ),
                    const Spacer(),
                    Text(
                      'Run Errand',
                      style: TextStyle(
                        fontSize: 16,
                        color: appcolor().mainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          width: Get.width * 0.7,
          child: SafeArea(
            child: Column(
              children: [
                blockButton(
                  title: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      hintText: 'Search Product',
                    ),
                  ),
                  ontap: () {},
                  color: Colors.white,
                ).paddingOnly(
                  bottom: 20,
                ),
                blockButton(
                  title: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  ontap: () {},
                  color: appcolor().mainColor,
                )
              ],
            ).paddingSymmetric(horizontal: 10, vertical: 50),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              // size: 30,
            ),
            onPressed: () {
              Get.back();
              // Get.to(Home_view());
            },
          ),
         // automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Errands',
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
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
                    unselectedLabelStyle: TextStyle(
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
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Posted'),
                      ),
                      Container(
                        child: Text('Received'),
                        width: Get.width * 0.26,
                      ),
                      Text('Trashed'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController.tab_controller,
                    children: [
                      PostedErrands(ctx),
                      RecievedErrands(ctx),
                      Trashed(ctx),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Widget PostedErrands(BuildContext ctx) {
  return
  FutureBuilder(
      future:api().productnew('errands',1),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Center(child: Text('No data Fond'),);
        } else if(snapshot.hasData){
        var data = snapshot.data['errands'];
          return   Column(
            children: [
              filter_sort_container(
                    () {
                  Get.to(filter_product_view());
                },
                    () {
                  Get.bottomSheet(
                    Container(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text(
                            'Sort List',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: appcolor().mainColor,
                            ),
                          ),
                          // z-a
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: 'Errand Name : ',
                                      style: TextStyle(
                                        color: appcolor().mainColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Desc Z-A',
                                      style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Obx(
                                    () => Radio(
                                  value: 'sort descending',
                                  groupValue: service_controller
                                      .manage_service_sort_group_value.value,
                                  onChanged: (val) {
                                    service_controller.manage_service_sort_group_value
                                        .value = val.toString();
                                  },
                                ),
                              )
                            ],
                          ),

                          // a-z
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: 'Errand Name : ',
                                      style: TextStyle(
                                        color: appcolor().mainColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Asc A-Z',
                                      style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Obx(
                                    () => Radio(
                                  value: 'sort ascending',
                                  groupValue: service_controller
                                      .manage_service_sort_group_value.value,
                                  onChanged: (val) {
                                    service_controller.manage_service_sort_group_value
                                        .value = val.toString();
                                  },
                                ),
                              ),
                            ],
                          ),

                          // distance nearest to me
                          Row(
                            children: [
                              RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontSize: 16),
                                      children: [
                                        TextSpan(
                                          text: 'Date',
                                          style: TextStyle(
                                            color: appcolor().mainColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Last Modified',
                                        ),
                                      ])),
                              Spacer(),
                              Obx(() => Radio(
                                value: 'Date Last modified ',
                                groupValue: service_controller
                                    .manage_service_sort_group_value.value,
                                onChanged: (val) {
                                  service_controller.manage_service_sort_group_value
                                      .value = val.toString();
                                },
                              ))
                            ],
                          ),

                          //recentaly added
                          Row(
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                    color: appcolor().mainColor, fontSize: 16),
                              ),
                              Icon(
                                Icons.arrow_upward,
                                size: 25,
                                color: appcolor().mediumGreyColor,
                              ),
                              Spacer(),
                              Obx(
                                    () => Radio(
                                  value: 'Price',
                                  groupValue: service_controller
                                      .manage_service_sort_group_value.value,
                                  onChanged: (val) {
                                    service_controller.manage_service_sort_group_value
                                        .value = val.toString();
                                    print(val.toString());
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ).paddingSymmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  );
                },
                    () {
                  Scaffold.of(ctx).openEndDrawer();
                },
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:data.length,
                  itemBuilder: (context, index) {
                    var dataa= data[index];
                    var date = dataa['created_at'].split('T');
                    var date1 = date[0].split('-');
                    return Container(
                      padding: EdgeInsets.all(
                        10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // image container
                          Container(
                            margin: EdgeInsets.only(
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            width: Get.width * 0.12,
                            height: Get.height * 0.06,
                            child:ListView.builder(
                                itemCount: dataa['images'].length,
                                itemBuilder:(context, index){
                                  var image = dataa['images'][index];
                                  return   Image.network('${image['url'].toString()}');
                                })
                            
                            

                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width * 0.45,
                                child: Text(
                                  '${dataa['title'].toString()}',
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: appcolor().mainColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    child: Text(
                                      'posted on :',
                                      style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '${date1[2]}-${date1[1]}-${date1[0]}',
                                      style: TextStyle(
                                        color: appcolor().mainColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.04,
                                  ),
                                  found_pending_cancel(index, 3),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: appcolor().lightgreyColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  dataa['description'].length >=30?'${dataa['description'] + '..'}'.substring(0,30):dataa['description'].toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: appcolor().mediumGreyColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              print(index.toString());
                              Get.bottomSheet(
                                // backgroundColor: Colors.white,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  color: Colors.white,
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.horizontal_rule,
                                          size: 25,
                                        ),
                                      ),
                                      // Text(index.toString()),
                                      managebottomSheetWidgetitem(
                                        title: 'Edit Errand',
                                        icondata: Icons.edit,
                                        callback: () async {
                                          print('tapped');
                                          Get.back();
                                        },
                                      ),
                                      managebottomSheetWidgetitem(
                                        title: 'View Errand',
                                        icondata: FontAwesomeIcons.eye,
                                        callback: () {
                                          Get.back();
                                          Get.to(errand_detail_view(data: dataa,));
                                        },
                                      ),
                                      managebottomSheetWidgetitem(
                                        title: 'Mark as found',
                                        icondata: FontAwesomeIcons.circleCheck,
                                        callback: () {},
                                      ),
                                      managebottomSheetWidgetitem(
                                        title: 'Move to trash',
                                        icondata: Icons.delete,
                                        callback: () {
                                          var value = {
                                            "errand_id": dataa['id']
                                          };
                                          api().deleteUpdate('errand/delete', 1, value);
                                          Future.delayed(Duration(seconds: 2),(){
                                            Get.offAll(errand_view());
                                          });

                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                enableDrag: true,
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  'View',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: appcolor().mediumGreyColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: appcolor().greyColor),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Icon(
                                    Icons.more_horiz,
                                    color: appcolor().greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ).paddingOnly(
            left: 10,
            right: 10,
            top: 10,
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
  });

}

Widget RecievedErrands(BuildContext ctx) {
  return Column(
    children: [
      filter_sort_container(
        () {
          Get.to(filter_product_view());
        },
        () {
          Get.bottomSheet(
            Container(
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Text(
                    'Sort List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: appcolor().mainColor,
                    ),
                  ),
                  // z-a
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Service Name : ',
                              style: TextStyle(
                                color: appcolor().mainColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Desc Z-A',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Radio(
                          value: 'sort descending',
                          groupValue: service_controller
                              .manage_service_sort_group_value.value,
                          onChanged: (val) {
                            service_controller.manage_service_sort_group_value
                                .value = val.toString();
                          },
                        ),
                      )
                    ],
                  ),

                  // a-z
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Service Name : ',
                              style: TextStyle(
                                color: appcolor().mainColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Asc A-Z',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Radio(
                          value: 'sort ascending',
                          groupValue: service_controller
                              .manage_service_sort_group_value.value,
                          onChanged: (val) {
                            service_controller.manage_service_sort_group_value
                                .value = val.toString();
                          },
                        ),
                      ),
                    ],
                  ),

                  // distance nearest to me
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: 16),
                              children: [
                            TextSpan(
                              text: 'Date',
                              style: TextStyle(
                                color: appcolor().mainColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Last Modified',
                            ),
                          ])),
                      Spacer(),
                      Obx(() => Radio(
                            value: 'Date Last modified ',
                            groupValue: service_controller
                                .manage_service_sort_group_value.value,
                            onChanged: (val) {
                              service_controller.manage_service_sort_group_value
                                  .value = val.toString();
                            },
                          ))
                    ],
                  ),

                  //recentaly added
                  Row(
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                            color: appcolor().mainColor, fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_upward,
                        size: 25,
                        color: appcolor().mediumGreyColor,
                      ),
                      Spacer(),
                      Obx(
                        () => Radio(
                          value: 'Price',
                          groupValue: service_controller
                              .manage_service_sort_group_value.value,
                          onChanged: (val) {
                            service_controller.manage_service_sort_group_value
                                .value = val.toString();
                            print(val.toString());
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ).paddingSymmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
          );
        },
        () {
          Scaffold.of(ctx).openEndDrawer();
        },
      ),
      SizedBox(
        height: Get.height * 0.01,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(
                10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image container
                  Container(
                    margin: EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                    width: Get.width * 0.14,
                    height: Get.height * 0.06,
                    child: Image(
                      image: AssetImage(
                        'assets/images/hair_cut.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 0.45,
                        child: Text(
                          'I need a Dell Laptop',
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: appcolor().mainColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'posted on :',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '02 Apr 2023',
                              style: TextStyle(
                                color: appcolor().mainColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 2),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'By',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '  Dr.Pearline Commins',
                              style: TextStyle(
                                color: appcolor().mainColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(
                        top: 2,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: appcolor().lightgreyColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Molyko-Buea',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 12,
                            color: appcolor().mediumGreyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      print(index.toString());
                      Get.bottomSheet(
                        // backgroundColor: Colors.white,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.horizontal_rule,
                                  size: 25,
                                ),
                              ),
                              // Text(index.toString()),
                              managebottomSheetWidgetitem(
                                title: 'View Details',
                                icondata: FontAwesomeIcons.eye,
                                callback: () async {
                                  print('tapped');
                                  Get.back();
                                },
                              ),
                              managebottomSheetWidgetitem(
                                title: 'Call +XXXXXXXXXX',
                                icondata: Icons.call,
                                callback: () {
                                  Get.back();
                                },
                              ),
                              managebottomSheetWidgetitem(
                                title: 'Send Email',
                                icondata: Icons.email,
                                callback: () {},
                              ),
                              managebottomSheetWidgetitem(
                                title: 'Delete Errand Permanently',
                                icondata: Icons.delete,
                                callback: () {},
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),

                        enableDrag: true,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'View',
                          style: TextStyle(
                              fontSize: 13,
                              color: appcolor().mediumGreyColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: appcolor().greyColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            color: appcolor().greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
    ],
  ).paddingOnly(
    left: 10,
    right: 10,
    top: 10,
  );
}

Widget Trashed(BuildContext ctx) {
  return Column(
    children: [
      filter_sort_container(
        () {
          Get.to(filter_product_view());
        },
        () {
          Get.bottomSheet(
            Container(
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Text(
                    'Sort List',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: appcolor().mainColor,
                    ),
                  ),
                  // z-a
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Service Name : ',
                              style: TextStyle(
                                color: appcolor().mainColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Desc Z-A',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Radio(
                          value: 'sort descending',
                          groupValue: service_controller
                              .manage_service_sort_group_value.value,
                          onChanged: (val) {
                            service_controller.manage_service_sort_group_value
                                .value = val.toString();
                          },
                        ),
                      )
                    ],
                  ),

                  // a-z
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(
                              text: 'Service Name : ',
                              style: TextStyle(
                                color: appcolor().mainColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Asc A-Z',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Radio(
                          value: 'sort ascending',
                          groupValue: service_controller
                              .manage_service_sort_group_value.value,
                          onChanged: (val) {
                            service_controller.manage_service_sort_group_value
                                .value = val.toString();
                          },
                        ),
                      ),
                    ],
                  ),

                  // distance nearest to me
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: 16),
                              children: [
                            TextSpan(
                              text: 'Date',
                              style: TextStyle(
                                color: appcolor().mainColor,
                              ),
                            ),
                            TextSpan(
                              text: 'Last Modified',
                            ),
                          ])),
                      Spacer(),
                      Obx(() => Radio(
                            value: 'Date Last modified ',
                            groupValue: service_controller
                                .manage_service_sort_group_value.value,
                            onChanged: (val) {
                              service_controller.manage_service_sort_group_value
                                  .value = val.toString();
                            },
                          ))
                    ],
                  ),

                  //recentaly added
                  Row(
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                            color: appcolor().mainColor, fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_upward,
                        size: 25,
                        color: appcolor().mediumGreyColor,
                      ),
                      Spacer(),
                      Obx(
                        () => Radio(
                          value: 'Price',
                          groupValue: service_controller
                              .manage_service_sort_group_value.value,
                          onChanged: (val) {
                            service_controller.manage_service_sort_group_value
                                .value = val.toString();
                            print(val.toString());
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ).paddingSymmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
          );
        },
        () {
          Scaffold.of(ctx).openEndDrawer();
        },
      ),
      SizedBox(
        height: Get.height * 0.01,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(
                10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image container
                  Container(
                    margin: EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                    width: Get.width * 0.14,
                    height: Get.height * 0.06,
                    child: Image(
                      image: AssetImage(
                        'assets/images/hair_cut.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 0.45,
                        child: Text(
                          'I need a Dell Laptop',
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: appcolor().mainColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'posted on :',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '02 Apr 2023',
                              style: TextStyle(
                                color: appcolor().mainColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(top: 2),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'By',
                              style: TextStyle(
                                color: appcolor().mediumGreyColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '  Dr.Pearline Commins',
                              style: TextStyle(
                                color: appcolor().mainColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ).paddingOnly(
                        top: 2,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: appcolor().lightgreyColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Molyko-Buea',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 12,
                            color: appcolor().mediumGreyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      print(index.toString());
                      Get.bottomSheet(
                        // backgroundColor: Colors.white,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.horizontal_rule,
                                  size: 25,
                                ),
                              ),
                              // Text(index.toString()),
                              managebottomSheetWidgetitem(
                                title: 'Edit Errand',
                                icondata: Icons.edit,
                                callback: () async {
                                  print('tapped');
                                  Get.back();
                                },
                              ),
                              managebottomSheetWidgetitem(
                                title: 'Post Errand',
                                icondata: FontAwesomeIcons.shareFromSquare,
                                callback: () {
                                  Get.back();
                                },
                              ),

                              managebottomSheetWidgetitem(
                                title: 'Delete Permanently',
                                icondata: Icons.delete,
                                callback: () {},
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),

                        enableDrag: true,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'View',
                          style: TextStyle(
                              fontSize: 13,
                              color: appcolor().mediumGreyColor,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: appcolor().greyColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.more_horiz,
                            color: appcolor().greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
    ],
  ).paddingOnly(
    left: 10,
    right: 10,
    top: 10,
  );
}

Widget filter_sort_container(
  Callback filter_button,
  Callback sort_button,
  Callback search_button,
) {
  return Container(
    // width: Get.width*0.4,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: filter_button,
          child: Container(
            width: Get.width * 0.35,
            decoration: BoxDecoration(
                border: Border.all(color: appcolor().greyColor),
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Filter List',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Icon(
                  FontAwesomeIcons.arrowDownWideShort,
                  color: appcolor().mediumGreyColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: sort_button,
          child: Container(
            width: Get.width * 0.35,
            decoration: BoxDecoration(
                border: Border.all(color: appcolor().greyColor),
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Sort List ',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Icon(
                  FontAwesomeIcons.arrowDownWideShort,
                  color: appcolor().mediumGreyColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: search_button,
          child: Container(
            // width: Get.width*0.4,

            decoration: BoxDecoration(
              border: Border.all(color: appcolor().greyColor),
              borderRadius: BorderRadius.circular(
                10,
              ),
              color: appcolor().skyblueColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.search,
                  color: appcolor().mainColor,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget managebottomSheetWidgetitem({
  required String title,
  required IconData icondata,
  required Callback callback,
  Color? color,
}) {
  return InkWell(
    // highlightColor: Colors.grey,

    hoverColor: Colors.grey,
    // focusColor: Colors.grey,
    // splashColor: Colors.grey,
    // overlayColor: Colors.grey,
    onTap: callback,
    child: Row(
      children: [
        Container(
          height: 24,
          child: Icon(
            icondata,
            color: color == null ? Colors.black : color,
          ),
        ),
        SizedBox(
          width: 18,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color == null ? Colors.black : color,
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 15),
  );
}

// status

// found 2,
// pending 1,
// cancelled 0,
Widget found_pending_cancel(int index, int status) {
  String s = 'found';
  Color color = Colors.green;
  IconData icondata = FontAwesomeIcons.circleCheck;
  if (status == 0) {
    s = 'Cancelled';
    color = Colors.red;
    icondata = FontAwesomeIcons.circleXmark;
  }
  if (status == 1) {
    s = 'panding';
    color = Colors.orange;
    icondata = Icons.pending;
  }

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 2,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(
          icondata,
          color: color,
          size: 12,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          s,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        )
      ],
    ),
  );
}
