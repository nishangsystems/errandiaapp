import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductAPI {
  static Future createProductOrService(Map<String, dynamic> value, context,
      String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${apiDomain().domain}/user/items'),
    );

    // Add headers
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    // Add the product data
    for (var key in value.keys) {
      request.fields[key] = value[key];
    }

    // Add the cover image if it exists
    // if (value.containsKey('featured_image')) {
    //   var coverImagePath = value['featured_image'] as String;
    //   request.files.add(await http.MultipartFile.fromPath('featured_image', coverImagePath));
    // }
    if (imagePath != '' && await File(imagePath).exists()) {
      request.files.add(await http.MultipartFile.fromPath('featured_image', imagePath));
    }

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      if (kDebugMode) {
        print("create product response: $data");
      }
      return jsonEncode({'status': 'success', 'data': data});
    } else {
      if (kDebugMode) {
        print("create product error: ${response.statusCode}");
      }
      final errorData = await response.stream.bytesToString();
      return jsonEncode({'status': 'error', 'data': json.decode(errorData)});
    }
  }
}
