import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view_1.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/errands/view/errand_view_no_bar.dart';
import 'package:errandia/app/modules/errands/view/run_an_errand.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/home/view/home_view_1.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/profile/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Home_view extends StatefulWidget {
  Home_view({super.key});

  @override
  State<Home_view> createState() => _Home_viewState();
}

class _Home_viewState extends State<Home_view> with WidgetsBindingObserver {
  late business_controller businessController;
  final home_controller homeController = Get.put(home_controller());
  late profile_controller profileController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    profileController = Get.put(profile_controller());
    businessController = Get.put(business_controller());
    requestLocationPermission();
    homeController.checkLoginStatus();
  }

  void requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      Permission.location.request();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      homeController.checkLoginStatus();
      homeController.reloadRecentlyPostedItems();
      homeController.reloadFeaturedBusinessesData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      endDrawer: CustomEndDrawer(onBusinessCreated: () {
        profileController.reloadMyBusinesses();
        homeController.closeDrawer();
        homeController.featuredBusinessData.clear();
        homeController.fetchFeaturedBusinessesData();
        businessController.itemList.clear();
        businessController.loadBusinesses();
        homeController.recentlyPostedItemsData.clear();
        homeController.fetchRecentlyPostedItemsData();
        profileController.reloadMyBusinesses();
      },),
      body: Obx(() => _buildBody()),
      bottomNavigationBar: Obx(() => _buildBottomNavigationBar()),
    );
  }

  Widget _buildBody() {
    List<Widget> pages = [
      home_view_1(),
      const run_an_errand(),
      homeController.isLoggedIn.value ? ErrandViewWithoutBar() : signin_view_1(),
      homeController.isLoggedIn.value ? Profile_view() : Container()
    ];

    return IndexedStack(
      index: homeController.currentIndex.value,
      children: pages,
    );
  }

  Widget _buildIcon(IconData iconData, String text, int index) => Container(
    width: double.infinity,
    height: Get.height * 0.08,
    child: Material(
      color: index == homeController.currentIndex.value
          ? Colors.blueGrey.withOpacity(0.3)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData),
            Text(text,
                style: const TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
        onTap: () => homeController.changePage(index),
      ),
    ),
  );

  Widget _buildBottomNavigationBar() {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(icon: _buildIcon(Icons.home, 'Home', 0), label: ''),
      BottomNavigationBarItem(icon: _buildIcon(Icons.search, 'Search', 1), label: ''),
    ];

    if (homeController.loggedIn.value) {
      items.add(
        BottomNavigationBarItem(icon: _buildIcon(Icons.list, 'Errands', 2), label: ''),
      );
      items.add(
        BottomNavigationBarItem(icon: _buildIcon(Icons.person, 'Profile', 3), label: ''),
      );
    } else {
      items.add(
        BottomNavigationBarItem(icon: _buildIcon(Icons.login, 'Login', 2), label: ''),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: appcolor().mainColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: homeController.currentIndex.value,
        onTap: (index) => homeController.changePage(index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: appcolor().mainColor,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: items,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // height
        selectedFontSize: 0,
        elevation: 0,


      ).paddingAll(10),
    );
  }
}
