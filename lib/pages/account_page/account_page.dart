import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const routeName = '/account_page/account_page';

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
      appBar: MessagePageAppBar(onTap: () {
        _goToBackPage(context);
      }),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Placeholder(),
                SvgPicture.asset(AppIcons.rectangle),
                // SvgPicture.asset(AppIcons.rectangle),
                SvgPicture.asset(AppIcons.rectangle2),
                SvgPicture.asset(AppIcons.rectangle),
                SvgPicture.asset(AppIcons.rectangle),
                SvgPicture.asset(AppIcons.rectangle2),
                SvgPicture.asset(AppIcons.rectangle),
                Text('AccountPage'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget MessagePageAppBar({
  required VoidCallback onTap,
}) {
  return CustomAppBar(
    leading: SvgPicture.asset(AppIcons.arrow_back),
    onLeading: () {},
    title: const Text('AccountPage'),
    action: const Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
