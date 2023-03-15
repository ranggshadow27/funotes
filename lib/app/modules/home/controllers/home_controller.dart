import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funotes/theme.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController savingName = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserData() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection('users').doc(uid).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllSavings() async {
    String uid = auth.currentUser!.uid;

    return await firestore
        .collection("savings")
        .doc(uid)
        .collection('user_savings')
        .orderBy("createdAt", descending: true)
        .get();
  }

  Future<void> addSavings() async {
    String uid = auth.currentUser!.uid;

    if (savingName != "" || savingName != null) {
      firestore
          .collection("savings")
          .doc(uid)
          .collection('user_savings')
          .doc(savingName.text)
          .set({
        "name": savingName.text,
        "createdAt": DateTime.now().toIso8601String(),
        "total": 0,
      });

      Get.back();
      Get.snackbar("Berhasil", "Mantap");
      update();
    } else {
      Get.snackbar("Eror", "Mohon isi field");
    }
  }

  addNewSavings() {
    Get.defaultDialog(
      title: '',
      radius: 36,
      contentPadding: EdgeInsets.symmetric(horizontal: 26, vertical: 10),
      content: Column(
        children: [
          Text(
            "Name your Saving.",
            style: comfortaaB.copyWith(
              fontSize: 14,
              color: blackFont,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: savingName,
            style: comfortaaB.copyWith(color: blackFont, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: primaryBg,
              hintText: 'New Saving',
              hintStyle: comfortaaM.copyWith(color: greyFont, fontSize: 14),
              contentPadding: EdgeInsets.all(22),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(
                  width: 2,
                  color: greyFont.withAlpha(140),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
          SizedBox(height: 26),
          Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [greenButtonL, greenButtonR],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                addSavings();
              },
              child: Container(
                width: 300,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Center(
                  child: Text(
                    "Add Saving",
                    style: comfortaaB.copyWith(color: whiteFont),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
