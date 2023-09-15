// set up the AlertDialog
import 'package:flutter/material.dart';
import 'package:online_learning_app/models/user_cativity/user_activity_model.dart';
import 'package:online_learning_app/services/firestore_progress_service.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:share/share.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({super.key});

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  late Future<void> cafeListFuture;

  @override
  void initState() {
    super.initState();

    MyFirestoreProgressService fireStoreProgressService =
        MyFirestoreProgressService();
    cafeListFuture = fireStoreProgressService.getActivityTime();
  }

  void onTapShare(UserActivityModel userActivityModel) {
    String content = '';
    content += 'Learned statistic:\n';
    content += 'Learned today:\n';
    content += '${(userActivityModel.timePerDay ?? 0.0) ~/ 60} min\n\n';
    content += 'Totally hours :\n';
    content += '${(userActivityModel.totallyHours ?? 0.0) ~/ 3600} hrs\n\n';
    content += 'Totally days:\n';
    content += '${(userActivityModel.totallyHours ?? 0.0) ~/ 3600} days\n\n';
    Share.share(content, subject: 'Look my learning result!');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: FutureBuilder(
        future: Future.wait([cafeListFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.onBackground,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            UserActivityModel userActivityModel =
                snapshot.data![0] as UserActivityModel;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Clocking in!",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 24.0,
                      ),
                ),
                Text(
                  "GOOD JOB!",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 32.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatItem(
                          title: 'Learned today',
                          amount: (userActivityModel.timePerDay ?? 0.0) ~/ 60,
                          units: 'min',
                        ),
                        StatItem(
                          title: 'Totally hours ',
                          amount:
                              (userActivityModel.totallyHours ?? 0.0) ~/ 3600,
                          units: 'hrs',
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0),
                    StatItem(
                      title: 'Totally days',
                      amount: (userActivityModel.totallyDays ?? 0.0).toInt(),
                      units: 'days',
                    ),
                  ],
                ),
                SizedBox(height: 32.0),
                if (userActivityModel.recordOfThisWeek != null)
                  Column(
                    children: [
                      Text(
                        'Record of this week',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: userActivityModel.recordOfThisWeek!.indexed
                              .map((element) {
                            return DayItem(
                              isEnable: element.$2,
                              text: (element.$1 + 1).toString(),
                            );
                          }).toList(),

                          /*                          children: userActivityModel.recordOfThisWeek!
                              .map((isEnable) {
                            return DayItem(
                              isEnable: isEnable,
                              text: '2',
                            );
                          }).toList(),*/
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 32.0),
                CustomButton(
                  title: 'Share',
                  onTap: () => onTapShare(userActivityModel),
                ),
              ],
            );
          }
          return Text('Error: ${snapshot.error}');
        },
      ),
    );
  }
}

class DayItem extends StatelessWidget {
  const DayItem({
    required this.isEnable,
    required this.text,
    super.key,
  });

  final bool isEnable;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          14.0,
        ),
        color: isEnable
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Center(
        child: Text(
          '$text',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  const StatItem({
    required this.title,
    required this.amount,
    required this.units,
    super.key,
  });

  final String title;
  final int amount;
  final String units;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Row(
          children: [
            Text(
              '$amount ',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              units,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ],
    );
  }
}
