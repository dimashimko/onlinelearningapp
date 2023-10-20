import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:online_learning_app/models/message_model/message_model.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/services/firestore_notification_service.dart';
import 'package:online_learning_app/utils/constants.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';

class MessageTabView extends StatefulWidget {
  const MessageTabView({super.key});

  @override
  State<MessageTabView> createState() => _MessageTabViewState();
}

class _MessageTabViewState extends State<MessageTabView> {
  final PagingController<int, MessageModel> _pagingController =
      PagingController(firstPageKey: 0);
  final MyFirestoreNotificationService notificationService =
      MyFirestoreNotificationService();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await notificationService.fetchPage(pageKey);

      final isLastPage = newItems.length < paginationPageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => PagedListView<int, MessageModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<MessageModel>(
          itemBuilder: (context, item, index) => MessageItem(
            message: item,
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CustomImageViewer(
                    link: message.iconLink,
                    alternativePhoto: AppImages.emptyMessageIcon,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    message.name ?? '',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 14.0,
                        ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  formatDateTime(
                    DateTime.tryParse(message.time.toString()) ??
                        DateTime.now(),
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              message.text ?? '',
              style: TextStyle(
                color: colors(context).grey!,
              ),
            ),
            const SizedBox(height: 12.0),
            if (message.imageLink != null)
              CustomImageViewer(
                link: message.imageLink,
                alternativePhoto: AppImages.emptyMessageIcon,
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
