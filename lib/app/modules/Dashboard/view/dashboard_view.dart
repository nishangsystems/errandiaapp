import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/modules/buiseness/controller/business_controller.dart';
import 'package:errandia/app/modules/buiseness/view/add_business_view.dart';
import 'package:errandia/app/modules/errands/view/manage_errands_page.dart';
import 'package:errandia/app/modules/global/Widgets/CustomDialog.dart';
import 'package:errandia/app/modules/global/Widgets/account_suspended_widget.dart';
import 'package:errandia/app/modules/global/Widgets/appbar.dart';
import 'package:errandia/app/modules/global/Widgets/customDrawer.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/home/controller/home_controller.dart';
import 'package:errandia/app/modules/products/view/add_product_view.dart';
import 'package:errandia/app/modules/profile/controller/profile_controller.dart';
import 'package:errandia/app/modules/services/view/add_service_view.dart';
import 'package:errandia/app/modules/services/view/manage_service_view.dart';
import 'package:errandia/app/modules/subscription/view/manage_subscription_view.dart';
import 'package:errandia/auth_services/firebase_auth_services.dart';
import 'package:errandia/main.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../buiseness/view/manage_business_view.dart';
import '../../global/Widgets/bottomsheet_item.dart';
import '../../products/view/manage_products_view.dart';

profile_controller profileController = Get.put(profile_controller());
home_controller homeController = Get.put(home_controller());
business_controller businessController = Get.put(business_controller());

class dashboard_view extends StatefulWidget {
  const dashboard_view({super.key});

  @override
  dashboard_viewState createState() => dashboard_viewState();
}

class dashboard_viewState extends State<dashboard_view> {
  final isDialOpen = ValueNotifier(false);

