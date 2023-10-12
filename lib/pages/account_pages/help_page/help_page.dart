import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_themes.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';
import 'package:provider/provider.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  static const routeName = '/account_pages/help_page';

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

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelpPageAppBar(
        onTap: () {
          _goToBackPage(context);
        },
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomSwitch(),
                QAItem(
                  question:
                      'How do I access the courses on the "Online Learning App"?',
                  answer:
                      'To access courses, simply log in to your account. From the main dashboard, you\'ll find a list of available courses. Click on any course to start learning.',
                ),
                QAItem(
                  question: 'How do I purchase a course?',
                  answer:
                      'To purchase a course, navigate to the course you\'re interested in and click on the "Buy Now" button. Follow the prompts to complete the purchase.',
                ),
                QAItem(
                  question: 'Can I track my progress in a course?',
                  answer:
                      'Yes, you can track your progress. In each course, you\'ll find a progress bar that shows how much of the course you\'ve completed.',
                ),
                QAItem(
                  question: 'How do I resume a course from where I left off?',
                  answer:
                      'When you log in, go to your dashboard and you\'ll see a list of courses you\'re enrolled in. Click on the course you want to continue, and it will start from where you left off.',
                ),
                QAItem(
                  question:
                      'What payment methods are accepted for purchasing courses?',
                  answer:
                      'We accept major credit and debit cards, as well as popular online payment methods.',
                ),
                QAItem(
                  question:
                      'What do I do if I encounter technical issues with the app?',
                  answer:
                      'If you experience technical difficulties, please contact our support team at [support@email.com]. Describe the issue in detail, and we\'ll assist you promptly.',
                ),
                QAItem(
                  question:
                      ' How can I change my account settings or update my profile?',
                  answer:
                      'To update your account settings or profile information, go to your profile page and click on the "Edit Profile" button.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({super.key});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Switch(
          value: isDark,
          // value: isLight,
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
    );
  }
}

class QAItem extends StatelessWidget {
  const QAItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey,
      child: ExpansionTile(
        // backgroundColor: Theme.of(context).colorScheme.outlineVariant,
        // textColor: Theme.of(context).colorScheme.onSecondaryContainer,
        // backgroundColor: Colors.grey,
        // textColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            question,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Text(
                  answer,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                  // style: TextStyle(
                  //   fontSize: 16.0,
                  //   color: Theme.of(context).colorScheme.onSecondaryContainer,
                  // ),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget HelpPageAppBar({
  required VoidCallback onTap,
}) {
  return CustomAppBar(
    leading: SvgPicture.asset(AppIcons.arrow_back),
    onLeading: onTap,
    title: const Text('Help'),
    action: const Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
