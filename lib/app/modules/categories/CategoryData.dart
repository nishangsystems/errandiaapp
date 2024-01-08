import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global/constants/color.dart';
import '../products/view/product_view.dart';
import '../recently_posted_item.dart/view/recently_posted_list.dart';

class CategoryData extends StatefulWidget {
  final name;
  CategoryData({super.key, this.name});

  @override
  State<CategoryData> createState() => _CategoryData(name);
}

class _CategoryData extends State<CategoryData> {
  home_controller homeController = Get.put(home_controller());
    final name;
  _CategoryData(this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          '${name.toString()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff113d6b),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xff113d6b),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
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

      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: appcolor().mainColor,
      //   unselectedItemColor: appcolor().mainColor,
      //   fixedColor: appcolor().mainColor,
      //   showUnselectedLabels: true,
      //   items: [
      //     BottomNavigationBarItem(
      //       label: 'Home',
      //       icon: new SizedBox(
      //         child: Icon(
      //           Icons.home_filled,
      //           size: 35,
      //         ),
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'errand',
      //       icon: Icon(
      //         Icons.search,
      //         size: 35,
      //       ),
      //     ),
      //     new BottomNavigationBarItem(
      //       label: 'Buiseness',
      //       icon: Image(
      //         image: AssetImage(
      //           'assets/images/shop.png',
      //         ),
      //         fit: BoxFit.fill,
      //         height: Get.height * 0.04,
      //         color: appcolor().mainColor,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(
      //         Icons.person,
      //         size: 35,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'More',
      //       icon: Icon(
      //         Icons.more_horiz_outlined,
      //         size: 35,
      //       ),
      //     ),
      //   ],
      // ),
      // bottomNavigationBar: NavigationBarTheme(
      //   data: NavigationBarThemeData(
      //     backgroundColor: appcolor().mainColor,
      //     iconTheme: MaterialStateProperty.all(
      //         IconThemeData(color: Colors.white, size: 35)),
      //     labelTextStyle: MaterialStateProperty.all(
      //       TextStyle(
      //         fontWeight: FontWeight.w400,
      //         fontSize: 12,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      //   child: NavigationBar(
      //     selectedIndex: homeController.index.value,
      //     onDestinationSelected: (index) {
      //       debugPrint(homeController.index.value.toString());
      //       setState(() {
      //         homeController.index.value = index;
      //       });
      //     },
      //     destinations: [
      //       NavigationDestination(
      //         icon: Icon(Icons.home),
      //         label: 'Home',
      //       ),
      //       NavigationDestination(
      //         icon: Icon(Icons.search),
      //         label: 'Search',
      //       ),
      //       NavigationDestination(
      //         icon: Image(
      //           image: AssetImage(
      //             'assets/images/shop.png',
      //           ),
      //           height: Get.height * 0.03,
      //           color: Colors.white,
      //         ),
      //         label: 'Buiseness',
      //       ),
      //       NavigationDestination(
      //         icon: Icon(Icons.person),
      //         label: 'Profile',
      //       ),
      //       NavigationDestination(
      //         icon: Icon(Icons.more_horiz_outlined),
      //         label: 'More',
      //       ),
      //     ],
      //   ),
      // ),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 0,
              top: 5,
            ),
            height: Get.height * 0.09,
            child: FutureBuilder(
              future: api().GetData('sub_categories'),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text('Server Error');
                }else if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if(snapshot.hasData){
                  return ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
                      return horizontal_list_item(data);
                    },
                  );
                }else {
                  return Center(child: CircularProgressIndicator());
                }

              },
            )



          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 255, 255, 255),
                child: GridView.count(
                  childAspectRatio: (1 / 1.4),
                  crossAxisCount: 2,
                  children: List.generate(ui_23_item_list.length, (index) {
                    return InkWell(
                      onTap: (){
                        Get.to(Product_view(item: Recently_item_List[index],));
                      },
                      child: Card(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          height: Get.height * 0.8,
                          // color: Colors.blue,
                          width: Get.width * 0.4,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // height: Get.height * 0.2,

                                  // decoration: BoxDecoration(
                                  //   color: Colors.black

                                  // ),
                                  child: Center(
                                    child: Image(
                                      image: AssetImage(
                                        ui_23_item_list[index].imagePath,
                                      ),
                                      height: Get.height * 0.12,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: appcolor().mediumGreyColor,
                                    ),
                                    Text(
                                      ui_23_item_list[index].location.toString(),
                                      style: TextStyle(
                                          color: appcolor().mediumGreyColor,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                                Text(
                                  ui_23_item_list[index].item_desc,
                                  style: TextStyle(
                                      fontSize: 12, color: appcolor().mainColor),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  ui_23_item_list[index].itemname,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: appcolor().mainColor,
                                      fontSize: 16
                                  ),
                                )
                              ],
                            ),
                          ),
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

Widget horizontal_list_item(var data) {
  return InkWell(
    onTap: () {},
    hoverColor: Colors.blue,
    focusColor: appcolor().blueColor,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      // height: Get.height * 0.06,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text('${data['name']}')),
    ),
  );
}

class ui_23_items {
  int id = 0;
  String imagePath = "";
  String location = "";
  String item_desc = "";

  String itemname = "";

  ui_23_items(int Id, String ImagePath, String Item_desc, String Itemname,
      String Location) {
    id = Id;
    imagePath = ImagePath;
    item_desc = Item_desc;
    itemname = Itemname;
    location = Location;
  }
}

List<ui_23_items> ui_23_item_list = [
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Slick Gorilla Clay Pomade 70 gm",
    "XAF 10,000",
    "Molyko, Buea",
  ),
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Beauty & Hairs",
    "XAF 10,000",
    "Molyko, Buea",
  ),
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Beauty & Hairs",
    "XAF 10,000",
    "Molyko, Buea",
  ),
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Beauty & Hairs",
    "XAF 10,000",
    "Molyko, Buea",
  ),
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Beauty & Hairs",
    "XAF 10,000",
    "Molyko, Buea",
  ),
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Beauty & Hairs",
    "XAF 10,000",
    "Molyko, Buea",
  ),
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Beauty & Hairs",
    "XAF 10,000",
    "Molyko, Buea",
  ),
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Beauty & Hairs",
    "XAF 10,000",
    "Molyko, Buea",
  ),
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Beauty & Hairs",
    "XAF 10,000",
    "Molyko, Buea",
  ),
  ui_23_items(
    0,
    "assets/images/ui_23_item.png",
    "Beauty & Hairs",
    "XAF 10,000",
    "Molyko, Buea",
  ),
];
