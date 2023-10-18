import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirestoreAdsService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  static String collectionName = 'ads';

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
