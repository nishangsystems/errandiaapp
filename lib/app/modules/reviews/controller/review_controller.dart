import 'package:errandia/app/modules/reviews/views/review_list_items.dart';
import 'package:get/get.dart';

class review_controller extends GetxController {
  var reviewList = [].obs;

  Future addReview({
    int? id,
    String? name,
    String? date,
    double? rating_value,
    String? review_description,
    String? image_path,
    String? customer_image_path,
    List<String> ? imageList,
  }) async {
    var review_item = review_list_item(
      name: name,
      rating_value: rating_value,
      review_description: review_description,
      date: date,
      image_path: image_path,
      customer_image_path: customer_image_path,
      imageList: imageList,
    );
    reviewList.add(review_item);
  }
}
