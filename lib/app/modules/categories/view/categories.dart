import 'package:errandia/app/modules/categories/CategoryData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/constants/color.dart';
import 'categories_item.dart';

class categories_view extends StatefulWidget {
  const  categories_view({super.key});

  @override
  State<categories_view> createState() => _categories_viewState();
}

class _categories_viewState extends State<categories_view> {
  @override
  RxInt _index = 0.obs;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Image(
          image: AssetImage('assets/images/icon-errandia-logo-about.png'),
          width: Get.width * 0.3,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              size: 30,
            ),
            color: appcolor().mediumGreyColor,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              size: 30,
            ),
            color: appcolor().mediumGreyColor,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            // height: Get.height * 0.,
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 22,
                color: appcolor().mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
                child: GridView.count(
              childAspectRatio: (1 / 1.3),
              crossAxisCount: 2,
              children: List.generate(home_categories_list.length, (index) {
                return InkWell(
                  onTap: (){
                    Get.to(CategoryData());
                  },
                  child: Container(
                    margin: EdgeInsets.all(6),
                    height: Get.height * 0.8,
                    // color: Colors.blue,
                    width: Get.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: Get.height * 0.2,
                          decoration: BoxDecoration(
                              color: appcolor().greyColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Image(
                              image: AssetImage(
                                home_categories_list[index].imagePath,
                              ),
                              height: Get.height * 0.12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Text(
                          home_categories_list[index].belowText,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            )),
          ),
        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }
}
