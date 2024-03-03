import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/apidomain%20&%20api.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductAPI {
  // get all products
  static Future getAllProductsOrServices(bool isService, int page) async {
    var response = await http.get(
      Uri.parse('${apiDomain().domain}/items?service=${isService ? 1 : 0}&page=$page'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (kDebugMode) {
        print("all items response: $responseData");
      }
      return jsonEncode({'status': 'success', 'data': responseData});
    } else {
      if (kDebugMode) {
        print("all items error: ${response.statusCode}");
      }
      final errorData = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': errorData});
    }
  }

  // get items by shop slug
  static Future getItemsByShop(String shopSlug, bool isService, int page) async {
    var response = await http.get(
      Uri.parse('${apiDomain().domain}/shops/$shopSlug/items?service=${isService ? 1 : 0}&page=$page'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (kDebugMode) {
        print("items by shop slug response: $responseData");
      }
      return jsonEncode({'status': 'success', 'data': responseData});
    } else {
      if (kDebugMode) {
        print("items by shop slug error: ${response.statusCode}");
      }
      final errorData = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': errorData});
    }
  }

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

  // update product or service
  static Future updateProductOrService(Map<String, dynamic> value, context,
      String itemSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var response = await http.put(
      Uri.parse('${apiDomain().domain}/user/items/$itemSlug'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(value),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (kDebugMode) {
        print("update product response: $responseData");
      }
      return jsonEncode({'status': 'success', 'data': responseData});
    } else {
      if (kDebugMode) {
        print("update product error: ${response.statusCode}");
      }
      final errorData = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': errorData});
    }
  }

  // update product or service with image
  static Future updateProductOrServiceWithImage(Map<String, dynamic> value, context,
      String imagePath, String itemSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${apiDomain().domain}/user/items/$itemSlug'),
    );

    // Add headers
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    request.fields['_method'] = 'PUT';

    // Add the product data
    for (var key in value.keys) {
      request.fields[key] = value[key];
    }

    if (imagePath != '' && await File(imagePath).exists()) {
      request.files.add(await http.MultipartFile.fromPath('featured_image', imagePath));
    }

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      if (kDebugMode) {
        print("update product response: $data");
      }
      return jsonEncode({'status': 'success', 'data': data});
    } else {
      if (kDebugMode) {
        print("update product error: ${response.statusCode}");
      }
      final errorData = await response.stream.bytesToString();
      return jsonEncode({'status': 'error', 'data': json.decode(errorData)});
    }
  }

  // add item image
  static Future addItemImage(String imagePath, String itemSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${apiDomain().domain}/user/items/$itemSlug/images/upload'),
    );

    // Add headers
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    // Add the product data
    if (imagePath != '' && await File(imagePath).exists()) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      if (kDebugMode) {
        print("add item image response: $data");
      }
      return jsonEncode({'status': 'success', 'data': data});
    } else {
      if (kDebugMode) {
        print("add item image error: ${response.statusCode}");
      }
      final errorData = await response.stream.bytesToString();
      return jsonEncode({'status': 'error', 'data': json.decode(errorData)});
    }
  }

  // get related products or services
  static Future getRelatedProductsOrServices(String itemSlug, bool isService) async {
    var response = await http.get(
      Uri.parse('${apiDomain().domain}/items/$itemSlug/related?service=${isService ? 1 : 0}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (kDebugMode) {
        print("related products response: $responseData");
      }
      return jsonEncode({'status': 'success', 'data': responseData});
    } else {
      if (kDebugMode) {
        print("related products error: ${response.statusCode}");
      }
      final errorData = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': errorData});
    }
  }

  // delete item image
  static Future deleteItemImage(String itemSlug, String imageId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var response = await http.delete(
      Uri.parse('${apiDomain().domain}/user/items/$itemSlug/images/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'image_id': imageId}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (kDebugMode) {
        print("delete item image response: $responseData");
      }
      return jsonEncode({'status': 'success', 'data': responseData});
    } else {
      if (kDebugMode) {
        print("delete item image error: ${response.statusCode}");
      }
      final errorData = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': errorData});
    }
  }

  // delete all item images
  static Future deleteAllItemImages(String itemSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var response = await http.delete(
      Uri.parse('${apiDomain().domain}/user/items/$itemSlug/images/delete-all'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (kDebugMode) {
        print("delete all item images response: $responseData");
      }
      return jsonEncode({'status': 'success', 'data': responseData});
    } else {
      if (kDebugMode) {
        print("delete all item images error: ${response.statusCode}");
      }
      final errorData = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': errorData});
    }
  }

  // delete product or service
  static Future deleteProductOrService(String itemSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var response = await http.delete(
      Uri.parse('${apiDomain().domain}/user/items/$itemSlug'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (kDebugMode) {
        print("delete product response: $responseData");
      }
      return jsonEncode({'status': 'success', 'data': responseData});
    } else {
      if (kDebugMode) {
        print("delete product error: ${response.statusCode}");
      }
      final errorData = jsonDecode(response.body);
      return jsonEncode({'status': 'error', 'data': errorData});
    }
  }
}
