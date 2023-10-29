import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/models/notification_model/notification_model.dart';
import 'package:online_learning_app/pages/notification_page/no_notification_widget/no_notification_widget.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/utils/enums.dart';
import 'package:online_learning_app/utils/extensions.dart';

class NotificationTabView extends StatelessWidget {
  const NotificationTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                return state.notificationList.isEmpty
                    ? const NoNotificationWidget()
                    : Column(
                        children: state.notificationList.reversed
                            .map((notification) => NotificationItem(
                                  notification: notification,
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

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.notification,
    super.key,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
        ),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            SvgPicture.asset(
              notification.typeNotification == TypeNotification.payment
                  ? AppIcons.notificationIconPayment
                  : AppIcons.notificationIconSimle,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.text ?? '',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.clock,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        (DateTime.tryParse(notification.time ?? '') ??
                                DateTime.now())
                            .toRelativeTime(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
