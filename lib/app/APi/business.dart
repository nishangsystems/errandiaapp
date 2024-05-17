import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/modules/global/Widgets/snackBar.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BusinessAPI {
  // create business
  static Future createBusiness(Object value, context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(Uri.parse('${apiDomain().domain}/user/shops'),
        body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (kDebugMode) {
      print("create business response: ${response.body}");
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var data_ = data;
      if (kDebugMode) {
        print("data: $data_");
      }
      var item = data_;
      print("new business response: $item");
      // prefs.setString("business", jsonEncode(user));
      // customSnackBar(Text('${data['message']}'));
      return jsonEncode({'status': 'success', 'data': item});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': da});
      // await alertDialogBox(context, 'Alert', '${da['data']['error']}');
    }
  }

  // create business with imageLogo upload
  static Future createBusinessWithImageLogo(
      Map<String, String> value, context, String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request =
        http.MultipartRequest('POST', Uri.parse('${apiDomain().domain}/user/shops'));

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields.addAll(value);

    if (await File(imagePath).exists()) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    } else {
      if (kDebugMode) {
        print('Image file does not exist: $imagePath');
      }
    }

    var response = await request.send();

    // Read response
    var responseBody = await response.stream.bytesToString();
    var responseData = jsonDecode(responseBody);

    if (kDebugMode) {
      print("upload profile image response: $responseBody");
      print("upload profile image data: $responseData");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Business data: $responseData");
      }
      await getActiveSubscription();
    return jsonEncode({'status': 'success', 'data': responseData});
    } else {
      if (kDebugMode) {
        print("Error response: $responseBody");
      }
      return jsonEncode({"status": "error", "data": responseData});
    }
  }

  // update business
  static Future updateBusiness(Object value, context, String shopSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.put(Uri.parse('${apiDomain().domain}/user/shops/$shopSlug'),
        body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (kDebugMode) {
      print("update business response: ${response.body}");
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var data_ = data;
      if (kDebugMode) {
        print("data: $data_");
      }
      var item = data_;
      print("update business response: $item");
      // prefs.setString("business", jsonEncode(user));
      // customSnackBar(Text('${data['message']}'));
      return jsonEncode({'status': 'success', 'data': item});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': da});
      // await alertDialogBox(context, 'Alert', '${da['data']['error']}');
    }
  }

  // update business with imageLogo upload
  static Future updateBusinessWithImageLogo(
      Map<String, String> value, context, String imagePath, String shopSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request =
        http.MultipartRequest('POST', Uri.parse('${apiDomain().domain}/user/shops/$shopSlug'));

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['_method'] = 'PUT';
    request.fields.addAll(value);

    if (await File(imagePath).exists()) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    } else {
      if (kDebugMode) {
        print('Image file does not exist: $imagePath');
      }
    }

    var response = await request.send();

    // Read response
    var responseBody = await response.stream.bytesToString();
    var responseData = jsonDecode(responseBody);

    if (kDebugMode) {
      print("upload profile image response: $responseBody");
      print("upload profile image data: $responseData");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Business data: $responseData");
      }
      return jsonEncode({'status': 'success', 'data': responseData});
    } else {
      if (kDebugMode) {
        print("Error response: $responseBody");
      }
      return jsonEncode({"status": "error", "data": responseData});
    }
  }

  // get featured businesses
  static Future businesses(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/shops?page=$page'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('shops response: $data');
      }
      return data['data']['items'];
    } else {
      var da = jsonDecode(response.body);
      return da;
    }
  }

  // get business list
  static Future businessList(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/shops?page=$page'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('shops list response: $data');
      }
      return data['data'];
    } else {
      var da = jsonDecode(response.body);
      return da;
    }
  }

  // get user shops
  static Future userShops_(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/user/shops?page=$page'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('user shops response: $data');
      }
      return data['data'];
    } else {
      var da = jsonDecode(response.body);
      return da;
    }
  }

  // get user shops except the current shop
  static Future businessBranches(String shopSlug, int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/shops/$shopSlug/branches?page=$page'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('user shop branches response: $data');
      }
      return data['data'];
    } else {
      var da = jsonDecode(response.body);
      return da;
    }
  }

  // get my products
  static Future userProducts(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/user/products?page=$page'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('user products response: $data');
      }
      return data['data'];
    } else {
      var da = jsonDecode(response.body);
      return da;
    }
  }

  // get my services
  static Future userServices(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/user/services?page=$page'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print('user services response: $data');
      }
      return data['data'];
    } else {
      var da = jsonDecode(response.body);
      return da;
    }
  }

  // send business otp
  static Future sendBusinessOtp(String shopSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(Uri.parse('${apiDomain().domain}/user/shops/$shopSlug/send_otp'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (kDebugMode) {
      print("send business otp response: ${response.body}");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var data_ = data;
      if (kDebugMode) {
        print("data: $data_");
      }
      var item = data_;
      print("send business otp response: $item");
      // prefs.setString("business", jsonEncode(user));
      // customSnackBar(Text('${data['message']}'));
      return jsonEncode({'status': 'success', 'data': item});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': da});
      // await alertDialogBox(context, 'Alert', '${da['data']['error']}');
    }
  }

  // validate business otp
  static Future validateBusinessOtp(String shopSlug, Object value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(Uri.parse('${apiDomain().domain}/user/shops/$shopSlug/validate_otp'),
        body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (kDebugMode) {
      print("validate business otp response: ${response.body}");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var data_ = data;
      if (kDebugMode) {
        print("data: $data_");
      }
      var item = data_;
      print("validate business otp response: $item");
      // prefs.setString("business", jsonEncode(user));
      // customSnackBar(Text('${data['message']}'));
      return jsonEncode({'status': 'success', 'data': item});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': da});
      // await alertDialogBox(context, 'Alert', '${da['data']['error']}');
    }
  }

  // delete business
  static Future deleteBusiness(String shopSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.delete(Uri.parse('${apiDomain().domain}/user/shops/$shopSlug'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (kDebugMode) {
      print("delete business response: ${response.body}");
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var data_ = data;
      if (kDebugMode) {
        print("data: $data_");
      }
      var item = data_;
      print("delete business response: $item");
      // prefs.setString("business", jsonEncode(user));
      // customSnackBar(Text('${data['message']}'));
      return jsonEncode({'status': 'success', 'data': item});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': da});
      // await alertDialogBox(context, 'Alert', '${da['data']['error']}');
    }
  }
}
