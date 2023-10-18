import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirestoreAdsService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static String collectionName = 'ads';

/*  Future<List<String>> getAdsCoursesUids() async {

    DocumentSnapshot<Map<String, dynamic>> value =
        await db.collection(collectionName).doc(uid).get();
    AccountModel accountModel = const AccountModel.empty();
    if (value.data() == null) {

      db.collection("activity").doc(uid).set({});
    } else {
      accountModel = AccountModel.fromJson(value.data()!);
    }

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
