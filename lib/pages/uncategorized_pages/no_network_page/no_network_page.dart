import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';

class NoNetworkPage extends StatelessWidget {
  const NoNetworkPage({
    required this.onTapTryAgain,
    Key? key,
  }) : super(key: key);

  static const routeName = '/no_network_page/no_network_page';
  final VoidCallback onTapTryAgain;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.illustrationNoVideo,
                ),
                Text(
                  'No Network!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'Please check your internet connection and try again',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: 240,
                  child: CustomButton(
                    title: 'Try again',
                    // onTap: () => _onTapTryAgain(context),
                    onTap: () => onTapTryAgain(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
