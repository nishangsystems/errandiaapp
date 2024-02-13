import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/modules/global/Widgets/snackBar.dart';
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
    final response = await http.post(Uri.parse('${apiDomain().domain}/shops'),
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
      Map<String, dynamic> value, context, String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request =
        http.MultipartRequest('POST', Uri.parse('${apiDomain().domain}/shops'));

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['name'] = value['name'];
    request.fields['description'] = value['description'];
    request.fields['is_branch'] = value['is_branch'].toString();
    request.fields['slogan'] = value['slogan'];
    request.fields['street_id'] = value['street_id'].toString();
    request.fields['phone'] = value['phone'];
    request.fields['whatsapp'] = value['whatsapp'];
    request.fields['facebook'] = value['facebook'];
    request.fields['instagram'] = value['instagram'];
    request.fields['twitter'] = value['twitter'];
    request.fields['address'] = value['address'];
    request.fields['website'] = value['website'];
    request.fields['categories'] = value['categories'];

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
}
