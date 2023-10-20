import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class LoginWithOtherServicesButtons extends StatelessWidget {
  const LoginWithOtherServicesButtons({
    required this.onGoogle,
    required this.onFacebook,
    Key? key,
  }) : super(key: key);

  final VoidCallback onGoogle;
  final VoidCallback onFacebook;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Or login with',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Expanded(
              child: Divider(),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: SvgPicture.asset(AppIcons.google),
              onTap: () {
                onGoogle();
              },
            ),
            const SizedBox(width: 20.0),
            InkWell(
              child: SvgPicture.asset(AppIcons.facebook),
              onTap: () {
                onFacebook();
              },
            ),
          ],
        )
      ],
    );
  }
}
