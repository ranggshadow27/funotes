import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funotes/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/page_index_controller.dart';

class InputPageController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  RxBool isIncome = true.obs;
  RxBool isOutcome = false.obs;
  RxBool isLoading = false.obs;

  String dateNow = DateFormat("dd-MM-yy HH:mm:ss").format(DateTime.now());

  late String status;
  TextEditingController nomineC = TextEditingController();
  TextEditingController notesC = TextEditingController();
  TextEditingController savingC = TextEditingController();

  final pageC = Get.find<PageIndexController>();

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllSavings() async* {
    String uid = auth.currentUser!.uid;

    yield* await firestore
        .collection("savings")
        .doc(uid)
        .collection('user_savings')
        .snapshots();
  }

  setStatus() {
    if (isIncome.isFalse) {
      status = "Outcome";
    } else {
      status = "Income";
    }

    return status;
  }

  Future<int> getLastestValue() async {
    String uid = await auth.currentUser!.uid;
    int value = await firestore
        .collection("savings")
        .doc(uid)
        .collection('user_savings')
        .doc(savingC.text)
        .get()
        .then(
      (snap) {
        if (!snap.exists) {
          return 0;
        }
        return snap.data()!['total'];
      },
    );

    print(savingC.text);
    print(uid);
    print(value);
    return value;
  }

  Future<void> addData({
    required int sumValue,
    required int insertedValue,
    required String status,
  }) async {
    String uid = auth.currentUser!.uid;

    print(uid);

    await firestore
        .collection("savings")
        .doc(uid)
        .collection('user_savings')
        .doc(savingC.text)
        .collection("details")
        .doc(dateNow)
        .set({
      'value': insertedValue,
      'notes': notesC.text,
      'savings': savingC.text,
      'status': status,
      'total_value': sumValue,
      'createdAt': DateTime.now().toIso8601String(),
    });

    await firestore
        .collection('savings')
        .doc(uid)
        .collection('user_savings')
        .doc(savingC.text)
        .update({
      'total': sumValue,
    });
  }

  Future<void> addValue() async {
    if (nomineC.text.isNotEmpty) {
      if (savingC.text.isNotEmpty) {
        int addedValue = int.parse(nomineC.text);
        int currentValue = await getLastestValue();
        status = setStatus();

        try {
          isLoading.value = true;

          if (isIncome == true) {
            int sumValue = currentValue + addedValue;

            // print("${currentValue} + ${addedValue} = ${sumValue}");

            await addData(
              insertedValue: addedValue,
              sumValue: sumValue,
              status: status,
            );

            pageC.changePage(0);
            Get.snackbar("Berhasil", "Mantab");
          } else if (currentValue != 0 || !currentValue.isEqual(0)) {
            int sumValue = currentValue - addedValue;
            // print("${currentValue} - ${addedValue} = ${sumValue}");

            await addData(
              insertedValue: addedValue,
              sumValue: sumValue,
              status: status,
            );

            pageC.changePage(0);
            Get.snackbar("Berhasil", "Mantab");
          } else {
            Get.defaultDialog(
              title: 'Error',
              titleStyle: comfortaaB.copyWith(
                color: blackFont,
                fontSize: 20,
              ),
              radius: 32,
              contentPadding: EdgeInsets.all(20),
              cancel: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redAccent,
                  fixedSize: Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text(
                  "Back",
                  style: comfortaaB.copyWith(
                    color: primaryBg,
                    fontSize: 14,
                  ),
                ),
              ),
              content: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  '${savingC.text}-mu saat ini hanya berisi 0 Rupiah, Ya udah nggak bisa dikurangin lagi lah bambang. \n\n(ANTI MINUS-MINUS CLUB) Makasih.',
                  textAlign: TextAlign.justify,
                  style: comfortaaB.copyWith(
                    color: blackFont,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }
        } catch (e) {
          Get.snackbar('Error', 'Gagal menambahkan data, err: ${e}');
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Error", "Mohon untuk memilih tabungannya duluw");
      }
    } else {
      Get.snackbar("Error", "Mohon untuk mengisi nominalnya");
    }
  }
}
