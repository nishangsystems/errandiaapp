import 'package:errandia/app/modules/global/Widgets/buildErrorWidget.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/controller/subscription_controller.dart';
import 'package:errandia/app/modules/subscription/view/new_subscription.dart';
import 'package:errandia/app/modules/subscription/view/renew_subscription.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class subscription_view extends StatefulWidget {
  const subscription_view({Key? key}) : super(key: key);

  @override
  subscription_viewState createState() => subscription_viewState();
}

class subscription_viewState extends State<subscription_view>
    with WidgetsBindingObserver {
  subscription_controller controller = Get.put(subscription_controller());
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadSubscriptions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.reloadSubscriptions();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Get.arguments != null) {
      Get.arguments.listen((data) {
        if (data == 'Reload Subscriptions') {
          controller.reloadSubscriptions();
        }
      });
    }
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: Obx(() {
        if (controller.subscriptionList.isEmpty) {
          return Container();
        } else {
          return FloatingActionButton.extended(
            onPressed: () {
              Get.to(
                    () => const NewSubscription(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 500),
              );
            },
            backgroundColor: appcolor().mainColor,
            icon: Icon(
              Icons.add,
              color: appcolor().skyblueColor,
            ),
            // Adjust text style directly within the label for better alignment and padding
            label:Text(
                controller.subscriptionList.isEmpty ? 'Subscribe Now' : 'New',
                style: TextStyle(
                  color: appcolor().skyblueColor,
                  fontSize: 15,
                )),
          );
        }
      }),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            // size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Manage Subscription',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
          size: 30,
        ),
        actions: const [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.settings,
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.isSubscriptionsLoading.isTrue) {
              return SizedBox(
                height: Get.height * 0.8,
                child: buildLoadingWidget(),
              );
            } else if (controller.subscriptionList.isEmpty) {
              return Container(
                height: Get.height * 0.8,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: buildErrorWidget(
                  message:
                      'You have no active subscription.\n Subscribe now to enjoy our services.',
                  actionText: '',
                  callback: () {},
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  itemCount: controller.subscriptionList.length,
                  itemBuilder: (context, index) {
                    var item = controller.subscriptionList[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 245, 238, 238),
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                            ),
                            // height: 60,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: Icon(
                              Icons.file_copy,
                              color: item['expired'] == 1
                                  ? appcolor().redColor
                                  : appcolor().greenColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: appcolor().mediumGreyColor,
                                    fontSize: 17,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: item['description'],
                                      style: TextStyle(
                                        color: appcolor().mainColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Subscription ',
                                style: TextStyle(
                                  color: appcolor().mediumGreyColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Expires: ',
                                    style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  item['expired_at'] != null
                                      ? Text(
                                          formatDate(DateTime.parse(
                                              item['expired_at'])),
                                          style: TextStyle(
                                              color: item['expired'] == 1
                                                  ? appcolor().redColor
                                                  : appcolor().greenColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : Text(
                                          'N/A',
                                          style: TextStyle(
                                            color: appcolor().mainColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Status: ',
                                    style: TextStyle(
                                        color: appcolor().mediumGreyColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    item['expired'] == 1 ? 'Expired' : 'Active',
                                    style: TextStyle(
                                        color: item['expired'] == 1
                                            ? appcolor().redColor
                                            : appcolor().greenColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ).paddingOnly(left: 5),
                          const Spacer(),
                          // show amount of the subscription
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatPrice(
                                    double.parse(item['amount'].toString())),
                                style: TextStyle(
                                  color: appcolor().mainColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ).paddingOnly(top: 8)

                          // IconButton(
                          //   onPressed: () {
                          //     Get.bottomSheet(customBottomSheet(item));
                          //   },
                          //   icon: const Icon(
                          //     Icons.more_vert,
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          })
        ],
      ),
    );
  }
}

Widget customBottomSheet(item) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 15,
    ),
    color: Colors.white,
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        const Icon(
          Icons.horizontal_rule_outlined,
          size: 30,
        ),
        SizedBox(
          height: Get.height * 0.06,
        ),
        InkWell(
          onTap: () {
            Get.back();
            Get.to(() => RenewSubscription(subscriptionData: item));
          },
          child: const Row(
            children: [
              Icon(
                FontAwesomeIcons.rotate,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Renew Subscription',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 10),
        ),
        InkWell(
          onTap: () {},
          child: Row(
            children: [
              Icon(FontAwesomeIcons.rectangleXmark, color: appcolor().redColor),
              const SizedBox(
                width: 20,
              ),
              Text(
                'Cancel Subscription',
                style: TextStyle(
                  fontSize: 16,
                  color: appcolor().redColor,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10, vertical: 15),
        ),
        Container(
          height: 15,
        ),
      ],
    ),
  );
}
