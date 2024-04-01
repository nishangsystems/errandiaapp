
import 'dart:convert';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ErrandsAPI {

  // get all my errands
  static Future getMyErrands(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/user/errands?page=$page'),
      headers: ({
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      })
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print(data);
      }
      return data['data'];
    } else {
      var da = jsonDecode(response.body);
      return da;
    }
  }

  // create a new errand with image list upload form data
  static Future createErrand(Map<String, dynamic> value,
    List<String> imageList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request = http.MultipartRequest('POST', Uri.parse('${apiDomain().domain}/user/errands'));

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    for (int i = 0; i < imageList.length; i++) {
      for (var image in imageList) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]', // Field name for each image
            image,
          ),
        );
      }
    }

    for (var key in value.keys) {
      request.fields[key] = value[key];
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString());
      if (kDebugMode) {
        print(data);
      }
      return jsonEncode({'status': 'success', 'message': 'Errand created successfully'});
    } else {
      var da = jsonDecode(await response.stream.bytesToString());
      return jsonEncode({'status': 'error', 'message': da['message']});
    }

  }

}