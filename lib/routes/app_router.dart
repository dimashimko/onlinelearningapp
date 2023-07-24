import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/pages/profile_pages/profile_page/profile_page.dart';
import 'package:online_learning_app/pages/tickets_pages/ticket_details_page/ticket_details_page.dart';
import 'package:online_learning_app/pages/tickets_pages/tickets_page/ticket_page.dart';
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

    // [END] Auth pages

      // [START] Profile pages

      case ProfilePage.routeName:
        builder = (_) => const ProfilePage();
        break;

      // [END] Profile pages

      // [START] Tickets pages

      case TicketDetailsPage.routeName:
        final TicketDetailsPageArguments args =
            arguments as TicketDetailsPageArguments;
        builder = (_) => TicketDetailsPage(
              index: args.index,
              title: args.title,
            );
        break;

      case TicketsPage.routeName:
        builder = (_) => const TicketsPage();
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
