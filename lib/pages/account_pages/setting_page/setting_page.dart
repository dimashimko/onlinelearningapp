import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:online_learning_app/pages/account_pages/privacy_policy_page/privacy_policy_page.dart';
import 'package:online_learning_app/resources/app_themes.dart';
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

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
/*      appBar: settingPageAppBar(
        onTap: () => _goToBackPage(context),
      ),*/
      appBar: const CustomAppBarDefault(
        title: 'Settings',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Theme:'),
                  const Spacer(),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Switch(
                        value: themeProvider.currentTheme == AppThemes.dark(),
                        onChanged: (value) {
                          setState(() {
                            log('*** on switch');
                            isDark = !isDark;
                            themeProvider.toggleTheme();
                            // themeProvider.toggleTheme2(isDark);
                          });
                        },
                      );
                    },
                  ),
/*                  Switch(
                    // This bool value toggles the switch.
                    value: light,
                    activeColor: Colors.black,
                    onChanged: (bool value) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        light = value;
                      });
                    },
                  ),*/
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () => _goToPrivacyPolicyPage(),
                child: const Text(
                  'Privacy policy and Term of Use',
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
