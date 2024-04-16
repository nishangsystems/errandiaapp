
import 'dart:math';

import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PillsDisplay extends StatelessWidget {
  final String text;

  const PillsDisplay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<String> items = text.split(', '); // Split the string into a list
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Wrap(
        spacing: 4.0, // Gap between adjacent chips
        children: items.map((item) => PillWidget(text: item)).toList(),
      ),
    );
  }
}

class PillWidget extends StatelessWidget {
  final String text;

  PillWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    Color bgColor = getBackgroundColor(text); // Get a color based on the text

    return Chip(
      labelPadding: const EdgeInsets.all(0),
      // avatar: CircleAvatar(
      //   backgroundColor: Colors.white70,
      //   child: Text(text[0].toUpperCase()), // Display the first letter
      // ),
      padding: const EdgeInsets.only(left: 6, right: 6, top: 0, bottom: 0),
      surfaceTintColor: appcolor().amberColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: bgColor.withOpacity(0.9),
          width: 1.2,
        ),
      ),
      label: Text(
        text,
        style: TextStyle(
          color: appcolor().darkBlueColor,
          fontSize: 9
        ),
      ),
      backgroundColor: bgColor.withAlpha(100),
    ).paddingZero;
  }

  // A simple function to generate a color based on the string
  // You can replace this logic with your own color-determining logic
  static Color getBackgroundColor(String text) {
    final int hash = text.hashCode;
    final Random random = Random(hash);
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }
}