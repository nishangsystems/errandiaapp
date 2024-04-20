
import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
    List<dynamic> imageList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request = http.MultipartRequest('POST', Uri.parse('${apiDomain().domain}/user/errands'));

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    print("image list to send: $imageList");

    if (imageList.isNotEmpty) {
      for (var image in imageList) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]', // Field name for each image
            image.path,
          ),
        );
      }
    }

    for (var key in value.keys) {
      request.fields[key] = value[key].toString();
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString());
      if (kDebugMode) {
        print(data);
      }
      return jsonEncode({'status': 'success', 'message': 'Errand created successfully', 'data': data['data']});
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

  // run an errand
  static Future runErrand(String errandId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/user/errands/$errandId/run'),
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
      return jsonEncode({'status': 'success', 'message': 'Errand is now running in the background.', 'data': data['data']});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'message': da['message']});
    }
  }

  // get errandResults
  static Future getErrandResults(String errandId, int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/user/errands/$errandId/results?page=$page'),
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

  // get errands received
  static Future getErrandsReceived(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(Uri.parse('${apiDomain().domain}/user/errands_received?page=$page'),
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

  // reject a received errand
  static Future rejectReceivedErrand(String errandId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.delete(Uri.parse('${apiDomain().domain}/user/errands_received/$errandId'),
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
      return jsonEncode({'status': 'success', 'message': 'Errand rejected successfully'});
    } else {
      var da = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'message': da['message']});
    }
  }

  // mark errand as found
  static Future markErrandAsFound(String errandId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.put(Uri.parse('${apiDomain().domain}/user/errands/$errandId/marked_as_found'),
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
      return jsonEncode({'status': 'success', 'message': 'Errand marked as found successfully'});
    } else {
      var da = jsonDecode(response.body);
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

  // delete all errand images
  static Future deleteAllErrandImages(String errandId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.delete(Uri.parse('${apiDomain().domain}/user/errands/$errandId/remove_images'),
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
      return jsonEncode({'status': 'success', 'message': 'All images removed successfully'});
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