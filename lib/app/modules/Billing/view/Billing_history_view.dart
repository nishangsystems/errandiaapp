import 'package:errandia/app/modules/Billing/controller/Billing_controller.dart';
import 'package:errandia/app/modules/buiseness/view/add_business_view.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/manage_review/controller/manage_review_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../global/constants/color.dart';

class billing_history_view extends StatelessWidget {
  billing_history_view({super.key});

  Billing_controller controller = Get.put(Billing_controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Billing History',
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
      body: Column(
        children: [
          Container(
            height: 20,
          ),
          blockButton(
            title: Container(
              child: TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    suffixIcon: Icon(
                      Icons.search,
                    ),
                    hintText: 'Search History'),
              ),
            ),
            ontap: () {},
            color: Colors.white,
          ).paddingSymmetric(horizontal: 15),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.billing_list.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            controller.billing_list[index].title.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: appcolor().darkBlueColor),
                          ),
                          Spacer(),
                          Text(
                            'XAF ' +
                                controller.billing_list[index].Price.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: controller.billing_list[index].color),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            child: Image(
                              image: AssetImage(
                                controller.billing_list[index].image_url
                                    .toString(),
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.billing_list[index].company_name
                                    .toString(),
                                style: TextStyle(
                                  color: appcolor().mainColor,
                                ),
                              ),
                              Text(
                                controller.billing_list[index].phone.toString(),
                                style: TextStyle(
                                    color: appcolor().mediumGreyColor,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: Get.height * 0.01,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "- " +
                                        controller.billing_list[index].Date
                                            .toString(),
                                    style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    Icons.circle,
                                    size: 10,
                                    color: controller.billing_list[index].color,
                                  ),
                                  Text(
                                    " " +
                                        controller.billing_list[index].status
                                            .toString(),
                                    style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
