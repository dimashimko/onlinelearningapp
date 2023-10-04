part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {
  const NotificationEvent();
}

// class SomeEvent extends PlayerEvent {}

class GetAllMessagesEvent extends NotificationEvent {}

/*class GetAllMessagesEvent extends NotificationEvent {
  const GetAllMessagesEvent({
    required this.counter,
  });

  final int counter;
}*/
