
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

  // create a new errand
  static Future createErrand(Map<String, dynamic> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(Uri.parse('${apiDomain().domain}/user/errands'),
      headers: ({
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      }),
      body: jsonEncode(value)
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print(data);
      }
      return data;
    } else {
      var da = jsonDecode(response.body);
      return da;
    }
  }

}