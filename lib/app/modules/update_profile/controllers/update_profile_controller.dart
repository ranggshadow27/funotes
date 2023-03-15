import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print(image!.name);
    } else {
      print(image);
    }
    update();
  }

  void deletePhoto(String uid) async {
    try {
      // isLoading.value = true;
      await firestore.collection("users").doc(uid).update({
        'profile_photo': "",
      });
      Get.back();
      Get.snackbar("Berhasil", "Foto Profile dihapus");
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat menghapus.");
    }
  }

  Future<void> updateProfile(String uid) async {
    if (nameC.text.isNotEmpty && emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> dataUser = ({
          'username': nameC.text,
        });
//Upload Image
        if (image != null) {
          File file = File(image!.path);
          String fileName = image!.name.split("image_picker").last;

          await storage.ref('avatar/$uid/$fileName').putFile(file);

          String fileUrl =
              await storage.ref('avatar/$uid/$fileName').getDownloadURL();

          dataUser.addAll({'profile_photo': fileUrl});
        }
//Update Profile
        await firestore.collection("users").doc(uid).update(dataUser);

        Get.back();
        Get.snackbar("Berhasil", "Berhasil Update Profile!");
      } catch (e) {
        Get.snackbar("Error", "Gagal Update Profile, ${e}");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Mohon isi semua field}");
    }
  }
}
