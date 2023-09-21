import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class SuccessfulPurchasePage extends StatelessWidget {
  const SuccessfulPurchasePage({Key? key}) : super(key: key);

  static const routeName = '/one_course_pages/successful_purchase_page';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppIcons.check_mark3),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Successful purchase!',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                CustomButton(
                  title: 'Start learning',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget TemplatePageAppBar({
  required VoidCallback onTap,
}) {
  return CustomAppBar(
    leading: SvgPicture.asset(AppIcons.arrow_back),
    onLeading: onTap,
    title: Text('title'),
    action: Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
