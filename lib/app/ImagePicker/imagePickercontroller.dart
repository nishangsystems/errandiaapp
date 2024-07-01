import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:errandia/app/APi/errands.dart';
import 'package:errandia/app/APi/product.dart';
import 'package:errandia/utils/helper.dart';
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

  late RxList<String> imagePaths;

  @override
  void onInit() {
    super.onInit();
    imageList = <dynamic>[].obs;
    image_path = ''.obs;
    onlineImageList = <String>[].obs;
    imagePaths = <String>[].obs;
    // initialize update status list
  }

  Future getImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      File imageFile = File(image.path);

      print("comp: original file size: ${imageFile.lengthSync()}");
      // calculate file size in bytes or megabytes
      double fileSize = imageFile.lengthSync() / (1024 * 1024);
      print("File size: $fileSize MB");

      try {
        imageFile = (await compressImageToMaxSize(imageFile))!;
        print("Compressed file size: ${imageFile.lengthSync()}");
      } catch (e) {
        print("Error compressing file: $e");
      }

      image_path.value = imageFile.path;
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

      // compress image file
      File imageFile = File(image.path);

      print("cam: original file size: ${getFileSize(imageFile)}");
      try {
        imageFile = (await compressImageToMaxSize(imageFile))!;
        print("cam: Compressed file size: ${getFileSize(imageFile)}");
      } catch (e) {
        print("Error compressing file: $e");
      }

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

          await deleteOneImageById(itemSlug, imageList[index]['id'].toString())
              .then((_) {
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

  // replace errand image
  Future replaceErrandImage(int index, String itemId) async {
    // dynamic image = imageList[index];
    final _picker = ImagePicker();
    try {
      final temp_image = await _picker.pickImage(source: ImageSource.gallery);
      if (temp_image != null) {
        // delete the previous image from the server
        if (imageList[index]['id'] != null && imageList[index] is Map) {
          print("image to replace: ${imageList[index]['id']}");

          await deleteErrandImage(itemId, index).then((_) {
            print("image deleted ====");
          });
        }

        imageList[index] = temp_image;
        uploadErrandImage(temp_image.path, itemId, index);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getmultipleImage() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile> selectedImages = await _picker.pickMultiImage(
      imageQuality: 100,
    );

    print("selectedImages: $selectedImages");
    if (selectedImages.isNotEmpty) {
      for (int i = 0; i < selectedImages.length; i++) {
        // compress the images first
        File imageFile = File(selectedImages[i].path);
        print("compressed: original file size: ${getFileSize(imageFile)}");
        try {
          imageFile = (await compressImageToMaxSize(imageFile))!;
          print("Compressed file size: ${getFileSize(imageFile)}");
        } catch (e) {
          print("Error compressing file: $e");
        }

        imageList.add(selectedImages[i]);
        imagePaths.add(selectedImages[i].path);
        uploadStatusList.add(UploadStatus.pending);
        refresh();
      }
      print("imageList: $imageList");

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

  // add errand image from gallery
  Future addErrandImageFromGallery(String itemId) async {
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

      uploadErrandImage(image.path, itemId, currentIndex);
      print("imageList: $imageList");
      print("uploadStatusList ADD: $uploadStatusList");
    }
  }

  // add multiple images from camera and upload
  Future addImageFromCamera(String slug) async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    // compress image
    if (image != null) {
      File imageFile = File(image.path);

      print("original file size: ${imageFile.lengthSync()}");

      try {
        imageFile = (await compressImageToMaxSize(imageFile))!;
        print("Compressed file size: ${imageFile.lengthSync()}");
      } catch (e) {
        print("Error compressing file: $e");
      }

      print("uploadStatus List: $uploadStatusList");
      imageList.add(imageFile);
      // assign success to the previous images index
      int currentIndex = imageList.indexOf(imageFile);
      // uploadStatusList[currentIndex] = UploadStatus.pending;

      uploadStatusList.add(UploadStatus.pending);

      uploadImage(imageFile.path, slug, currentIndex);
      print("imageList: $imageList");
      print("uploadStatusList ADD: $uploadStatusList");
    }
  }

  // add errand image from camera
  Future addErrandImageFromCamera(String itemId) async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    // compress image
    if (image != null) {
      File imageFile = File(image.path);

      print("camera: original file size: ${imageFile.lengthSync()}");

      try {
        imageFile = (await compressImageToMaxSize(imageFile))!;
        print("Compressed file size: ${imageFile.lengthSync()}");
      } catch (e) {
        print("Error compressing file: $e");
      }

      print("uploadStatus List: $uploadStatusList");
      imageList.add(imageFile);
      // assign success to the previous images index
      int currentIndex = imageList.indexOf(imageFile);
      // uploadStatusList[currentIndex] = UploadStatus.pending;

      uploadStatusList.add(UploadStatus.pending);

      uploadErrandImage(imageFile.path, itemId, currentIndex);
      print("imageList: $imageList");
      print("uploadStatusList ADD: $uploadStatusList");
    }
  }

  // upload errand image and update the upload status
  Future<void> uploadErrandImage(
      String imagePath, String itemId, int index) async {
    try {
      final response = await ErrandsAPI.uploadErrandImage(itemId, imagePath);
      final data = jsonDecode(response);

      print("current upload list: $uploadStatusList");

      if (data['status'] == 'success') {
        print("image uploaded: $data");
        uploadStatusList[index] = UploadStatus.success;

        // replace the image from the list with the online image path
        imageList[index] = {
          "id": data['data']['item']['id'],
          "image_path": data['data']['item']['image']
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

  // delete errand image
  Future deleteErrandImage(String itemId, index) async {
    var imageId = imageList[index]['id'].toString();

    print("image id to delete: $imageId");
    try {
      final response = await ErrandsAPI.removeErrandImage(itemId, imageId);
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

  // delete all errand images
  Future deleteAllErrandImages(String itemId) async {
    try {
      for (int i = 0; i < imageList.length; i++) {
        var imageId = imageList[i]['id'].toString();
        final response = await ErrandsAPI.removeErrandImage(itemId, imageId);
        final data = jsonDecode(response);
        if (data['status'] == 'success') {
          // imageList.removeWhere((element) => element.path == imagePath);
          // uploadStatusList.removeWhere((element) => element == UploadStatus.success);
          removeat(i);
          // Get.snackbar("Info", "Image deleted successfully");
        }
      }
      if (imageList.isEmpty) {
        Get.snackbar("Info", "All images deleted successfully");
        return {
          "status": "success",
          "message": "All images deleted successfully"
        };
      } else {
        Get.snackbar("Error", "Failed to delete images",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
        return {"status": "error", "message": "Failed to delete images"};
      }
    } catch (e) {
      print("Error during image deletion: $e");
      Get.snackbar("Error", "Failed to delete images",
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
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

  // file size in MB
  String getFileSize(File file) {
    double fileSize = file.lengthSync() / (1024 * 1024);
    return fileSize.toStringAsFixed(2);
  }

  void resetImageList() {
    imageList.clear();
    uploadStatusList.clear();
  }
}
