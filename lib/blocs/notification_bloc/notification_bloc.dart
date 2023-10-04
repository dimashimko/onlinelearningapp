import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:online_learning_app/models/message_model/message_model.dart';
import 'package:online_learning_app/services/firestore_notification_service.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    MyFirestoreNotificationService fireStoreNotificationService =
        MyFirestoreNotificationService();

    on<GetAllMessagesEvent>(
      (event, emit) async {
        // log('@@@ GetAllMessagesEvent');
        List<MessageModel> messageList =
            await fireStoreNotificationService.getMessages();

        emit(
          state.copyWith(
            messageList: messageList,
          ),
        );
      },
    );
  }
}
