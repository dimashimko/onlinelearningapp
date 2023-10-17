import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_learning_app/database/local_database.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_fonts.dart';
import 'package:online_learning_app/widgets/animations/fade_in_animation.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _setInitialData();
  }

  void _setInitialData() {
    Timer(
      const Duration(milliseconds: 200),
      () {


        bool isFirst = LocalDB.instance.getFlagIsFirst() == null;
        LocalDB.instance.setFlagNoFirst();

        if (FirebaseAuth.instance.currentUser != null) {
          print('*** 1 FirebaseAuth true');
          return _goToMainPage();
        } else {
          print('*** 1 FirebaseAuth false');

          return _goToSignInPage(isFirst);
        }
      },
    );
  }

  void _goToSignInPage(bool isFirst) async {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      SignInPage.routeName,
      (_) => false,
      arguments: SignInPageArguments(
        isFirst: isFirst,
      ),
    );
  }

  void _goToMainPage() async {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      MainPage.routeName,
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
