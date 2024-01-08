import 'dart:convert';
import 'package:path/path.dart';

import '../../../../modal/Country.dart';
import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/modules/buiseness/view/errandia_business_view.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/categories/view/categories.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/common/random_ui/ui_23.dart';
import 'package:errandia/app/modules/errands/view/run_an_errand.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:errandia/modal/Country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../modal/Region.dart';
import '../../../../modal/Street.dart';
import '../../../../modal/subcatgeory.dart';
import '../../../../modal/Town.dart';
import '../../../../modal/category.dart';
import '../../categories/CategoryData.dart';
import '../../buiseness/featured_buiseness/view/featured_list_item.dart';
import '../../errands/view/see_all_errands.dart';
import '../../recently_posted_item.dart/view/recently_posted_list.dart';
import 'package:http/http.dart'as http;

class home_view_1 extends StatefulWidget {

  home_view_1({super.key});

  @override
  State<home_view_1> createState() => _home_view_1State();
}

class _home_view_1State extends State<home_view_1> {
  Country() async {
    try{
      final response =
      await http.get(Uri.parse('${apiDomain().domain}countries'),);
      if(response.statusCode ==200){
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        Countryy.Itemss = List.from(productsData)
            .map<CountryCode>((product) => CountryCode.fromJson(product))
            .toList();
        setState(() {
        });
      }
    }catch(w){
      throw Exception(w.toString());
    }
  }
  CountryData() async {
    try{
      final response =
      await http.get(Uri.parse('${apiDomain().domain}categories'),);
      if(response.statusCode ==200){
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        categor.Items = List.from(productsData)
            .map<Caegory>((product) => Caegory.fromJson(product))
            .toList();
        setState(() {
        });
      }
    }catch(w){
      throw Exception(w.toString());
    }
  }
  RegionData() async {
    try{
      final response =
      await http.get(Uri.parse('${apiDomain().domain}regions'),);
      if(response.statusCode ==200){
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        print(productsData);
        Regions.Items = List.from(productsData)
            .map<CountryRegion>((product) => CountryRegion.fromJson(product))
            .toList();
        setState(() {
        });
      }
    }catch(w){
      throw Exception(w.toString());
    }
  }
  TownData() async {
    try{
      final response =
      await http.get(Uri.parse('${apiDomain().domain}towns'));
      if(response.statusCode ==200){
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];

        Towns.Items = List.from(productsData)
            .map<Town>((product) => Town.fromJson(product))
            .toList();
        setState(() {
        });
      }
    }catch(w){
      throw Exception(w.toString());
    }
  }
  street() async {
    try{
      final response =
      await http.get(Uri.parse('${apiDomain().domain}streets'),);
      if(response.statusCode ==200){
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];

        Street.Items = List.from(productsData)
            .map<Streetid>((product) => Streetid.fromJson(product))
            .toList();
        setState(() {
        });
      }
    }catch(w){
      throw Exception(w.toString());
    }
  }
  subcategorydat() async {
    try{
      final response =
      await http.get(Uri.parse('${apiDomain().domain}streets'),);
      if(response.statusCode ==200){
        final catalogJson = response.body;
        final decodedData = jsonDecode(catalogJson);
        var productsData = decodedData["data"];
        // print(productsData);
        subCetegoryData.Items = List.from(productsData)
            .map<Sub>((product) => Sub.fromJson(product))
            .toList();
        setState(() {
        });
      }
    }catch(w){
      throw Exception(w.toString());
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CountryData();
    RegionData();
    TownData();
    Country();
    street();
    subcategorydat();
  }
  @override
  Widget build(BuildContext context) {
    Future<void> locationpermission()async{
      var status = await Permission.location.request();
      if(status.isDenied){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera access denied')));
      }else if(status.isPermanentlyDenied){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera access Permantly denied')));

      }else if(status.isGranted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera access granted')));


      }
    }
    home_controller().atbusiness.value = false;
    return Stack(
      children: [
        Image(
          image: AssetImage(
            'assets/images/home_bg.png',
          ),
          fit: BoxFit.fill,
          height: Get.height,
          width: Get.width,
        ),
        ListView(
          // physics: (),
          children: [
            // welcome widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                height: Get.height * 0.16,
                width: Get.width,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome Kris',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Start by running an errand',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            Get.to(run_an_errand());
                          },
                          child: Text(
                            'Run an Errand',
                            style: TextStyle(
                                color: appcolor().mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              color: appcolor().skyblueColor,
              height: Get.height * 0.06,
              child: Row(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/refresh_location.png',
                    ),
                    color: appcolor().mainColor,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Update Buiseness Location'.tr,
                        style: TextStyle(
                            color: appcolor().mainColor, fontSize: 12),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: ()async {
                      var status = await  Permission.location.status;
                      if(status.isGranted){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camera access Permantly denied')));
                      }else{
                        locationpermission();
                      }
                    },
                    child: Text(
                      'Verify Location'.tr,
                      style: TextStyle(
                        color: appcolor().mainColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // categories widget

            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: appcolor().mainColor,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(categories_view());
                    },
                    child: Text('See All'),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
            ),

            Categories_List_Widget(),

            // Featured Businesses

            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'Featured Businesses',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: appcolor().mainColor,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(Ui_23());
                    },
                    child: Text('See All'),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
            ),

            Featured_Businesses_List(),

            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                    'Recently Posted Errands',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: appcolor().mainColor,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(SeeAllErands());
                    },
                    child: Text('See All'),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
            ),

            Recently_posted_items_Widget(),
            Container(
              height: Get.height * 0.05,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

Widget Categories_List_Widget() {
  return FutureBuilder(
      future: api().GetData('categories'),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text('Server Error');
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }else if(snapshot.hasData){
          return SafeArea(
            child: Container(
              height: Get.height * 0.17,
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data[index];
                  return InkWell(
                    onTap: (){
                      Get.to(CategoryData(name: data['name'].toString(),));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      width: Get.width * 0.2,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(5),
                              color: appcolor().lightgreyColor,
                              child: SvgPicture.network(
                                  data['icon_url'],
                                 // colorFilter: ColorFilter.mode( BlendMode.srcIn),
                                  semanticsLabel: 'A red up arrow'
                              ),
                          ),
                          SizedBox(
                            height: Get.height * 0.015,
                          ),
                          Text(
                            data['name'].toString(),
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
        return CircularProgressIndicator();
      });
    

}

Widget Featured_Businesses_List() {
  return  FutureBuilder(
      future: api().bussiness('shops', 1),
      builder: (context, snapshot){
    if(snapshot.hasError){
      return Center(child:Text('Data not found'),);
    }else if(snapshot.hasData){
      return  Container(
        height: Get.height * 0.365,
        color: Colors.white,
        child: ListView.builder(
          primary: false,
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            var data = snapshot.data[index];
            return InkWell(
              onTap: (){
                Get.to(errandia_business_view(index: index));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: Get.width * 0.4,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: appcolor().lightgreyColor,
                      child: Image(
                        image: NetworkImage(
                          data['image'].toString(),
                        ),fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.009,
                    ),
                    Text(
                      Featured_Businesses_Item_List[index].servicetype.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          // fontWeight: FontWeight.bold,
                          color: appcolor().mediumGreyColor),
                    ),
                    SizedBox(
                      height: Get.height * 0.001,
                    ),
                    Text(
                     data['name'].toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: appcolor().mainColor),
                    ),
                    SizedBox(
                      height: Get.height * 0.001,
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        Text(data['street'],style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }else{
      return Center(child: CircularProgressIndicator(),);
    }
  });
}


Widget Recently_posted_items_Widget() {
  return FutureBuilder(
      future: api().getProduct('products', 1),
      builder: (context,snapshot){
    if(snapshot.hasError){
      return Center(child: Text('No data found'),);
    }else if(snapshot.hasData){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14),
        height: Get.height * 0.47,
        color: Colors.white,
        child: ListView.builder(
          primary: false,
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            var data = snapshot.data[index];
            return InkWell(onTap: (){
              Get.to(Product_view(item: data,name: data['name'].toString(),));
            },
              child: Card(
                child: Container(
                  width: Get.width * 0.5,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Get.height * 0.09,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                data['shop']['image'].toString(),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data['shop']['name'].toString(),
                                  style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                // Text(
                                //   Recently_item_List[index].date.toString(),
                                //   style: TextStyle(fontSize: 12),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: appcolor().mediumGreyColor,
                      ),
                      Container(
                        height: Get.height * 0.2,
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        color: appcolor().lightgreyColor,
                        child: Center(
                          child: Image(
                            image: NetworkImage(
                                data['featured_image'].toString()),
                            height: Get.height * 0.15,
                          ),
                        ),
                      ),
                      Divider(
                        color: appcolor().mediumGreyColor,
                      ),
                      SizedBox(
                        height: Get.height * 0.009,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   Featured_Businesses_Item_List[index]
                            //       .servicetype
                            //       .toString(),
                            //   style: TextStyle(
                            //       fontSize: 13,
                            //       fontWeight: FontWeight.bold,
                            //       color: appcolor().mediumGreyColor),
                            // ),
                            // SizedBox(
                            //   height: Get.height * 0.001,
                            // ),
                            Text(
                             data['name'].toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: appcolor().mainColor),
                            ),
                            SizedBox(
                              height: Get.height * 0.001,
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_on),
                                Text(
                                 data['shop']['street'].toString(),
                                  style: TextStyle(color: appcolor().mainColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }else{
      return Center(child: CircularProgressIndicator(),);
    }
      });
    
    

}
