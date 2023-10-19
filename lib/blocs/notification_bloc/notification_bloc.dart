import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/models/message_model/message_model.dart';
import 'package:online_learning_app/models/notification_model/notification_model.dart';
import 'package:online_learning_app/services/firestore_notification_service.dart';
import 'package:online_learning_app/services/local_notification_service.dart';
import 'package:online_learning_app/services/notifi_service.dart';
import 'package:online_learning_app/utils/custom_shared_preferecnes.dart';
import 'package:uuid/uuid.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  LocalNotificationService notificationService = LocalNotificationService();
  MyFirestoreNotificationService fireStoreNotificationService =
      MyFirestoreNotificationService();

  NotificationBloc() : super(const NotificationState()) {
    on<ClearNotificationsStateEvent>(_clearNotificationsStateEvent);
    on<CheckHasNoSeenNotification>(_checkHasNoSeenNotification);
    on<GetTimeLastSeenNotification>(_getTimeLastSeenNotification);
    on<SaveTimeLastSeenNotification>(_saveTimeLastSeenNotification);
    on<AddNotificationSuccessfulRegistrationEvent>(
        _addRegistrationNotification);
    on<AddNotificationCompletingFirstLessonEvent>(
        _addCompletingFirstLessonNotification);
    on<AddNotificationSuccessfulPurchaseEvent>(
        _addSuccessfulPurchaseNotification);
    on<AddNotificationEvent>(_addNotification);
    on<GetAllNotificationsEvent>(_getAllNotifications);
    on<GetAllMessagesEvent>(_getAllMessages);
    on<InitNotificationBlocEvent>(_initNotificationBloc);
  }

  void _clearNotificationsStateEvent(
    ClearNotificationsStateEvent event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        notificationList: [],
      ),
    );
  }

  bool checkHasNoSeenNotification(
    List<NotificationModel> notificationList,
    String timeLastSeenNotification,
  ) {
    if (notificationList.isEmpty) return false;
    String? timeLastNotification = state.notificationList.last.time;
    if (timeLastNotification == null) return true;
    if (timeLastNotification.isEmpty) return true;

    if (timeLastSeenNotification.isEmpty) return true;

    bool hasNoSeenNotification =
        timeLastNotification.compareTo(timeLastSeenNotification) > 0;

    return hasNoSeenNotification;
  }

  void _checkHasNoSeenNotification(
    CheckHasNoSeenNotification event,
    Emitter<NotificationState> emit,
  ) {
    bool isHasNoSeenNotification = checkHasNoSeenNotification(
      state.notificationList,
      state.timeLastSeenNotification,
    );

    emit(
      state.copyWith(
        isHasNoReadNotification: isHasNoSeenNotification,
      ),
    );
  }

  void _getTimeLastSeenNotification(
    GetTimeLastSeenNotification event,
    Emitter<NotificationState> emit,
  ) async {
    String timeLastSeenNotification =
        await notificationService.getTimeLastSeenNotification() ?? '';
    emit(
      state.copyWith(
        timeLastSeenNotification: timeLastSeenNotification,
      ),
    );
  }

  void _saveTimeLastSeenNotification(
    SaveTimeLastSeenNotification event,
    Emitter<NotificationState> emit,
  ) {
    notificationService.saveTimeLastSeenNotification(
      timeLastSeenNotification: event.timeLastSeenNotification,
    );
    emit(
      state.copyWith(
        timeLastSeenNotification: event.timeLastSeenNotification,
      ),
    );
  }

  void _addRegistrationNotification(
    AddNotificationSuccessfulRegistrationEvent event,
    Emitter<NotificationState> emit,
  ) {
    NotificationModel notificationModel = NotificationModel(
      typeNotification: TypeNotification.simple,
      uid: const Uuid().v4(),
      time: DateTime.now().toString(),
      text:
          'Congratulations, you have completed your registration! Let\'s start your learning journey next.',
      title: 'Completing the registration',
    );
    add(
      AddNotificationEvent(
        notification: notificationModel,
      ),
    );
  }

  void _addCompletingFirstLessonNotification(
    AddNotificationCompletingFirstLessonEvent event,
    Emitter<NotificationState> emit,
  ) {
    NotificationModel notificationModel = NotificationModel(
      typeNotification: TypeNotification.simple,
      uid: const Uuid().v4(),
      time: DateTime.now().toString(),
      text:
          'Congratulations on completing the first lesson, keep up the good work!',
      title: 'Completing the first lesson',
    );
    add(
      AddNotificationEvent(
        notification: notificationModel,
      ),
    );
  }

  void _addSuccessfulPurchaseNotification(
    AddNotificationSuccessfulPurchaseEvent event,
    Emitter<NotificationState> emit,
  ) {
    NotificationModel notificationModel = NotificationModel(
      typeNotification: TypeNotification.payment,
      uid: const Uuid().v4(),
      time: DateTime.now().toString(),
      text: 'Successful purchase!',
      title: 'Successful purchase!',
    );

    add(
      AddNotificationEvent(
        notification: notificationModel,
      ),
    );
  }

  void _addNotification(
    AddNotificationEvent event,
    Emitter<NotificationState> emit,
  ) async {
    bool isNotificationEnabled = await loadNotificationEnabled();
    if (isNotificationEnabled) {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      Duration difference = now.difference(startOfDay);
      int milliseconds = difference.inMilliseconds;

      NotificationService().showNotification(
        id: milliseconds,
        title: event.notification.title,
        body: event.notification.text,
      );
    }

    List<NotificationModel> notificationList = [...state.notificationList];
    notificationList.add(event.notification);

    String? userUid = FirebaseAuth.instance.currentUser?.uid;

    notificationService.saveNotifications(
      listOfNotificationModel: notificationList,
      userUid: userUid ?? '',
    );

    emit(
      state.copyWith(
        notificationList: notificationList,
      ),
    );
  }

  void _getAllNotifications(
    GetAllNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    List<NotificationModel> notificationList =
        await notificationService.getNotifications(uid ?? '');

    emit(
      state.copyWith(
        notificationList: notificationList,
      ),
    );
  }

  void _getAllMessages(
    GetAllMessagesEvent event,
    Emitter<NotificationState> emit,
  ) async {
    List<MessageModel> messageList =
        await fireStoreNotificationService.getAllMessages();

    emit(
      state.copyWith(
        messageList: messageList,
      ),
    );
  }

  void _initNotificationBloc(
    InitNotificationBlocEvent event,
    Emitter<NotificationState> emit,
  ) {
    add(GetAllMessagesEvent());
    add(GetAllNotificationsEvent());
    add(GetTimeLastSeenNotification());
  }
}
