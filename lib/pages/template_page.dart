import 'package:flutter/material.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({Key? key}) : super(key: key);

  static const routeName = '/template_pages/template_page';

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
      appBar: const CustomAppBarDefault(
        title: 'Settings',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('TemplatePage'),
            ],
          ),
        ),
      ),
    );
  }
}
