import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class new_errandia_controller extends GetxController{
  // TextEditingControllers for handling text input
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // RxString variables for observing changes
  final RxString _title = ''.obs;
  final RxString _description = ''.obs;

  RxString regionCode = ''.obs;
  RxString town = ''.obs;

  // Expose only the RxString values (read-only)
  String get title => _title.value;
  String get description => _description.value;

  @override
  void onInit() {
    super.onInit();
    // Listen for changes in the text fields and update the Rx variables
    titleController.addListener(() {
      _title.value = titleController.text;
    });
    descriptionController.addListener(() {
      _description.value = descriptionController.text;
    });
  }

  // Check if all fields are filled
  bool get isFormFilled =>
      _title.isNotEmpty &&
          _description.isNotEmpty &&
          regionCode.isNotEmpty;

  @override
  void onClose() {
    // Dispose of the text controllers
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}