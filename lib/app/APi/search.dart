import 'dart:convert';
import 'dart:io';
import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class SearchAPI {

  // search any item by query q and page number
  static Future searchItem(String q, int page,
      {String service='', String region='', String town=''}) async {
    var response = await http.get(
      Uri.parse('${apiDomain().domain}/search?q=$q&page=$page&service=$service&region=$region&town=$town'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (kDebugMode) {
        print('search response: $responseData');
      }

      return jsonEncode({
        'status': 'success',
        'data': responseData,
      });
    } else {
      if (kDebugMode) {
        print('search error: ${response.body}');
      }
      final errorData = jsonDecode(response.body);

      return jsonEncode({
        'status': 'error',
        'data': errorData,
      });

    }
  }

}