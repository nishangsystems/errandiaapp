import 'package:flutter/material.dart';

class billing_model {
  String? title;
  String? company_name;
  String? Date;
  String? phone;
  double? Price;
  String? status;
  String? image_url;
  Color ? color;
  billing_model({
    this.Date,
    this.Price,
    this.company_name,
    this.image_url,
    this.phone,
    this.status,
    this.title,
    this.color
  });
}
