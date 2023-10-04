import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/pages/notification_page/message/message_tab_view.dart';
import 'package:online_learning_app/pages/notification_page/notification/notification_tab_view.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({Key? key}) : super(key: key);

  static const routeName = '/notification_page/notification_page';

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

  //   message
  // notification
  final List<Widget> tabs = [
    const CustomTabBar(
      name: ' message ',
      hasNew: false,
      // hasNew: true,
    ),
    const CustomTabBar(
      name: ' notification ',
      hasNew: true,
    ),
  ];

  final List<Widget> tabsView = [
    const MessageTabView(),
    const NotificationTabView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: MessagePageAppBar(onTap: () {
        _goToBackPage(context);
      }),*/
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocProvider(
            // create: (context) => NotificationBloc(),
            create: (context) => NotificationBloc()..add(GetAllMessagesEvent()),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitlePage(),
                const SizedBox(height: 16.0),
                Expanded(
                  child: DefaultTabController(
                    length: tabs.length,
                    child: Column(
                      children: [
                        TabBar(
                          dividerColor: Colors.transparent,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 3.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            insets: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                          ),
                          tabs: tabs
                              .map(
                                (tab) => tab,
                              )
                              .toList(),
                          isScrollable: false,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: tabsView.map((e) => e).toList(),
                          ),
                        )
                      ],
                    ),
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

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    required this.name,
    required this.hasNew,
    super.key,
  });

  final String name;
  final bool hasNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        hasNew
            ? SvgPicture.asset(
                AppIcons.point_orange,
              )
            : SizedBox(height: 6.0),
        Text(
          name,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              // color: Colors.orange,
              ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'Notifications',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 24.0,
            ),
        textAlign: TextAlign.start,
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
    title: const Text('Notifications'),
    action: const Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
