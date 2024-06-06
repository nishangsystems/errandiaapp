import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/errands/view/posted_errands_view.dart';
import 'package:errandia/app/modules/errands/view/received_errands_view.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageErrandsPage extends StatefulWidget {
  const ManageErrandsPage({super.key});

  @override
  _ManageErrandsPageState createState() => _ManageErrandsPageState();
}

class _ManageErrandsPageState extends State<ManageErrandsPage> {
  late home_controller homeController;
  late business_controller businessController;
  late profile_controller profileController;

  @override
  void initState() {
    homeController = Get.put(home_controller());
    businessController = Get.put(business_controller());
    profileController = Get.put(profile_controller());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomEndDrawer(
        onBusinessCreated: () {
          homeController.closeDrawer();
          homeController.featuredBusinessData.clear();
          homeController.fetchFeaturedBusinessesData();
          businessController.itemList.clear();
          businessController.loadBusinesses();
          homeController.recentlyPostedItemsData.clear();
          homeController.fetchRecentlyPostedItemsData();
          profileController.itemList.clear();
          profileController.loadMyBusinesses();
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Manage Errands',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height * 0.83,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              GestureDetector(
                onTap: () {
                  Get.to(() => const PostedErrandsView());
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/posted-errand.png',
                      height: 150,
                      width: 150,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Posted Errands',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ReceivedErrandsView());
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/received-errand.png',
                      height: 150,
                      width: 150,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Received Errands',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Select an option to manage your posted or received errands.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
