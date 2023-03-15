import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController emailC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> forgotPassword() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar(
            "Berhasil", "Password sudah diReset, Silahkan cek email anda");
        Get.back();
      } catch (e) {
        Get.snackbar("Error", "Gagal mereset password, ${e}");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
