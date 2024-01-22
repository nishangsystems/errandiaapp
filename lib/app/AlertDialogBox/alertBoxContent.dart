import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Future<void> alertDialogBox(context, String title, content) async {
  Completer<void> completer = Completer<void>();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
                color: Color(0xff113d6b), fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image.asset('assets/img_10.png',),
              Text(content),
            ],
          ),
          actions: [
            SizedBox(
              height: Get.height * 0.055,
              width: Get.width * 0.9,
              child: ElevatedButton(
                onPressed: () {
                  print("closing: $content");
                  Navigator.of(context).pop();
                  completer.complete();
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
                      color: Color(0xff113d6b),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.2),
                ),
              ),
            ),
          ],
        );
      });
  return completer.future;
}
