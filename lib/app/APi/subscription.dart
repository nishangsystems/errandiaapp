
import 'dart:convert';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionAPI {

  // get all subscription plans
  static Future getSubscriptionPlans() async {

    final response = await http.get(Uri.parse('${apiDomain().domain}/plans'));

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

  // get my subscriptions
  static Future getMySubscriptions(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/user/subscriptions?page=$page'),
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

  // subscribe to a plan
  static Future subscribeToPlan(Map<String, dynamic> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(Uri.parse('${apiDomain().domain}/user/subscriptions'),
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
      return jsonEncode({'status': 'success', 'data': data});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': da});
    }
  }
}