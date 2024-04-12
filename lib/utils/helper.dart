
// capitalize string function
import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/APi/subscription.dart';
import 'package:errandia/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

// capitalize all words in a string
String capitalizeAll(String s) {
  // remove extra spaces in the string
  s = s.trim().replaceAll(RegExp(r'\s+'), ' ');

  List<String> words = s.split(' ');
  for (int i = 0; i < words.length; i++) {
    words[i] = capitalize(words[i]);
  }
  return words.join(' ');
}

// capitalize from uppercase
String capitalizeFromUpperCase(String s) {
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

// get the first letter of a string
String getFirstLetter(String s) => s[0].toUpperCase();

// get last name if the name is has multiple spaces
String getLastName(String s) {
  List<String> words = s.split(' ');
  return words[words.length - 1];
}

String getImagePath(String imagePath) {
  String sanitizedPath = imagePath.trim().replaceAll(RegExp(r'^"|"$'), '');
  try {
    if (sanitizedPath.startsWith("http")) {
      print('url image: $sanitizedPath');
      return sanitizedPath;
    } else {
      String finalUrl = '${apiDomain().imageDomain}/$sanitizedPath';
      print('final image: $finalUrl');
      return finalUrl;
    }
  } catch (e) {
    return '';
  }
}

// get image path with cloudimg width and height
String getImagePathWithSize(String imagePath, {int? width, int? height}) {
  String sanitizedPath = imagePath.trim().replaceAll(RegExp(r'^"|"$'), '');
  try {
    if (sanitizedPath.startsWith("http")) {
      print('url image: $sanitizedPath');
      return sanitizedPath;
    } else {
      String finalUrl = '${apiDomain().imageDomain}/$sanitizedPath';
      if (width != null && height != null) {
        finalUrl = '$finalUrl?w=$width&h=$height';
      }
      print('final image: $finalUrl');
      return finalUrl;
    }
  } catch (e) {
    return '';
  }
}

// launch caller
Future<void> launchCaller(String number) async {
  var url = Uri(scheme: 'tel', path: number);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

// launch whatsapp
Future<void> launchWhatsapp(String number) async {
  var url =  Uri.parse("https://wa.me/$number");
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

// launch email url
Future<void> launchEmail(String email) async {
  var url = Uri(scheme: 'mailto', path: email);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

// launch url
Future<void> mlaunchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
    throw 'can not launch $uri';
  }
}

Widget buildLoadingWidget() {
  return Container(
    height: Get.height * 0.17,
    color: Colors.transparent,
    child: const Center(child: CircularProgressIndicator()),
  );
}

Future<File> compressFile({required File? file}) async {
  final filePath = file!.path;

  // Create output file path
  // eg:- "Volume/VM/abcd_out.jpeg"
  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = '${splitted}_out${filePath.substring(lastIndex)}';
  var result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    outPath,
    quality: 80,
  );
  return File(result!.path);
}

String formatPrice(double price) {
  final format = NumberFormat.currency(locale: "fr_CM", symbol: "XAF", decimalDigits: 0);
  return format.format(price);
}

String formatDate(DateTime date) {
  final format = DateFormat('dd-MM-yyyy');
  return format.format(date);
}

// convert a list to a string separated by comma
String listToString(List<int?> list) {
  String result = "";
  for (int i = 0; i < list.length; i++) {
    if (result == "") {
      result = list[i].toString();
    } else {
      result = "$result,${list[i]}";
    }
  }
  return result;
}

// check if location info is available
bool isLocationAvailable(Map<String, dynamic> value) {
  return value['region'] != "" && value['region'] != null && value['town'] != "" && value['town'] != null;
}

Future<void> getActiveSubscription() async {
  // String? userDataString = ErrandiaApp.prefs.getString('user');
  //
  // if (userDataString != null) {
  //   var userData = jsonDecode(userDataString);
  //   print("user data on errand detail: $userData");
  //   return userData['active_subscription'];
  // }
  //
  // return false;

  var response_ = await SubscriptionAPI.getCurrentSubscription();
  var response = jsonDecode(response_);
  if (response['status'] != 'error') {
    var data = response['data'];
    print("subscription data: $data");

    ErrandiaApp.prefs.setString('subscription', jsonEncode(data['data']['item']));
  } else {
    print("error getting subscription data: ${response['data']}");
    ErrandiaApp.prefs.setString('subscription', jsonEncode({}));
  }

}

bool hasActiveSubscription() {
  String? subscription = ErrandiaApp.prefs.getString('subscription');
  print("subscription: $subscription");

  if (subscription != null) {
    var subs = jsonDecode(subscription);

    if (subs['status'] == 'SUCCESS') {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}