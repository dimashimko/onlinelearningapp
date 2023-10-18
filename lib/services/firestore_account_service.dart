

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_learning_app/models/account_model/account_model.dart';

class MyFirestoreAccountService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static String collectionName = 'account';

  void pushAccountModel({
    required AccountModel accountModel,
  }) {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (checkUserUid(uid)) {
      db.collection(collectionName).doc(uid).set(
            accountModel.toJson(),
          );
    }
  }

  Future<AccountModel> getAccountModel() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    DocumentSnapshot<Map<String, dynamic>> value =
        await db.collection(collectionName).doc(uid).get();
    AccountModel accountModel = const AccountModel.empty();
    if (value.data() == null) {

      db.collection("activity").doc(uid).set({});
    } else {
      accountModel = AccountModel.fromJson(value.data()!);
    }

    return accountModel;
  }
}

bool checkUserUid(String? uid) {
  if (uid == null) {

    return false;
  } else {
    if (uid == '0') {

      return false;
    }
  }
  return true;
}
