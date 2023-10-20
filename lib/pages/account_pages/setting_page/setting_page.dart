import 'package:flutter/material.dart';
import 'package:online_learning_app/pages/account_pages/privacy_policy_page/privacy_policy_page.dart';
import 'package:online_learning_app/pages/account_pages/setting_page/widgets/notification_setting.dart';
import 'package:online_learning_app/pages/account_pages/setting_page/widgets/theme_setting.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

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

PreferredSizeWidget settingPageAppBar({
  required VoidCallback onTap,
}) {
  return const CustomAppBarDefault(
    title: 'Settings',
  );
}
