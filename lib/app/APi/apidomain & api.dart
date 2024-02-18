import 'dart:convert';
import 'package:errandia/app/AlertDialogBox/alertBoxContent.dart';
import 'package:errandia/app/modules/global/Widgets/popupBox.dart';
import 'package:errandia/app/modules/global/Widgets/snackBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class apiDomain {
  final domain = 'https://errandia.com/api';
  final imageDomain = 'https://errandia.com';
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

  Future getProduct(String url,
      int value,) async {
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
      print("{data['data']['products']}");
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
      customSnackBar(Text('${data['data']['message']}'));
    }
  }

  // validate otp
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
        print("data: ${data_}");
      }
      var user = data_['user'];
      print("user: $user");
      prefs.setString('token', data_['token']);
      prefs.setString("user", jsonEncode(user));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => navigator));
    } else {
      var da = jsonDecode(response.body);
      await alertDialogBox(context, 'Alert', '${da['data']['message']}');
    }
  }

  // update profile
  Future updateProfile(Object value, context, navigator) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.patch(
        Uri.parse('${apiDomain().domain}/user'),
        body: jsonEncode(value),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    if (kDebugMode) {
      print("update profile response: ${response.body}");
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
        print("data: ${data_}");
      }
      var user = data_['user'];
      print("user: $user");
      prefs.setString("user", jsonEncode(user));
      // customSnackBar(Text('${data['message']}'));

      return data;
    } else {
      var da = jsonDecode(response.body);
      await alertDialogBox(context, 'Alert', '${da['data']['message']}');
    }
  }

  // user profile image upload
  Future uploadProfileImage(image, context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${apiDomain().domain}/user/image_upload'),
    );

    // Add image file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
          'image',
          image.path
      ),
    );

    // Add headers
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // Send request
    var response = await request.send();

    // Read response
    var responseBody = await response.stream.bytesToString();
    var responseData = jsonDecode(responseBody);

    if (kDebugMode) {
      print("upload profile image response: $responseBody");
    }
    if (response.statusCode == 400) {
      if (kDebugMode) {
        print("status code: ${response.statusCode}");
      }
      var da = jsonDecode(responseData);
      await alertDialogBox(context, 'Alert', '${da['message']}');
    }
    if (response.statusCode == 200) {
      var data_ = responseData['data'];
      var userProfileImg = data_['image_path'];
      prefs.setString("userProfileImg", jsonEncode(userProfileImg));
      return data_;
    } else {
      var errorMessage = responseData['message'] ?? 'Unknown error';
      await alertDialogBox(context, 'Alert', errorMessage);
      return null;
    }
  }

  // get all categories
  Future getCategories() async {
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
    } else {
      var da = jsonDecode(response.body);
      return da;
    }
  }

  // get towns by region
  Future getTownsByRegion(int regionId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(
        Uri.parse('${apiDomain().domain}/towns?region_id=$regionId'),
        headers: ({
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        }));
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

}