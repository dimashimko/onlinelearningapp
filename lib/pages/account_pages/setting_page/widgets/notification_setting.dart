import 'package:flutter/material.dart';
import 'package:online_learning_app/database/shared_preferecnes.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    loadNotificationEnabledState();
  }

  void loadNotificationEnabledState() async {
    isNotificationEnabled = await loadNotificationEnabled();
    setState(() {});
  }

  void saveNotificationEnabledState(bool newState) async {
    saveNotificationEnabled(newState);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Notification:',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        const Spacer(),
        const SizedBox(height: 8.0),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Switch.adaptive(
              value: isNotificationEnabled,
              onChanged: (value) {
                saveNotificationEnabledState(value);
                setState(() {
                  isNotificationEnabled = !isNotificationEnabled;
                });
              },
              activeColor: colors(context).violetLight,
              activeTrackColor: colors(context).blue,
              inactiveThumbColor: colors(context).violetLight,
              inactiveTrackColor: colors(context).greyDark,
            );
          },
        ),
      ],
    );
  }
}
