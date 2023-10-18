import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_learning_app/models/message_model/message_model.dart';
import 'package:online_learning_app/utils/constants.dart';

class MyFirestoreNotificationService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  QueryDocumentSnapshot<Map<String, dynamic>>? lastQuerySnapshot;

  Future<List<MessageModel>> fetchPage(
    int pageNumber,
  ) async {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(
          paginationPageSize,
        );

    if (lastQuerySnapshot != null) {
      query = query.startAfterDocument(
        lastQuerySnapshot!,
      );
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
    lastQuerySnapshot = querySnapshot.docs.last;

    List<MessageModel> listOfMessageModel = [];
    for (var doc in querySnapshot.docs) {
      listOfMessageModel.add(
        MessageModel.fromJson(
          doc.data()..addAll({'uid': doc.id.toString()}),
        ),
      );
    }

    return listOfMessageModel;
  }

  Future<List<MessageModel>> getAllMessages() async {
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
