import 'dart:convert';


import 'package:online_learning_app/database/local_database.dart';
import 'package:online_learning_app/models/notification_model/notification_model.dart';

class LocalNotificationService {
  LocalDB db = LocalDB.instance;

  Future<String?> getTimeLastSeenNotification() async {
    String? timeLastSeenNotification = db.getTimeLastSeenNotification();
    return timeLastSeenNotification;
  }

  Future<void> saveTimeLastSeenNotification({
    required String timeLastSeenNotification,
  }) async {
    db.saveTimeLastSeenNotification(
      timeLastSeenNotification,
    );
  }


  Future<void> saveNotifications({
    required List<NotificationModel>? listOfNotificationModel,
    required String userUid,
  }) async {
    if (listOfNotificationModel != null) {
      List<Map<String, dynamic>> jsonList = listOfNotificationModel
          .map((notification) => notification.toJson())
          .toList();
      String jsonString = jsonEncode(jsonList);

      db.saveNotifications(
        jsonString,
        userUid,
      );
    }
  }

  Future<List<NotificationModel>> getNotifications(String userUid) async {
    String? jsonString = db.getNotifications(userUid);
    List<dynamic> jsonList = jsonDecode(jsonString ?? '[]');
    List<NotificationModel> listOfNotificationModel =
        jsonList.map((json) => NotificationModel.fromJson(json)).toList();
    return listOfNotificationModel;
  }
}
