
import 'package:errandia/app/modules/global/Widgets/blockButton.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/controller/subscription_controller.dart';
import 'package:errandia/app/modules/subscription/view/subscription_processing_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class NewSubscription extends StatefulWidget {
  NewSubscription();

  @override
  State<NewSubscription> createState() => _NewSubscriptionState();
}

class _NewSubscriptionState extends State<NewSubscription> {
  // RxString subscription_type_group_value = 'yearly'.obs;
  RxString payment_group_value = 'mtn'.obs;
  subscription_controller controller = Get.put(subscription_controller());

  var planSelected;
  var momoPhoneNumber;
  var filteredCountries = ["CM"];

  List<Country> filter = [];


  @override
  void initState() {
    super.initState();

    countries.forEach((element) {
      filteredCountries.forEach((filteredC) {
        if (element.code == filteredC) {
          filter.add(element);
        }
      });
    });

    controller.loadSubscriptionPlans();
  }

  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          'New Subscription',
          style: TextStyle(color: appcolor().mediumGreyColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        iconTheme: IconThemeData(
          color: appcolor().mediumGreyColor,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // subscription type
            Container(
              width: Get.width,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              child: Text(
                'Subscription Type',
                style: TextStyle(
                  color: appcolor().darkBlueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // yearly
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: Border.all(
            //       color: appcolor().mediumGreyColor,
            //     ),
            //   ),
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 12,
            //     vertical: 5,
            //   ),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Yearly',
            //         style: TextStyle(
            //           fontSize: 16,
            //         ),
            //       ),
            //       const Spacer(),
            //       Obx(
            //         () => Radio(
            //           value: 'yearly',
            //           activeColor: appcolor().mainColor,
            //           groupValue: subscription_type_group_value.value,
            //           onChanged: (val) {
            //             subscription_type_group_value.value = val.toString();
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // // Monthly
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: Border(
            //       bottom: BorderSide(
            //         color: appcolor().mediumGreyColor,
            //       ),
            //     ),
            //   ),
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 12,
            //     vertical: 5,
            //   ),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Monthly',
            //         style: TextStyle(
            //           // color: appcolor().mainColor,
            //           fontSize: 16,
            //         ),
            //       ),
            //       const Spacer(),
            //       Obx(
            //         () => Radio(
            //           activeColor: appcolor().mainColor,
            //           value: 'monthly',
            //           groupValue: subscription_type_group_value.value,
            //           onChanged: (val) {
            //             subscription_type_group_value.value = val.toString();
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Subscription plans
            ListTile(
                leading: Container(
                  padding: const EdgeInsets.only(left: 12, right: 0),
                  child: const Icon(
                    Icons.subscriptions_outlined,
                    color: Colors.black,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.only(left: 0, right: 12),
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                title: Obx(
                        () {
                      if (controller.isPlansLoading.value) {
                        return Text('Loading...',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        );
                      } else if (controller.plansList.isEmpty){
                        return Text('No plans available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        );
                      } else {
                        return DropdownButtonFormField<dynamic>(
                          value: planSelected,
                          iconSize: 0.0,
                          isDense: true,
                          isExpanded: true,
                          padding: const EdgeInsets.only(bottom: 5),
                          decoration: const InputDecoration.collapsed(
                            hintText: "Select Plan *",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (dynamic newValue) {
                            setState(() {
                              planSelected = newValue;
                            });
                            print("Selected Plan: $planSelected");
                            controller.subscriptionSelected.value = newValue;
                          },
                          items: controller.plansList.map((plan) {
                            return DropdownMenuItem<dynamic>(
                              value: plan,
                              child: Text(plan['name'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  )
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }
                )
            ),

            const SizedBox(
              height: 15,
            ),

            // Select Payment Method
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: appcolor().mediumGreyColor,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              child: Text(
                'Enter Mobile Money Number',
                style: TextStyle(
                  color: appcolor().darkBlueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // MTN Mobile money
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: Border.all(
            //       color: appcolor().mediumGreyColor,
            //     ),
            //   ),
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 12,
            //     vertical: 5,
            //   ),
            //   child: Row(
            //     children: [
            //       const SizedBox(
            //         height: 30,
            //         child: Image(
            //           image: AssetImage(
            //             'assets/images/icon-payment-mtnMomo.png',
            //           ),
            //         ),
            //       ),
            //       const Text(
            //         '  MTN Mobile money',
            //         style: TextStyle(
            //           // color: appcolor().mainColor,
            //           fontSize: 16,
            //         ),
            //       ),
            //       const Spacer(),
            //       Obx(
            //             () => Radio(
            //           activeColor: appcolor().mainColor,
            //           value: 'mtn',
            //           groupValue: payment_group_value.value,
            //           onChanged: (val) {
            //             payment_group_value.value = val.toString();
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // mobile number container

            Container(
              decoration: BoxDecoration(
                color: appcolor().skyblueColor,
                border: Border(
                  bottom: BorderSide(
                    color: appcolor().mediumGreyColor,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              child: Row(
                children: [
                  // intl phone input
                  Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 0, left: 0),
                    child: SizedBox(
                      width: Get.width * 0.86,
                      child: IntlPhoneField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 12),
                          border: InputBorder.none,
                          counter: SizedBox(),
                          hintText: 'MTN or Orange Money Number *',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        keyboardType: TextInputType.number,
                        initialCountryCode: 'CM',
                        countries: filter,
                        showDropdownIcon: false,
                        dropdownTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        validator: (value) {
                          if (value == null) {
                            print(value);
                          }
                          return null;
                        },
                        onChanged: (phone) {
                          // add_controller.phone_controller.text = phone.completeNumber;
                          print("phone: ${phone.completeNumber}");
                          setState(() {
                            momoPhoneNumber = phone.completeNumber;
                          });
                        },
                      ),
                    )
                  )
                ]
              )
            ),
            // Orange Money
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     border: Border(
            //       bottom: BorderSide(
            //         color: appcolor().mediumGreyColor,
            //       ),
            //     ),
            //   ),
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 12,
            //     vertical: 5,
            //   ),
            //   child: Row(
            //     children: [
            //       const SizedBox(
            //         height: 30,
            //         child: Image(
            //           image: AssetImage(
            //             'assets/images/icon-payment-mtnMomoorange-money.png',
            //           ),
            //         ),
            //       ),
            //       const Text(
            //         '  Orange Money',
            //         style: TextStyle(
            //           // color: appcolor().mainColor,
            //           fontSize: 16,
            //         ),
            //       ),
            //       const Spacer(),
            //       Obx(
            //             () => Radio(
            //           activeColor: appcolor().mainColor,
            //           value: 'orange',
            //           groupValue: payment_group_value.value,
            //           onChanged: (val) {
            //             payment_group_value.value = val.toString();
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // cash renew

            // total subscription
            SizedBox(
              height: Get.height * 0.03,
            ),

            Container(
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.white,

              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              child: Text(
                'Subscription Price',
                style: TextStyle(
                  color: appcolor().darkBlueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Price
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: appcolor().mediumGreyColor,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              child: Row(
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Obx(
                      () {
                        if (controller.subscriptionSelected.isEmpty) {
                          return Text(
                            '0',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: appcolor().mainColor,
                            ),
                          );
                        } else {
                          return Text(
                            formatPrice(double.parse(controller.subscriptionSelected['unit_price'].toString())),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: appcolor().mainColor,
                            ),
                          );
                        }
                      }
                  )
                ],
              ),
            ),

            SizedBox(
              height: Get.height * 0.03,
            ),

            blockButton(
              title: const Text(
                'SUBSCRIBE',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,

                ),
              ),
              ontap: () {
                Get.to(() => const payment_processing_view());
              },
              color: appcolor().mainColor,
            ).paddingSymmetric(horizontal: 15, vertical: 30),
          ],
        ),
      ),
    );
  }
}
