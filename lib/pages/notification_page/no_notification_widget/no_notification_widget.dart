import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class NoNotificationWidget extends StatelessWidget {
  const NoNotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.illustrationNoNotification,
            ),
            Text(
              'No Notifictations yet!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'We’ll nofify you once we have something for you ',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }
}

