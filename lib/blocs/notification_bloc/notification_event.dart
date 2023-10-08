part of 'notification_bloc.dart';

enum TypeNotification {payment, simple}

@immutable
abstract class NotificationEvent {
  const NotificationEvent();
}

// class SomeEvent extends PlayerEvent {}
class CheckHasNoSeenNotification extends NotificationEvent {}

class GetTimeLastSeenNotification extends NotificationEvent {}

class SaveTimeLastSeenNotification extends NotificationEvent {
  const SaveTimeLastSeenNotification({
    required this.timeLastSeenNotification,
  });

  final String timeLastSeenNotification;
}

class GetAllNotificationsEvent extends NotificationEvent {}

class AddNotificationSuccessfulRegistrationEvent extends NotificationEvent {}

class AddNotificationCompletingFirstLessonEvent extends NotificationEvent {}

class AddNotificationSuccessfulPurchaseEvent extends NotificationEvent {}

class AddNotificationEvent extends NotificationEvent {
  const AddNotificationEvent({
    required this.notification,
  });

  final NotificationModel notification;
}

class GetAllMessagesEvent extends NotificationEvent {}

/*class GetAllMessagesEvent extends NotificationEvent {
  const GetAllMessagesEvent({
    required this.counter,
  });

  final int counter;
}*/
