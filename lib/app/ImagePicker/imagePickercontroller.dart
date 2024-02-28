import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum UploadStatus { pending, uploading, success, failed }

class imagePickercontroller extends GetxController {
  RxList<UploadStatus> uploadStatusList = <UploadStatus>[].obs;
  final ImagePicker picker = ImagePicker();

  // online image list
  late RxList<String> onlineImageList;

  late RxList<dynamic> imageList;
  late RxString image_path;

  @override
  void onInit() {
    super.onInit();
    imageList = <dynamic>[].obs;
    image_path = ''.obs;
    onlineImageList = <String>[].obs;

    // initialize update status list
  }

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
  Future getMultipleimagefromCamera() async {
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
    if (uploadStatusList.isNotEmpty) {
      uploadStatusList.removeAt(index);
    }
  }

  Future edit(int index) async {
    // dynamic image = imageList[index];
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

  Future replace(int index, String itemSlug) async {
    // dynamic image = imageList[index];
    final _picker = ImagePicker();
    try {
      final temp_image = await _picker.pickImage(source: ImageSource.gallery);
      if (temp_image != null) {
        // delete the previous image from the server
        if (imageList[index]['id'] != null && imageList[index] is Map) {
          print("image to replace: ${imageList[index]['id']}");

          await deleteOneImageById(itemSlug, imageList[index]['id'].toString()).then((_) {
            print("image deleted ====");
          });
        }

        imageList[index] = temp_image;
        uploadImage(temp_image.path, itemSlug, index);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<void> getmultipleImage() async {
    final ImagePicker _picker = ImagePicker();
    final selectedImages = await _picker.pickMultiImage(
      imageQuality: 100,
    );
print("selectedImages: $selectedImages");
    if (selectedImages.isNotEmpty) {
      for (int i = 0; i < selectedImages.length; i++) {
        imageList.add(selectedImages[i]);
        uploadStatusList[i] = UploadStatus.pending;
        refresh();
      }

      print("uploadStatusList ===: $uploadStatusList");
    } else {
      Get.snackbar('Error', 'Please Select Images');
    }
  }

  Future addImageFromGallery(String slug) async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    print("image selected: $image");
    if (image != null) {
      // if imagelist length is greater than uploadstatuslist length, add 10 success values to the uploadstatuslist first
      if (imageList.length > uploadStatusList.length) {
        for (int i = 0; i < imageList.length; i++) {
          uploadStatusList.add(UploadStatus.success);
        }
      }
      print("uploadStatus List: $uploadStatusList");
      imageList.add(image);
      // assign success to the previous images index
      int currentIndex = imageList.indexOf(image);
      // uploadStatusList[currentIndex] = UploadStatus.pending;

      uploadStatusList.add(UploadStatus.pending);

      uploadImage(image.path, slug, currentIndex);
      print("imageList: $imageList");
      print("uploadStatusList ADD: $uploadStatusList");
    }
  }

  // upload one image to the server and update the upload status
  Future<void> uploadImage(String imagePath, String itemSlug, int index) async {
    try {
      final response = await ProductAPI.addItemImage(imagePath, itemSlug);
      final data = jsonDecode(response);

      print("current upload list: $uploadStatusList");

      if (data['status'] == 'success') {
        print("image uploaded: $data");
        uploadStatusList[index] = UploadStatus.success;

        // replace the image from the list with the online image path
        imageList[index] = {
          "id": data['data']['data']['image']['id'],
          "url": data['data']['data']['image']['image']
        };

      } else {
        uploadStatusList[index] = UploadStatus.failed;
      }

      print("uploadStatusList: $uploadStatusList");
    } catch (e) {
      print("Error during image upload: $e");
      // Handle exception
      // uploadStatusList[index] = UploadStatus.failed; // Update status on error

    }
  }

  Future<void> uploadImages(String itemSlug) async {
    for (int i = 0; i < imageList.length; i++) {
      if (uploadStatusList[i] == UploadStatus.pending) {
        uploadStatusList[i] = UploadStatus.uploading;
        print("uploading image: ${imageList[i].path}");
        final response = await ProductAPI.addItemImage(imageList[i].path, itemSlug);
        final data = jsonDecode(response);
        if (data['status'] == 'success') {
          uploadStatusList[i] = UploadStatus.success;
        } else {
          uploadStatusList[i] = UploadStatus.failed;
        }
      }
    }
  }

  Future deleteOneImage(String itemSlug, index) async {
    var imageId = imageList[index]['id'].toString();

    print("image id to delete: $imageId");
    try {
      final response = await ProductAPI.deleteItemImage(itemSlug, imageId);
      final data = jsonDecode(response);
      if (data['status'] == 'success') {
        // imageList.removeWhere((element) => element.path == imagePath);
        // uploadStatusList.removeWhere((element) => element == UploadStatus.success);
        removeat(index);
        Get.snackbar("Info", "Image deleted successfully");
        return {"status": "success", "message": "Image deleted successfully"};
      } else {
        return {"status": "error", "message": "Failed to delete image"};
      }
    } catch (e) {
      print("Error during image deletion: $e");
    }
  }

  Future deleteOneImageById(String itemSlug, String id) async {
    try {
      final response = await ProductAPI.deleteItemImage(itemSlug, id);
      final data = jsonDecode(response);
      if (data['status'] == 'success') {
        // imageList.removeWhere((element) => element.path == imagePath);
        // uploadStatusList.removeWhere((element) => element == UploadStatus.success);
        Get.snackbar("Info", "Image replaced successfully");
        return {"status": "success", "message": "Image replaced successfully"};
      } else {
        return {"status": "error", "message": "Failed to delete image"};
      }
    } catch (e) {
      print("Error during image deletion: $e");
    }
  }

  Future deleteAllImages(String itemSlug) async {
    try {
      final response = await ProductAPI.deleteAllItemImages(itemSlug);
      final data = jsonDecode(response);
      if (data['status'] == 'success') {
        imageList.clear();
        uploadStatusList.clear();
        return {"status": "success", "message": "Images deleted successfully"};
      } else {
        return {"status": "error", "message": "Failed to delete images"};
      }
    } catch (e) {
      print("Error during image deletion: $e");
    }
  }

  // Future cropImage(XFile image) async {
  //   File? croppedFile = await ImageCropper.cropImage(
  //     sourcePath: image.path,
  //     maxWidth: 512,
  //     maxHeight: 512,
  //   );
  //   _listener.userImage(croppedFile);
  // }

  void resetImageList() {
    imageList.clear();
    uploadStatusList.clear();
  }

}
