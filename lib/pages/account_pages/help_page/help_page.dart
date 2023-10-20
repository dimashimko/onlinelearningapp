import 'package:flutter/material.dart';
import 'package:online_learning_app/pages/account_pages/help_page/widgets/qa_item.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  static const routeName = '/account_pages/help_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBarDefault(
        title: 'Help',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
