import 'dart:async';

import 'package:online_learning_app/database/local_database.dart';
import 'package:online_learning_app/models/users/user_model.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_fonts.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/widgets/animations/fade_in_animation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    Timer(
      const Duration(milliseconds: 200),
      () {
        final UserModel user = LocalDB.instance.getUser();
        final String? accessToken = user.accessToken;
        final String? refreshToken = user.refreshToken;

        bool isFirst = LocalDB.instance.getFlagIsFirst() == null;
        LocalDB.instance.setFlagNoFirst();

        // if no token
        if (refreshToken == null || accessToken == null) {
          // return _navigateToPage(SignInPage.routeName);
          return _goToSignInPage(isFirst);
        }

        // if token isExpired
        if (JwtDecoder.isExpired(refreshToken)) {
          /*context.read<AuthBloc>().add(
                  Logout(),
                );*/

          // return _navigateToPage(SignInPage.routeName);
          return _goToSignInPage(isFirst);
        }

        return _navigateToPage(MainPage.routeName);
      },
    );
  }

  void _goToSignInPage(bool isFirst) async {
    Navigator.pushNamed(
      context,
      SignInPage.routeName,
      arguments: SignInPageArguments(
        isFirst: isFirst,
      ),
    );
  }

  void _navigateToPage(String route) {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      route,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FadeInAnimation(
        duration: Duration(
          milliseconds: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Online Learning App',
              style: TextStyle(
                fontSize: 26.0,
                color: AppColors.textPrimary,
                fontWeight: AppFonts.extraBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
