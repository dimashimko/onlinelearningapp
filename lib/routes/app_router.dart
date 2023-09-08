import 'package:online_learning_app/pages/account_page/account_page.dart';
import 'package:online_learning_app/pages/auth_pages/log_in_page/log_in_page.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:online_learning_app/pages/auth_pages/verify_phone_page/verify_phone_page.dart';
import 'package:online_learning_app/pages/course_page/course_page.dart';
import 'package:online_learning_app/pages/home_page/home_page.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:online_learning_app/pages/message_page/message_page.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/pages/search_page/search_page.dart';

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
        builder = (_) => const LogInPage();
        break;

      case VerifyPhonePage.routeName:
        final VerifyPhonePageArguments args =
            arguments as VerifyPhonePageArguments;
        builder = (_) => VerifyPhonePage(
              phoneNumber: args.phoneNumber,
              verificationId: args.verificationId,
            );
        break;

      // [END] Auth pages

      case MainPage.routeName:
        builder = (_) => const MainPage();
        break;

      case HomePage.routeName:
        builder = (_) => const HomePage();
        break;

      case CoursePage.routeName:
        builder = (_) => CoursePage();
        break;

      case MessagePage.routeName:
        builder = (_) => const MessagePage();
        break;

      case AccountPage.routeName:
        builder = (_) => const AccountPage();
        break;

      case SearchPage.routeName:
        builder = (_) =>  SearchPage();
        break;


      // case OneCoursePage.routeName:
      //   builder = (_) =>  OneCoursePage();
      //   break;

      case OneCoursePage.routeName:
        final OneCoursePageArguments args =
        arguments as OneCoursePageArguments;
        builder = (_) => OneCoursePage(
          uidCourse: args.uidCourse,
        );
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
