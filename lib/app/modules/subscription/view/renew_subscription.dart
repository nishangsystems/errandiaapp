
import 'dart:convert';

import 'package:errandia/app/APi/subscription.dart';
import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/app/modules/subscription/controller/subscription_controller.dart';
import 'package:errandia/app/modules/subscription/view/subscription_processing_view.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RenewSubscription extends StatefulWidget {
  final subscriptionData;
  const RenewSubscription({super.key, this.subscriptionData});

  @override
  State<RenewSubscription> createState() => _RenewSubscriptionState();
}

class _RenewSubscriptionState extends State<RenewSubscription> {
  // RxString subscription_type_group_value = 'yearly'.obs;
  RxString payment_group_value = 'mtn'.obs;
  subscription_controller controller = Get.put(subscription_controller());

  var planSelected;
  var momoPhoneNumber;
  var filteredCountries = ["CM"];
  bool isPaymentLoading = false;

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

    print("Subscription Data: ${widget.subscriptionData}");

    controller.loadSubscriptionPlans();

    setState(() {
      planSelected = widget.subscriptionData;
      print("plan set: $planSelected");

      controller.subscriptionController.text = widget.subscriptionData != null ? widget.subscriptionData['description'].toString() : '';
    });
  }

  void makePaymentRequest(BuildContext context) async {

    if (controller.subscriptionSelected.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a subscription plan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: appcolor().redColor,
        colorText: Colors.white,
      );
      return;
    }

    if (momoPhoneNumber == null || momoPhoneNumber.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your mobile money number',
        snackPosition: SnackPosition.TOP,
        backgroundColor: appcolor().redColor,
        colorText: Colors.white,
      );
      return;
    }

    var value = {
      'phone_number': momoPhoneNumber,
      'plan_id': controller.subscriptionSelected['id'],
    };

    print("Payment Data: $value");

    setState(() {
      isPaymentLoading = true;
    });

    await SubscriptionAPI.subscribeToPlan(value).then((response) {
      print("Response: $response");
      var data = jsonDecode(response);
      if (data != null && data.isNotEmpty) {
        if (data['status'] == 'success') {
          print("Payment Data: ${data}");
          setState(() {
            isPaymentLoading = false;
          });
          Get.to(() => payment_processing_view(paymentData: controller.subscriptionSelected));
        } else {
          setState(() {
            isPaymentLoading = false;
          });
          Get.snackbar(
            'Error',
            data['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: appcolor().redColor,
            colorText: Colors.white,
          );
        }
      }
    }).catchError((e) {
      print("Error: $e");
      setState(() {
        isPaymentLoading = false;
      });
      Get.snackbar(
        'Error',
        'An error occurred, please try again later',
        snackPosition: SnackPosition.TOP,
        backgroundColor: appcolor().redColor,
        colorText: Colors.white,
      );
    }).whenComplete(() {
      setState(() {
        isPaymentLoading = false;
      });
    });

  }

  Widget build(BuildContext) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text(
            'Renew Subscription',
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

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: TextFormField(
                  readOnly: true,
                  controller: controller.subscriptionController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      color: Colors.black,
                      Icons.subscriptions_outlined,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    // suffixIcon: Icon(
                    //   color: Colors.black,
                    //   Icons.edit,
                    // ),
                  ),
                ),
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
                    Text(
                      formatPrice(double.parse(widget.subscriptionData['amount'].toString())),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: appcolor().mainColor,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: Get.height * 0.03,
              ),

              InkWell(
                onTap: !isPaymentLoading ? () {
                  makePaymentRequest(context);
                } : null,
                child: Container(
                    height: Get.height * 0.07,
                    decoration: BoxDecoration(
                      color: appcolor().mainColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: appcolor().mainColor.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isPaymentLoading ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ) : const Text(
                        'RENEW NOW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ).paddingOnly(left: 10, right: 10, top: 30, bottom: 5),
              )
            ],
          ),
        ),
      ),
    );
  }
}
