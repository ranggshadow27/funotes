import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterUserController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> registerUser() async {
    if (nameC.text.isNotEmpty && emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password123",
        );

        if (userCredential.user != null) {
          String userUid = userCredential.user!.uid;

          firestore.collection("users").doc(userUid).set({
            "username": nameC.text,
            "email": emailC.text,
            "createdAt": DateTime.now().toIso8601String(),
            "uid": userUid,
          });

          Get.back();
          Get.snackbar("Sukses", "Akun berhasil terdaftar");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("Error", "Password terlalu gampang");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Error", "Email sudah terdaftar");
        } else {
          Get.snackbar("Error", "Gagal menambahkan pegawai, ${e}");
        }
      } catch (e) {
        Get.snackbar("Error", "Tidak dapat menambahkan pegawai, ${e}");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Mohon field diisi terlebih dahulu");
    }
  }
}
