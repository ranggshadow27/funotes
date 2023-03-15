import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  TextEditingController oldPassC = TextEditingController();
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updatePassword() async {
    if (oldPassC.text.isNotEmpty &&
        newPassC.text.isNotEmpty &&
        confirmPassC.text.isNotEmpty) {
      if (newPassC.text == confirmPassC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: oldPassC.text);

          await auth.currentUser!.updatePassword(newPassC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: newPassC.text);

          Get.back();
          Get.snackbar("Berhasil", "Password sudah terupdate");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar("Error", "Password lama salah!");
          } else if (e.code == 'weak-password') {
            Get.snackbar("Error", "Password baru terlalu lemah!");
          } else {
            Get.snackbar("Error", "Tidak dapat update Password ${e.code}");
          }
        } catch (e) {
          Get.snackbar("Error", "Tidak dapat update Password ${e}");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Error", "Password baru tidak cocok");
      }
    } else {
      Get.snackbar("Error", "Mohon isi semua field terlebih dahulu");
    }
  }
}
