import 'dart:convert';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/modules/global/Widgets/snackBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class apiDomain {
  final domain = 'https://errandia.com/api';
}

class api {
  Future registration(Object value, context, navigator, navigator1) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse('${apiDomain().domain}/auth/signup'),
        body: jsonEncode(value),
        headers: ({'Content-Type': 'application/json; charset=UTF-8'}));
    if (kDebugMode) {
      print("register response: ${response.body}");
    }
    if (response.statusCode == 400) {
      if (kDebugMode) {
        print("status code: ${response.statusCode}");
      }
      var da = jsonDecode(response.body);
      await alertDialogBox(context, 'Alert', '${da['message']}');
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // var data_ = data['data'];
      // if (kDebugMode) {
      //   print("data token: ${data_['token']}");
      // }
      // prefs.setString('token', data_['token']);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => navigator));
    } else {
      var da = jsonDecode(response.body);
      if (navigator1 == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => navigator1));
      } else {
        await alertDialogBox(context, 'Alert', '${da['data']['message']}');
      }
    }
  }

  // login with email
  Future login(Object value, context, navigator, navigator1) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse('${apiDomain().domain}/auth/login'),
        body: jsonEncode(value),
        headers: ({'Content-Type': 'application/json; charset=UTF-8'}));
    if (kDebugMode) {
      print("login response: ${response.body}");
    }
    if (response.statusCode == 400) {
      if (kDebugMode) {
        print("status code: ${response.statusCode}");
      }
      var da = jsonDecode(response.body);
      await alertDialogBox(context, 'Alert', '${da['message']}');
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var data_ = data['data'];
      if (kDebugMode) {
        print("data uuid: ${data_['uuid']}");
      }
      prefs.setString('uuid', data_['uuid']);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => navigator));
    } else {
      var da = jsonDecode(response.body);
      if (navigator1 == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => navigator1));
      } else {
        await alertDialogBox(context, 'Alert', '${da['data']['message']}');
      }
    }
  }

  Future GetData(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response =
        await http.get(Uri.parse('${apiDomain().domain}/categories'),
            headers: ({
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print(data);
      }
      return data['data'];
    }
  }

  Future productnew(String url, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token;
    if (value == 1) {
      token = prefs.getString('token');
    }
    final response = await http.get(Uri.parse('${apiDomain().domain}/$url'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print(data);
      return data['data'];
    }
  }

  Future bussiness(
    String url,
    int value,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token;
    if (value == 1) {
      token = prefs.getString('token');
    }
    final response = await http.get(Uri.parse('${apiDomain().domain}/$url'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print('sdaf$data');
      return data['data']['shops'];
    }
  }

  Future getProduct(
    String url,
    int value,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token;
    if (value == 1) {
      token = prefs.getString('token');
    }
    final response = await http.get(Uri.parse('${apiDomain().domain}/$url'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print('sdaf$data');
      return data['data']['products'];
    }
  }

  Future deleteUpdate(String url, int value, data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token;
    if (value == 1) {
      token = prefs.getString('token');
    }
    print(data);

    final response = await http.post(Uri.parse('${apiDomain().domain}/$url'),
        body: jsonEncode(data),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      customsnackbar(Text('${data['data']['message']}'));
    }
  }

  // login with phone
  Future loginWithPhone(Object value, context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
          Uri.parse('${apiDomain().domain}/auth/login_with_phone'),
          body: jsonEncode(value),
          headers: ({'Content-Type': 'application/json; charset=UTF-8'}));
      if (kDebugMode) {
        print("login response: ${response.body}");
      }
      if (response.statusCode == 400) {
        if (kDebugMode) {
          print("status code: ${response.statusCode}");
        }
        var da = jsonDecode(response.body);
        print("data error: $da");
        await alertDialogBox(context, 'Alert', '${da['message']}');

        return response;
      }
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var data_ = data['data'];
        if (kDebugMode) {
          print("data uuid: ${data_['uuid']}");
        }
        prefs.setString('uuid', data_['uuid']);

        return response;
      } else {
        var da = jsonDecode(response.body);
        await alertDialogBox(context, 'Alert', '${da['data']['message']}');

        return da;
      }
    } catch (e) {
      print("Error in loginWithPhone: $e");
      await alertDialogBox(context, 'Error', 'An unexpected error occurred.');
      return null;
    }
  }

  // validate phone otp
  Future validatePhoneOtp(Object value, context, navigator) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse('${apiDomain().domain}/auth/validate_otp_code'),
        body: jsonEncode(value),
        headers: ({'Content-Type': 'application/json; charset=UTF-8'}));
    if (kDebugMode) {
      print("validate phone otp response: ${response.body}");
    }
    if (response.statusCode == 400) {
      if (kDebugMode) {
        print("status code: ${response.statusCode}");
      }
      var da = jsonDecode(response.body);
      await alertDialogBox(context, 'Alert', '${da['message']}');
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var data_ = data['data'];
      if (kDebugMode) {
        print("data: $data_");
      }
      prefs.setString('token', data_['token']);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => navigator));
    } else {
      var da = jsonDecode(response.body);
      await alertDialogBox(context, 'Alert', '${da['data']['message']}');
    }
  }
}
