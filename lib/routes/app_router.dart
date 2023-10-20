import 'package:flutter/material.dart';
import 'package:online_learning_app/pages/account_pages/account_page/account_page.dart';
import 'package:online_learning_app/pages/account_pages/edit_account_page/edit_account_page.dart';
import 'package:online_learning_app/pages/account_pages/favorite_page/favorite_page.dart';
import 'package:online_learning_app/pages/account_pages/help_page/help_page.dart';
import 'package:online_learning_app/pages/account_pages/privacy_policy_page/privacy_policy_page.dart';
import 'package:online_learning_app/pages/account_pages/setting_page/setting_page.dart';
import 'package:online_learning_app/pages/auth_pages/log_in_page/log_in_page.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:online_learning_app/pages/auth_pages/verify_phone_page/verify_phone_page.dart';
import 'package:online_learning_app/pages/course_page/course_page.dart';
import 'package:online_learning_app/pages/home_page/home_page.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/pages/my_courses_page/my_courses_page.dart';
import 'package:online_learning_app/pages/notification_page/notification_page/notification_page.dart';
import 'package:online_learning_app/pages/one_course_pages/add_card_page/add_card_page.dart';
import 'package:online_learning_app/pages/one_course_pages/check_payment_status_page/check_payment_status_page.dart';
import 'package:online_learning_app/pages/one_course_pages/one_course_page/one_course_page.dart';
import 'package:online_learning_app/pages/one_course_pages/payment_page/payment_page.dart';
import 'package:online_learning_app/pages/search_page/search_page.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    WidgetBuilder builder;

    switch (settings.name) {
      case SignInPage.routeName:
        final SignInPageArguments args = arguments as SignInPageArguments;
        builder = (_) => SignInPage(
              isFirst: args.isFirst,
            );
        break;

      case SignUpPage.routeName:
        builder = (_) => const SignUpPage();
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

      case MainPage.routeName:
        builder = (_) => const MainPage();
        break;

      case HomePage.routeName:
        builder = (_) => const HomePage();
        break;

      case CoursePage.routeName:
        builder = (_) => const CoursePage();
        break;

      case NotificationPage.routeName:
        builder = (_) => const NotificationPage();
        break;

      case AccountPage.routeName:
        builder = (_) => const AccountPage();
        break;

      case SearchPage.routeName:
        builder = (_) => const SearchPage();
        break;

      case OneCoursePage.routeName:
        final OneCoursePageArguments args = arguments as OneCoursePageArguments;
        builder = (_) => OneCoursePage(
              uidCourse: args.uidCourse,
            );
        break;

      case MyCoursesPage.routeName:
        builder = (_) => const MyCoursesPage();
        break;

      case PaymentPage.routeName:
        final PaymentPageArguments args = arguments as PaymentPageArguments;
        builder = (_) => PaymentPage(
              price: args.price,
            );
        break;

      case AddCardPage.routeName:
        builder = (_) => const AddCardPage();
        break;

      case CheckPaymentStatusPage.routeName:
        final CheckPaymentStatusPageArguments args =
            arguments as CheckPaymentStatusPageArguments;
        builder = (_) => CheckPaymentStatusPage(
              liqPayOrder: args.liqPayOrder,
            );
        break;

      case FavoritePage.routeName:
        builder = (_) => const FavoritePage();
        break;

      case EditAccountPage.routeName:
        builder = (_) => const EditAccountPage();
        break;

      case SettingPage.routeName:
        builder = (_) => const SettingPage();
        break;

      case HelpPage.routeName:
        builder = (_) => const HelpPage();
        break;

      case PrivacyPolicyPage.routeName:
        builder = (_) => const PrivacyPolicyPage();
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
