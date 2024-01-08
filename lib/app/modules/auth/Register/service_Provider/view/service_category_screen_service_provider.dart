import 'package:errandia/app/modules/auth/Register/registration_successful_view.dart';
import 'package:errandia/app/modules/auth/Register/service_Provider/view/service_category_item_list.dart';
import 'package:errandia/app/modules/global/Widgets/GlobalDialogBoxtext.dart';
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/global/storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../services/view/add_service_view.dart';

class service_category_service_provider extends StatelessWidget {
  service_category_service_provider({super.key});
  // List Selected_item_List = service_provider_storage_box.read('Selected_item_List');
  // RxBool show_list_item=false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Service Provider',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff113d6b),
          ),
        ),
        elevation: 0.8,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff113d6b),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    serviceCategory(context),
                    SizedBox(
                      height: Get.height * 0.06,
                    ),

                    // Obx((){

                    //   return Selected_item_List.length>0 ?Container(
                    //     child: Text('Selected_item'),
                    //   ):Container(
                    //     child: Text('hii'),
                    //   );
                    // }),

                    AddService(),
                    SizedBox(
                      height: Get.height * 0.2,
                    ),
                    blockButton(
                      title: Text(
                        'SUBMIT AND CONTINUE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: appcolor().greyColor,
                      ontap: () {
                        Get.to(registration_successful_view());
                      },
                      textcolor: appcolor().mediumGreyColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget serviceCategory(BuildContext context) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xff113d6b),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Select at least 1 category that describes the service you offer',
            style: TextStyle(
              color: Color(0xff8ba0b7),
              fontSize: 17,
            ),
          ),
        ),
        SizedBox(
          height: Get.height * 0.01,
        ),
        Text(
          'Service Categories',
          style: TextStyle(fontSize: 17),
        ),
        InkWell(
          onTap: () async {
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return service_category_item_list();
                });
          },
          child: Container(
            height: Get.height * 0.07,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: appcolor().greyColor,
              ),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Row(
              children: [
                Text(
                  'Select category',
                  style: TextStyle(
                      fontSize: 15, color: appcolor().mediumGreyColor),
                ),
                Spacer(),
                Icon(Icons.arrow_drop_down),
              ],
            ).paddingSymmetric(horizontal: 12),
          ),
        ),
        // ListView.builder(
        //     itemCount: Selected_item_List.length,
        //     itemBuilder: (context, index){
        //       return Text('${Selected_item_List[index]['title']}');
        //
        // })

      ],
    ),
  );
}

Widget AddService() {
  return Column(
    children: [
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Services',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xff113d6b),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Add at least one service you offer in your business',
                style: TextStyle(
                  color: Color(0xff8ba0b7),
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            InkWell(
              onTap: (){
                Get.to(add_service_view());
              },
              child: Container(
                height: Get.height * 0.1,
                child: Row(
                  children: [
                    Container(
                      width: Get.width * 0.23,
                      decoration: BoxDecoration(
                          border: Border.all(color: appcolor().mainColor, width: 1.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Icon(
                          Icons.add_outlined,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.07,
                    ),
                    Text(
                      'Add new Service',
                      style: TextStyle(
                          color: appcolor().darkBlueColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: Get.height * 0.01,
      ),

      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            InkWell(
              onTap: (){
                Get.to(add_service_view());
              },
              child: Container(
                height: Get.height * 0.13,
                child: Row(
                  children: [
                    Container(
                      width: Get.width * 0.23,
                      decoration: BoxDecoration(
                          border: Border.all(color: appcolor().mainColor, width: 1.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset('assets/images/boy1.png',fit: BoxFit.cover,)
                    ),
                    SizedBox(
                      width: Get.width * 0.07,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dreadlocks',
                          style: TextStyle(
                              color: appcolor().darkBlueColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'XAF 10,00',
                          style: TextStyle(
                              color: appcolor().darkBlueColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: Get.width * 0.17,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.pen,color: Color(0xff113d6b),)),
                        IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.times,color: Colors.grey,))

                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
