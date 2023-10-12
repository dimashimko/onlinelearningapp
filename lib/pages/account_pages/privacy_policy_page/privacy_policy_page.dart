import 'package:flutter/material.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  static const routeName = '/account_pages/privacy_policy_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBarDefault(
        title: 'Privacy policy',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '''At [Online Learning App], we value and prioritize the privacy and security of our users' personal information. This Privacy Policy outlines how we collect, use, store, and disclose information when you use our online learning app. By using our app, you consent to the practices described in this policy. We encourage you to read this Privacy Policy carefully. 
Information We Collect: When you use our app, we may collect the following information:
• Personal information: such as your name, email address, and profile information.
• Usage information: including your interactions with the app, courses accessed, progress, and preferences.
• Device information: such as your device type, operating system, and unique device identifiers.
• Log data: information about your use of the app, IP address, browser type, and pages visited.''',
              ),
            ],
          ),
        ),
      ),
    );
  }
}