  void deleteAccount(BuildContext context) {
    // show dialog to confirm account delete
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        var response;
        return CustomAlertDialog(
          title: 'Delete Account',
          message: 'Are you sure you want to delete your account?',
          dialogType: MyDialogType.error,
          onConfirm: () async {
            // delete account
            print("deleting user account");
            await api().deleteUserAccount(context).then((_) {
              Get.back();
            });
          },
          onCancel: () {
            Get.back();
          },
        );
      },
    ).then((_) async {
      // if account is deleted, log out user
      print("trying to logout");
      if (ErrandiaApp.prefs.getString('user') == null) {
        await ErrandiaApp.prefs.clear().then((_) {
          Get.snackbar(
            'Account Deleted',
            'Your account has been deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.cyan[900],
            colorText: Colors.white,
          );
          AuthService.logout();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        profileController.reloadMyProducts();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xfffafafa),
        appBar: appbar(),
        endDrawer: CustomEndDrawer(
          onBusinessCreated: () {
            home_controller().closeDrawer();
            home_controller().featuredBusinessData.clear();
            home_controller().fetchFeaturedBusinessesData();
            business_controller().itemList.clear();
            business_controller().loadBusinesses();
            home_controller().recentlyPostedItemsData.clear();
            home_controller().fetchRecentlyPostedItemsData();
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, bottom: 5, top: 7),
                child: Text(
                  'My Dashboard',
                  style: TextStyle(
                      color: appcolor().mainColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(),
              SizedBox(
                height: Get.height * 0.23,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1 / 1,
                  crossAxisCount: 2,
                  children: [
                    dashboard_widget(
                      Imagepath: 'assets/images/sidebar_icon/icon-company.png',
                      title: 'Manage Businesses',
                      belowText: '0 Businesses',
                      color: appcolor().mainColor,
                      callback: () {
                        // Get.offAll(Home_view());
                        Get.to(() => manage_business_view());
                      },
                    ),
                    dashboard_widget(
                      Imagepath:
                          'assets/images/sidebar_icon/icon-manage-products.png',
                      title: 'Manage Products',
                      belowText: '0 Products',
                      color: Colors.green,
                      callback: () {
                        // Get.back();
                        Get.to(() => manage_product_view());
                      },
                    ),

                    // dashboard_widget(
                    //   Imagepath: 'assets/images/sidebar_icon/icon-reviews.png',
                    //   title: 'Reviews',
                    //   belowtext: '0 Reviews',
                    //   callback: () {
                    //     Get.to(()=>manage_review_view());
                    //   },
                    // ),
                    // dashboard_widget(
                    //   Imagepath:
                    //       'assets/images/sidebar_icon/icon-profile-subscribers.png',
                    //   title: 'Subscribers',
                    //   belowtext: '0 Subscribers',
                    //   callback: () {
                    //     Get.to(() => subscriber_view());
                    //   },
                    // ),
                    // dashboard_widget(
                    //   Imagepath:
                    //       'assets/images/sidebar_icon/icon-profile-following.png',
                    //   title: 'Following',
                    //   belowtext: '0 Following',
                    //   callback: () {
                    //     Get.to(() => const following_view());
                    //   },
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 5),
              // const Divider(),
              // SizedBox(
              //   height: Get.height * 0.2,
              //   child: GridView.count(
              //     physics: const NeverScrollableScrollPhysics(),
              //     crossAxisSpacing: 1,
              //     childAspectRatio: 1 / 1.3,
              //     crossAxisCount: 3,
              //     children: [
              //       dashboard_widget(
              //           Imagepath:
              //               'assets/images/sidebar_icon/icon-business-branches.png',
              //           title: 'Business Branches',
              //           belowtext: '0 Branches',
              //           callback: () {}),
              //       dashboard_widget(
              //           Imagepath: 'assets/images/sidebar_icon/icon-manager.png',
              //           title: 'Branch Managers',
              //           belowtext: '0 Managers',
              //           callback: () {}),
              //     ],
              //   ),
              // ),
              // const Divider(),
              SizedBox(
                height: Get.height * 0.23,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 1,
                  childAspectRatio: 1 / 1,
                  crossAxisCount: 2,
                  children: [
                    dashboard_widget(
                      Imagepath: 'assets/images/sidebar_icon/services.png',
                      title: 'Manage \nServices',
                      belowText: '0 Services',
                      color: Colors.orange,
                      callback: () {
                        // Get.back();
                        Get.to(() => manage_service_view());
                      },
                    ),
                    dashboard_widget(
                      Imagepath:
                          'assets/images/sidebar_icon/icon-profile-errands.png',
                      title: 'Errands',
                      belowText: '0 Errands',
                      color: Colors.blue[700],
                      callback: () {
                        Get.to(() => const ManageErrandsPage());
                      },
                    ),

                    // dashboard_widget(
                    //     Imagepath:
                    //         'assets/images/sidebar_icon/icon-dashboard-smsplan.png',
                    //     title: 'SMS Plan',
                    //     belowtext: 'No Plan',
                    //     callback: () {
                    //       Get.to(sms_plan_view());
                    //     }),
                  ],
                ),
              ),

              const SizedBox(height: 5),
              // const Divider(),
              SizedBox(
                height: Get.height * 0.23,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 1,
                  childAspectRatio: 1 / 1,
                  crossAxisCount: 2,
                  children: [
                    dashboard_widget(
                        Imagepath:
                            'assets/images/sidebar_icon/icon-dashboard-subscription-plan.png',
                        title: 'Subscription',
                        belowText: 'Ongoing',
                        color: Colors.purple,
                        callback: () {
                          Get.to(() => const subscription_view());
                        }),
                    dashboard_widget(
                        Imagepath: 'assets/images/delete_account.png',
                        title: 'Delete Account',
                        belowText: '0 complete',
                        color: Colors.red,
                        callback: () {
                          deleteAccount(context);
                        }),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // a text saying to contact support if there is any issue
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'If you have any issues, please ',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    children: [
                      const TextSpan(
                        text: 'call us at ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchCaller('+237679135426');
                          },
                        text: '+237 679 135 426 ',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                      const TextSpan(
                        text: 'or ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const TextSpan(
                        text: 'write us on ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      // what's app
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchWhatsapp('+237679135426',
                                message:
                                    "Hello Errandia, \nI need help with...");
                          },
                        text: '\u{1F4AC} WhatsApp',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ).paddingSymmetric(vertical: 10),
            ],
          ),
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }
}

Widget dashboard_widget({
  required String Imagepath,
  required String title,
  required String belowText,
  required Color? color,
  required Callback callback,
}) {
  return InkWell(
    onTap: callback,
    child: Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: color,
      shadowColor: Colors.white38,
      surfaceTintColor: Colors.white,
      semanticContainer: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        // height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 45,
              child: Image(
                image: AssetImage(
                  Imagepath,
                ),
                color: Colors.white,
                fit: BoxFit.fill,
              ),
            ),
            // SizedBox(height: Get.height,)
            Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                // Text(
                //   belowText,
                //   style: const TextStyle(
                //     fontSize: 11,
                //     color: Colors.grey,
                //     fontWeight: FontWeight.w400,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void custombottomsheet(BuildContext context) {
  Get.bottomSheet(
    // backgroundColor: Colors.white,
    Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          Icon(
            Icons.horizontal_rule,
            size: 25,
          ),
          bottomSheetWidgetitem(
            title: 'Add New Errand',
            imagepath: 'assets/images/sidebar_icon/icon-profile-errands.png',
            callback: () async {
              print('tapped');
              Get.back();
              showDialog(
                  context: context,
                  builder: (context) {
                    return account_suspended_widget();
                  });
            },
          ),
          bottomSheetWidgetitem(
            title: 'Add New Product',
            imagepath: 'assets/images/sidebar_icon/icon-manage-products.png',
            callback: () {
              Get.back();
              Get.to(() => add_product_view())?.then((_) {
                profileController.reloadMyProducts();
              });
            },
          ),
          bottomSheetWidgetitem(
            title: 'Add New Service',
            imagepath: 'assets/images/sidebar_icon/services.png',
            callback: () {
              Get.back();
              Get.to(() => add_service_view())?.then((_) {
                profileController.reloadMyProducts();
              });
            },
          ),
          bottomSheetWidgetitem(
            title: 'Add New Business',
            imagepath: 'assets/images/sidebar_icon/create_shop.png',
            callback: () {
              Get.back();
              Get.to(() => add_business_view())?.then((_) {
                businessController.reloadBusinesses();
                profileController.reloadMyBusinesses();
                homeController.featuredBusinessData.clear();
                homeController.fetchFeaturedBusinessesData();
              });
            },
          ),
        ],
      ),
    ),

    enableDrag: true,
  );
}
