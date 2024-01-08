import 'package:flutter/foundation.dart';

class review_list_item {
  String? customer_image_path;
  int? id;
  String? name;
  String? date;
  double? rating_value;
  String? review_description;
  String? image_path;
  List<String> ?imageList;

  review_list_item({
    @required this.name,
    this.date,
    @required this.rating_value,
    @required this.review_description,
    this.image_path,
    this.customer_image_path,
    this.imageList,
  }) {}
}
