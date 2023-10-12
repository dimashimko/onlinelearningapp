import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/pages/account_pages/account_page/account_page.dart';
import 'package:online_learning_app/pages/course_page/course_page.dart';
import 'package:online_learning_app/pages/home_page/home_page.dart';
import 'package:online_learning_app/pages/notification_page/notification_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/routes/app_router.dart';
import 'package:online_learning_app/widgets/elements/search_filter_sheet.dart';
import 'package:online_learning_app/widgets/navigation/custom_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<String> _pages = [
    HomePage.routeName,
    CoursePage.routeName,
    NotificationPage.routeName,
    NotificationPage.routeName,
    AccountPage.routeName,
  ];

  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  void _onSelectMenu(String route) {
    if (_navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushNamedAndRemoveUntil(
        route,
        (_) => false,
      );
    }
  }

  void _onSelectTab(String route) {
    if (_navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushNamedAndRemoveUntil(
        route,
        (route) => false,
      );
    }
  }

  Future<bool> _onWillPop() async {
    final bool maybePop = await _navigatorKey.currentState!.maybePop();

    return !maybePop;
  }

  bool modalBottomSheetEnabled = false;

  void _showModalBottomSheet(BuildContext context, Widget content) {
    modalBottomSheetEnabled = true;
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return content;
      },
    ).whenComplete(() {
      // log('*** close ModalBottomSheet');
      context.read<CoursesBloc>().add(FilterBottomSheetDisable());
      modalBottomSheetEnabled = false;
    });
  }

  void _hideModalBottomSheet(BuildContext context) {
    // log('*** _hideModalBottomSheet');
    if (modalBottomSheetEnabled) {
      Navigator.of(context).pop();
      bottomSheetEnabled = false;
    }
  }


  bool bottomSheetEnabled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log('*** didChangeDependencies MainPage');
    context.read<ProgressBloc>()
      ..add(
        UpdateUserActivityTimeEvent(),
      )
      ..add(
        GetUserProgressEvent(),
      );

    context.read<NotificationBloc>()
      ..add(
        GetAllMessagesEvent(),
      )
      ..add(
        GetAllNotificationsEvent(),
      );
    context.read<CoursesBloc>().add(
      CourseBlocInit(),
    );
  }

  @override
  Widget build(BuildContext context) {
    log('*** build MainPage');
    return BlocConsumer<NavigationBloc, NavigationState>(
      listener: (_, state) {
        if (state.status == NavigationStateStatus.menu) {
          _onSelectMenu(state.route);
        }
        if (state.status == NavigationStateStatus.tab) {
          _onSelectTab(state.route);
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            // resizeToAvoidBottomPadding: false, // flutter 1.x
            resizeToAvoidBottomInset: false, // flutter 2.x
            // backgroundColor: Colors.indigo,
            body: BlocListener<CoursesBloc, CoursesState>(
              listenWhen: (p, c) {
                return p.filterStatus != c.filterStatus;
              },
              listener: (context, state) {
                if (state.filterStatus == FilterBottomSheetStatus.enable) {
                  _showModalBottomSheet(
                    context,
                    const SearchFilterSheet(),
                  );
                }
                if (state.filterStatus == FilterBottomSheetStatus.disable) {
                  _hideModalBottomSheet(
                    context,
                  );
                }
              },
              child: BlocListener<NotificationBloc, NotificationState>(
                listenWhen: (p, c) {
                  return p.notificationList != c.notificationList ||
                      p.timeLastSeenNotification != c.timeLastSeenNotification;
                },
                listener: (context, state) {
                  context
                      .read<NotificationBloc>()
                      .add(CheckHasNoSeenNotification());
                },
                child: BlocListener<ProgressBloc, ProgressState>(
                  listenWhen: (p, c) {
                    // print(
                    //     '*** p.userProgress != c.userProgress: ${p.userProgress != c.userProgress}');
                    return p.userProgress != c.userProgress;
                  },
                  listener: (context, state) {
                    // userProgress = context.read<ProgressBloc>().state.userProgress;
                    // print('*** state.userProgress: ${state.userProgress}');
                    context.read<CoursesBloc>().add(
                          FilterUserCourses(
                            userProgress: state.userProgress,
                          ),
                        );
                  },
                  child: Navigator(
                    key: _navigatorKey,
                    initialRoute: HomePage.routeName,
                    // initialRoute: NotificationPage.routeName,
                    onGenerateRoute: AppRouter.generateRoute,
                  ),
                ),
              ),
            ),
            drawerEnableOpenDragGesture: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: InkWell(
                child: SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppIcons.search_dark
                      : AppIcons.search_light,
                ),
                onTap: () {
                  context.read<AnalyticsBloc>().add(
                        const OnBottomBarEvent(
                          routeName: 'filter',
                        ),
                      );

                  context.read<CoursesBloc>().add(
                        FilterBottomSheetEnable(
                          isFilterNavToSearchPage: true,
                        ),
                      );
                },
              ),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              currentTab: state.currentIndex,
              onSelect: (int index) {
                if (state.currentIndex != index) {
                  context.read<AnalyticsBloc>().add(
                        OnBottomBarEvent(
                          routeName: _pages[index],
                        ),
                      );

                  context.read<NavigationBloc>().add(
                        NavigateTab(
                          tabIndex: index,
                          route: _pages[index],
                        ),
                      );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
