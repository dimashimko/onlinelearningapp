import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiffy/jiffy.dart';
import 'package:online_learning_app/models/account_model/account_model.dart';
import 'package:online_learning_app/models/message_model/message_model.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/models/user_activity/user_activity_model.dart';
import 'package:online_learning_app/utils/constants.dart';

class MyFirestoreAdsService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static String collectionName = 'ads';

  // *****************************
  // **** Account ******
  // *****************************

/*  Future<List<String>> getAdsCoursesUids() async {

    DocumentSnapshot<Map<String, dynamic>> value =
        await db.collection(collectionName).doc(uid).get();
    AccountModel accountModel = const AccountModel.empty();
    if (value.data() == null) {
      log('*** value.data() == null');
      db.collection("activity").doc(uid).set({});
    } else {
      accountModel = AccountModel.fromJson(value.data()!);
    }
    log('*** accountModel: $accountModel');
    return accountModel;
  }*/

  Future<List<String>> getAdsCoursesUids() async {
    List<String> listOfAdsCoursesUids = [];
    await db.collection(collectionName).orderBy('position').get().then(
      (snapshot) {
        for (var doc in snapshot.docs) {
          listOfAdsCoursesUids.add(
              doc.data()['uidCourse'].toString(),
          );
        }
      },
    );
    return listOfAdsCoursesUids;
  }

}
