import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_learning_app/pages/account_pages/privacy_policy_page/privacy_policy_page.dart';
import 'package:online_learning_app/resources/app_themes.dart';
import 'package:online_learning_app/utils/custom_shared_preferecnes.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  static const routeName = '/account_page/setting_page';

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void _navigateToPage({
    required BuildContext context,
    required String route,
    bool isRoot = false,
    Object? arguments,
  }) {
    Navigator.of(
      context,
      rootNavigator: isRoot,
    ).pushNamed(route, arguments: arguments);
  }

  void _goToPrivacyPolicyPage() {
    _navigateToPage(
      context: context,
      route: PrivacyPolicyPage.routeName,
      isRoot: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarDefault(
        title: 'Settings',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const ThemeSetting(),
              const NotificationSetting(),
              const Spacer(),
              InkWell(
                onTap: () => _goToPrivacyPolicyPage(),
                child: Text(
                  'Privacy policy and Term of Use',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Theme:',
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
              value: themeProvider.currentTheme == AppThemes.dark(),
              onChanged: (value) {
                themeProvider.toggleTheme();
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

PreferredSizeWidget settingPageAppBar({
  required VoidCallback onTap,
}) {
  return const CustomAppBarDefault(
    title: 'Settings',
  );
}
