import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:funotes/app/routes/app_pages.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty && confirmPassC.text.isNotEmpty) {
      if (newPassC.text == confirmPassC.text) {
        if (newPassC.text != "password123") {
          isLoading.value = true;
          try {
            await auth.currentUser!.updatePassword(newPassC.text);

            String email = auth.currentUser!.email!;

            await auth.signOut();

            await auth.signInWithEmailAndPassword(
              email: email,
              password: confirmPassC.text,
            );

            Get.offAllNamed(Routes.HOME);
            Get.snackbar("Berhasil", "Password sudah terganti");
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              Get.snackbar("Error", "Password terlalu lemah");
            } else {
              Get.snackbar("Error", "Tidak dapat menggati Password. ${e}");
            }
          } finally {
            isLoading.value = false;
          }
        } else {
          Get.snackbar("Error", "Password masih sama seperti default.");
        }
      } else {
        Get.snackbar("Error", "Password tidak sesuai");
      }
    } else {
      Get.snackbar("Error", "Mohon diisi terlebih dahulu.");
    }
  }
}
