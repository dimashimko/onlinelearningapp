import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/pages/notification_page/message_tab/message_tab_view.dart';
import 'package:online_learning_app/pages/notification_page/notification_page/widgets/custom_notification_tab_bar.dart';
import 'package:online_learning_app/pages/notification_page/notification_page/widgets/title_of_notification_page.dart';
import 'package:online_learning_app/pages/notification_page/notification_tab/notification_tab_view.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  static const routeName = '/notification_page/notification_page';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<Widget> tabs;

  final List<Widget> tabsView = [
    const MessageTabView(),
    const NotificationTabView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleOfNotificationPage(),
              const SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    tabs = [
                      const CustomNotificationTabBar(
                        name: ' message ',
                        hasNew: false,
                      ),
                      CustomNotificationTabBar(
                        name: ' notification ',
                        hasNew: state.isHasNoReadNotification,
                      ),
                    ];
                    return DefaultTabController(
                      length: tabs.length,
                      child: Column(
                        children: [
                          TabBar(
                            onTap: (int index) {
                              if (index == 1) {
                                context.read<NotificationBloc>().add(
                                      SaveTimeLastSeenNotification(
                                        timeLastSeenNotification:
                                            DateTime.now().toString(),
                                      ),
                                    );
                              }
                            },
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
