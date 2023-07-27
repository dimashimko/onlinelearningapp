import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
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
  void _navigateToPage(String route) {
    Navigator.of(context, rootNavigator: false).pushNamedAndRemoveUntil(
      route,
      (_) => false,
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

  void _goToMainPage() {
    _navigateToPage(MainPage.routeName);
  }

  @override
  void initState() {
    // Firebase
/*    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('*** User is currently signed out!');
        // _goToSignInPage(false);
        Navigator.pushNamed(
          context,
          SignInPage.routeName,
          arguments: SignInPageArguments(
            isFirst: false,
          ),
        );
      } else {
        print('*** User is signed in!');
        Navigator.of(context, rootNavigator: false).pushReplacementNamed(
          MainPage.routeName,
        );
      }
    });*/



    // _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    Timer(
      const Duration(milliseconds: 2000),
      () {
        bool isFirst = LocalDB.instance.getFlagIsFirst() == null;
        LocalDB.instance.setFlagNoFirst();

        final UserModel localUser = LocalDB.instance.getUser();
        print('*** _setInitialData before: ${localUser.uid}');

        if (FirebaseAuth.instance.currentUser == null) {
          print('*** 1 FirebaseAuth false');
          return _goToSignInPage(isFirst);
        } else {
          print('*** 2 FirebaseAuth true');
          // return _navigateToPage(MainPage.routeName);
          return _goToMainPage();
        }

        final UserModel user = LocalDB.instance.getUser();
        final String? accessToken = user.accessToken;
        final String? refreshToken = user.refreshToken;

        return;
        return _goToSignInPage(isFirst);

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

  final Future futureDelayed = Future.delayed(
    const Duration(
      milliseconds: 2000,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FadeInAnimation(
        duration: Duration(
          milliseconds: 1000,
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

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainPage();
          } else {
            return SignInPage(isFirst: false);
          }
        },
      ),
    );

    return Scaffold(
      body: FutureBuilder(
        future: futureDelayed,
        builder: (context, snapshot) {
          log('*** snapshot: $snapshot');

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const MainPage();
                } else {
                  return SignInPage(isFirst: false);
                }
              },
            );
          } else {
            return const FadeInAnimation(
              duration: Duration(
                milliseconds: 1000,
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
            );
          }
        },
      ),
    );
  }
}
