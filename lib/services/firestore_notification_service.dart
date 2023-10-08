import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiffy/jiffy.dart';
import 'package:online_learning_app/models/message_model/message_model.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/models/user_activity/user_activity_model.dart';
import 'package:online_learning_app/utils/constants.dart';

class MyFirestoreNotificationService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // *****************************
  // **** Messages ******
  // *****************************
  Future<List<MessageModel>> getMessages() async {
    List<MessageModel> listOfMessageModel = [];
    await db.collection('messages').orderBy('time').get().then(
          (snapshot) {
        for (var doc in snapshot.docs) {
          listOfMessageModel.add(
            MessageModel.fromJson(
              doc.data()..addAll({'uid': doc.id.toString()}),
            ),
          );
        }
      },
    );
    listOfMessageModel = listOfMessageModel.reversed.toList();
    return listOfMessageModel;
  }
}

bool checkUserUid(String? uid) {
  if (uid == null) {
    log('*** !!! courses not update from firestore: uid == null');
    return false;
  } else {
    if (uid == '0') {
      log('*** courses not update from firestore: uid == \'0\'');
      return false;
    }
  }
  return true;
}
