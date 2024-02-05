import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class imagePickercontroller extends GetxController {
  RxList<XFile> imageList = <XFile>[].obs;
  RxString image_path = ''.obs;
  Future getImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      final File imageFile = File(image.path);
      image_path.value = image.path;
      print("imagePath: $image_path");

      return imageFile;
      //imageList.add(image);
    }
    return null;
  }

  Future getimagefromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      image_path.value = image.path.toString();
      return image_path.value;
     // imageList.add(image);
    }
  }
  Future<void> getMultipleimagefromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      image_path.value = image.path.toString();
       imageList.add(image);
    }
  }


  Future reset() async {
    image_path.value = '';
  }

  Future removeat(int index) async {
    imageList.removeAt(index);
  }

  Future edit(int index) async {
    XFile image = imageList[index];
    final _picker = ImagePicker();
    try {
      final temp_image = await _picker.pickImage(source: ImageSource.gallery);
      if (temp_image != null) {
        imageList[index] = temp_image;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future getmultipleImage() async {
    final ImagePicker _picker = ImagePicker();
    final selectedImages = await _picker.pickMultiImage(
      imageQuality: 100,
    );

    if (selectedImages.isNotEmpty) {
      for (int i = 0; i < selectedImages.length; i++) {
        imageList.add(selectedImages[i]);
      }
    } else {
      Get.snackbar('Error', 'Please Select Images');
    }
  }
}
