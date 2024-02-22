import 'package:errandia/app/modules/auth/Register/register_signin_screen.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view.dart';
import 'package:errandia/app/modules/auth/Sign%20in/view/signin_view_1.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/view/businesses_view.dart';
import 'package:errandia/app/modules/errands/view/errand_view.dart';
import 'package:errandia/app/modules/errands/view/errand_view_no_bar.dart';
import 'package:errandia/app/modules/errands/view/see_all_erands.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/categories/view/categories.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/home/view/home_view_1.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/profile/view/profile_view.dart';
import 'package:errandia/common/random_ui/ui_23.dart';
import 'package:errandia/app/modules/errands/view/run_an_errand.dart';
import 'package:errandia/app/modules/products/view/product_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/Sign in/controller/signin_controller.dart';

// import '../../buiseness/view/buiseness_view.dart';
import '../../categories/view/categories_item.dart';
import '../../buiseness/featured_buiseness/view/featured_list_item.dart';
import '../../recently_posted_item.dart/view/recently_posted_list.dart';

class Home_view extends StatefulWidget {
  Home_view({super.key});

  @override
  State<Home_view> createState() => _Home_viewState();
}

class _Home_viewState extends State<Home_view> with WidgetsBindingObserver {
  String? isLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    locationPermission();
    loadIsLoggedIn();
    _initTabList();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      homecontroller.featuredBusinessData.clear();
      homecontroller.fetchFeaturedBusinessesData();
      homecontroller.recentlyPostedItemsData.clear();
      homecontroller.fetchRecentlyPostedItemsData();
    }
  }

  void loadIsLoggedIn() async {
    isLoggedIn = await checkLogin();
    homecontroller.loggedIn.value =
        isLoggedIn != null && isLoggedIn!.isNotEmpty;

    print('INIT: Is logged in: $isLoggedIn');
  }

  void locationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      Permission.location.request();
    }
  }

  Future<String?> checkLogin() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedpref.getString('token');
    print('Is logged in: $isLoggedIn');
    return isLoggedIn;
  }

  final singin_controller = Get.lazyPut(() => signIn_controller());
  home_controller homecontroller = Get.put(home_controller());

  RxInt _index = 0.obs;
  late final List<Widget> tabList;

  void _initTabList() {
    tabList = [
      home_view_1(),
      run_an_errand(),
      ErrandViewWithoutBar(),
      Obx(() => homecontroller.loggedIn.value ? const Profile_view() : signin_view_1())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      key: homecontroller.scaffoldkey,
      endDrawer: CustomEndDrawer(onBusinessCreated: () {
        profile_controller().reloadMyBusinesses();
        homecontroller.closeDrawer();
        homecontroller.featuredBusinessData.clear();
        homecontroller.fetchFeaturedBusinessesData();
        business_controller().itemList.clear();
        business_controller().loadBusinesses();
        homecontroller.recentlyPostedItemsData.clear();
        homecontroller.fetchRecentlyPostedItemsData();
        profile_controller().reloadMyBusinesses();
      },),
      body: Obx(
        () {
          return tabList[_index.value];
        },
      ),
      bottomNavigationBar: Obx(
        () {
          return NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: appcolor().mainColor,
              iconTheme: MaterialStateProperty.all(
                const IconThemeData(
                  color: Colors.white,
                  size: 35,
                ),
              ),
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            child: NavigationBar(
              selectedIndex: _index.value,
              onDestinationSelected: (index) {
                debugPrint(index.toString());
                _index.value = index;

                if (_index.value == 4) {
                  homecontroller.openDrawer();
                } else if (_index.value == 3) { // Assuming index 3 is the profile tab
                  print("profile tab selected");
                  profile_controller().loadMyBusinesses(); // Reload businesses when the profile tab is selected
                }
                debugPrint(_index.value.toString());
              },
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                NavigationDestination(
                  icon: Image(
                    image: const AssetImage(
                      'assets/images/sidebar_icon/icon-profile-errands.png',
                    ),
                    height: Get.height * 0.03,
                    color: Colors.white,
                  ),
                  label: 'Errands',
                ),
                NavigationDestination(
                  icon: Obx(() => Icon(
                        homecontroller.loggedIn.value
                            ? Icons.person
                            : Icons.login)
                  ),
                  label: homecontroller.loggedIn.value ? 'Profile' : 'Login',
                ),
                // NavigationDestination(
                //   icon: Icon(Icons.more_horiz_outlined),
                //   label: 'More',
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
