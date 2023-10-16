import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
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
  NotificationBloc() : super(const NotificationState()) {
    //
    LocalNotificationService notificationService = LocalNotificationService();
    MyFirestoreNotificationService fireStoreNotificationService =
        MyFirestoreNotificationService();

    bool checkHasNoSeenNotification(
      List<NotificationModel> notificationList,
      String timeLastSeenNotification,
    ) {
      if (notificationList.isEmpty) return false;
      String? timeLastNotification = state.notificationList.last.time;
      if (timeLastNotification == null) return true;
      if (timeLastNotification.isEmpty) return true;

      if (timeLastSeenNotification.isEmpty) return true;
      // log('*** compare: ${timeLastNotification.compareTo(timeLastSeenNotification)}');
      bool hasNoSeenNotification =
          timeLastNotification.compareTo(timeLastSeenNotification) > 0;
      // log('*** hasNoSeenNotification: $hasNoSeenNotification');
      return hasNoSeenNotification;
    }

    on<CheckHasNoSeenNotification>(
      (event, emit) async {
        log('@@@ CheckHasNoSeenNotification');

        bool isHasNoSeenNotification = checkHasNoSeenNotification(
          state.notificationList,
          state.timeLastSeenNotification,
        );

        emit(
          state.copyWith(
            isHasNoReadNotification: isHasNoSeenNotification,
          ),
        );
      },
    );

    on<GetTimeLastSeenNotification>(
      (event, emit) async {
        log('@@@ LoadLastSeenNotification');

        String timeLastSeenNotification =
            await notificationService.getTimeLastSeenNotification() ?? '';
        emit(
          state.copyWith(
            timeLastSeenNotification: timeLastSeenNotification,
          ),
        );
      },
    );

    on<SaveTimeLastSeenNotification>(
      (event, emit) async {
        log('@@@ UpdateLastSeenNotification');

        notificationService.saveTimeLastSeenNotification(
          timeLastSeenNotification: event.timeLastSeenNotification,
        );
        emit(
          state.copyWith(
            timeLastSeenNotification: event.timeLastSeenNotification,
          ),
        );
      },
    );

    on<AddNotificationSuccessfulRegistrationEvent>(
      (event, emit) async {
        log('@@@ AddNotificationSuccessfulRegistrationEvent');

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
      },
    );

    on<AddNotificationCompletingFirstLessonEvent>(
      (event, emit) async {
        log('@@@ AddNotificationCompletingFirstLessonEvent');

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
      },
    );

    on<AddNotificationSuccessfulPurchaseEvent>(
      (event, emit) async {
        log('@@@ AddNotificationSuccessfulPurchaseEvent');

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
      },
    );

    on<AddNotificationEvent>(
      (event, emit) async {
        log('@@@ AddNotificationSuccessfulPurchaseEvent');

        // show notification
        bool isNotificationEnabled = await loadNotificationEnabled();
        if (isNotificationEnabled) {
          // Milliseconds since the start of the day
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

        // save notification to local storage
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
      },
    );

    // return list of NotificationModel from local storage of current user
    // if list of NotificationModel is
    on<GetAllNotificationsEvent>(
      (event, emit) async {
        log('@@@ GetAllNotificationsEvent');
        String? uid = FirebaseAuth.instance.currentUser?.uid;
        List<NotificationModel> notificationList =
            await notificationService.getNotifications(uid ?? '');
        // log('*** notificationList: $notificationList');

        emit(
          state.copyWith(
            notificationList: notificationList,
          ),
        );

/*        // check
        // get uid of previous user
        String lastUid = await notificationService.getLastUid();
        String? uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null && uid == lastUid) {
          List<NotificationModel> notificationList =
              await notificationService.getNotifications();
          log('*** notificationList: $notificationList');

          emit(
            state.copyWith(
              notificationList: notificationList,
            ),
          );
        } else {
          // erase notification of previous user
          notificationService.saveNotifications(
            listOfNotificationModel: [],
          );
        }*/
      },
    );

    // *****************************
    // **** Messages ******
    // *****************************
    on<GetAllMessagesEvent>(
      (event, emit) async {
        // log('@@@ GetAllMessagesEvent');
        List<MessageModel> messageList =
            await fireStoreNotificationService.getAllMessages();

        emit(
          state.copyWith(
            messageList: messageList,
          ),
        );
      },
    );

    on<InitNotificationBlocEvent>(
      (event, emit) async {
        // log('@@@ InitNotificationBlocEvent');
        add(GetAllMessagesEvent());
        add(GetAllNotificationsEvent());
        add(GetTimeLastSeenNotification());
      },
    );
  }
}
