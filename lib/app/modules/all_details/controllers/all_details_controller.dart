import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class AllDetailsController extends GetxController {
  Map<String, dynamic> dataSavings = Get.arguments;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getSavingDetails() async {
    String savingName = dataSavings['name'];

    return await firestore
        .collection("savings")
        .doc(uid)
        .collection('user_savings')
        .doc(savingName)
        .collection("details")
        .orderBy("createdAt", descending: true)
        .get();
  }

  Future<void> deleteSavings() async {
    String savingName = dataSavings['name'];

    DocumentReference collectionReference = await firestore
        .collection('savings')
        .doc(uid)
        .collection('user_savings')
        .doc(savingName);

    await collectionReference.collection('details').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
    await collectionReference.delete();

    Get.offAllNamed(Routes.HOME);
    Get.snackbar('Sukses', "${dataSavings['name']} berhasil dihapus.");
    update();
    // print(
    //     'await firestore.collection(savings).doc(${uid}.collection(user_saving).doc(${savingName}))');
  }
}
