part of 'notification_bloc.dart';

@immutable
class NotificationState extends Equatable {
  const NotificationState({
    this.counter = 0,
    this.messageList = const [],
  });

  final int counter;
  final List<MessageModel> messageList;

  //
  @override
  List<Object?> get props => [
        counter,
        messageList,
      ];

  NotificationState copyWith({
    int? counter,
    List<MessageModel>? messageList,
  }) {
    return NotificationState(
      counter: counter ?? this.counter,
      messageList: messageList ?? this.messageList,
    );
  }
}
