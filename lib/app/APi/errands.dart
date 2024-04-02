
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

  // update errand
  static Future updateErrand(String errandId, Map<String, dynamic> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(Uri.parse('${apiDomain().domain}/user/errands/$errandId'),
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
      return jsonEncode({'status': 'success', 'message': 'Errand updated successfully'});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'message': da['message']});
    }
  }

  // upload errand image
  static Future uploadErrandImage(String errandId, String image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request = http.MultipartRequest('POST', Uri.parse('${apiDomain().domain}/user/errands/$errandId/add_image'));

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // Field name for each image
        image,
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString());
      if (kDebugMode) {
        print(data);
      }
      return jsonEncode({'status': 'success', 'message': 'Image uploaded successfully', 'data': data['data']});
    } else {
      var da = jsonDecode(await response.stream.bytesToString());
      return jsonEncode({'status': 'error', 'message': da['message']});
    }

  }

  // remove image from errand
  static Future removeErrandImage(String errandId, String imageId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.delete(Uri.parse('${apiDomain().domain}/user/errands/$errandId/image/$imageId'),
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
      return jsonEncode({'status': 'success', 'message': 'Image removed successfully'});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'message': da['message']});
    }
  }

  // delete errand
  static Future deleteErrand(String errandId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.delete(Uri.parse('${apiDomain().domain}/user/errands/$errandId'),
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
      return jsonEncode({'status': 'success', 'message': 'Errand deleted successfully'});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'message': da['message']});
    }
  }

}