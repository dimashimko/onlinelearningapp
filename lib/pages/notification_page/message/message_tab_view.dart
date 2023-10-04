import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/models/message_model/message_model.dart';
import 'package:online_learning_app/pages/notification_page/no_notification_widget/no_notification_widget.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/resources/app_themes.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';
import 'package:intl/intl.dart';

class MessageTabView extends StatelessWidget {
  const MessageTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
/*            CustomButton(
                title: 'GetAllMessagesEvent',
                onTap: () {
                  context.read<NotificationBloc>().add(
                        GetAllMessagesEvent(),
                      );
                }),*/
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                return state.messageList.isEmpty
                    ? const NoNotificationWidget()
                    : Column(
                        children: state.messageList
                            .map((message) => MessageItem(
                                  message: message,
                                ))
                            .toList(),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({
    required this.message,
    super.key,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(16.0),
          // borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
          // color: Colors.black54,
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CustomImageViewer(
                    link: message.iconLink,
                    alternativePhoto: AppImages.empty_message_icon,
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    message.name.toString(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 14.0,
                        ),
                  ),
                ),
                SizedBox(width: 8.0),
                Text(
                  formatDateTime(
                    DateTime.tryParse(message.time.toString()) ??
                        DateTime.now(),
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Text(
              message.text ?? '',
              style: TextStyle(
                color: colors(context).grey!,
              ),
/*              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 14.0,
                color: colors(context).grey!
              ),*/
            ),
            SizedBox(height: 12.0),
            if (message.imageLink != null)
              CustomImageViewer(
                link: message.imageLink,
                alternativePhoto: AppImages.empty_message_icon,
              )
          ],
        ),
      ),
    );
  }
}

String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  String formattedTime = DateFormat.jm().format(dateTime);

  if (dateTime.day == now.day &&
      dateTime.month == now.month &&
      dateTime.year == now.year) {
    return formattedTime; // Return time only if it's today
  } else {
    String formattedDate = DateFormat.yMMMd().add_jm().format(dateTime);
    return formattedDate; // Return date and time if it's not today
  }
}

String formatTime(String formattedString) {
  DateTime dataTime = DateTime.parse(formattedString);

  String formattedTime = DateFormat.jm().format(dataTime);
  return formattedTime;
}
