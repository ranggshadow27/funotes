import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        if (passC.text == "password123") {
          Get.offAllNamed(Routes.NEW_PASSWORD);
        } else {
          Get.offAllNamed(Routes.HOME);
          Get.snackbar("Berhasil", "Login Sukses!");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar("Error", "User gaada.");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Error", "Passwordnya salah.");
        }
      } catch (e) {
        Get.snackbar("Error", "Tidak dapat Login, ${e}");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Mohon isi semua field terlebih dahulu");
    }
  }
}
