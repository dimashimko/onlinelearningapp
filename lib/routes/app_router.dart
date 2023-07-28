import 'package:online_learning_app/pages/auth_pages/log_in_page/log_in_page.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:online_learning_app/pages/home_page/home_page.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/pages/profile_pages/profile_page/profile_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    WidgetBuilder builder;

    switch (settings.name) {
    // [START] Auth pages
      case SignInPage.routeName:
        final SignInPageArguments args = arguments as SignInPageArguments;
        builder = (_) => SignInPage(
          isFirst: args.isFirst,
        );
        break;

      case SignUpPage.routeName:
        builder = (_) => SignUpPage();
        break;

      case LogInPage.routeName:
        builder = (_) => LogInPage();
        break;

    // [END] Auth pages

    // [START] Profile pages

      case ProfilePage.routeName:
        builder = (_) => const ProfilePage();
        break;

    // [END] Profile pages

    // [START] Tickets pages

      case HomePage.routeName:
        builder = (_) => const HomePage();
        break;

    // [END] Tickets pages

      case MainPage.routeName:
        builder = (_) => const MainPage();
        break;

      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
