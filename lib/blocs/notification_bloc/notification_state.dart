part of 'notification_bloc.dart';

@immutable
class NotificationState extends Equatable {
  const NotificationState({
    this.counter = 0,
    this.messageList = const [],
    this.notificationList = const [],
    this.timeLastSeenNotification = '',
    this.isHasNoReadNotification = false,
  });

  final int counter;
  final List<MessageModel> messageList;
  final List<NotificationModel> notificationList;
  final String timeLastSeenNotification;
  final bool isHasNoReadNotification;

  //
  @override
  List<Object?> get props => [
        counter,
        messageList,
        notificationList,
        timeLastSeenNotification,
        isHasNoReadNotification,
      ];

  NotificationState copyWith({
    int? counter,
    List<MessageModel>? messageList,
    List<NotificationModel>? notificationList,
    String? timeLastSeenNotification,
    bool? isHasNoReadNotification,
  }) {
    return NotificationState(
      counter: counter ?? this.counter,
      messageList: messageList ?? this.messageList,
      notificationList: notificationList ?? this.notificationList,
      timeLastSeenNotification:
          timeLastSeenNotification ?? this.timeLastSeenNotification,
      isHasNoReadNotification:
          isHasNoReadNotification ?? this.isHasNoReadNotification,
    );
  }
}
