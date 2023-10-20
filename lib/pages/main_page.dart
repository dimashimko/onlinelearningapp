import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/account_bloc/account_bloc.dart';
import 'package:online_learning_app/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/pages/account_pages/account_page/account_page.dart';
import 'package:online_learning_app/pages/course_page/course_page.dart';
import 'package:online_learning_app/pages/home_page/home_page.dart';
import 'package:online_learning_app/pages/notification_page/notification_page.dart';
import 'package:online_learning_app/pages/uncategorized_pages/no_network_page/no_network_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/routes/app_router.dart';
import 'package:online_learning_app/services/connectivity_service.dart';
import 'package:online_learning_app/utils/enums.dart';
import 'package:online_learning_app/widgets/elements/search_filter_sheet.dart';
import 'package:online_learning_app/widgets/navigation/custom_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
  bool searchModalBottomSheetEnabled = false;
  bool noNetworkModalBottomSheetEnabled = false;
  StreamSubscription<ConnectivityResult>? connectivityStreamSubscription;
  bool isNetworkAvailable = true;
  late CustomConnectivityService customConnectivityService;

  static const List<String> _pages = [
    HomePage.routeName,
    CoursePage.routeName,
    NotificationPage.routeName,
    NotificationPage.routeName,
    AccountPage.routeName,
  ];

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

  void _onTapSearch() {
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
  }

  void _showSearchModalBottomSheet(BuildContext context, Widget content) {
    searchModalBottomSheetEnabled = true;
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return content;
      },
    ).whenComplete(() {
      context.read<CoursesBloc>().add(FilterBottomSheetDisable());
      searchModalBottomSheetEnabled = false;
    });
  }

  void _hideSearchModalBottomSheet(BuildContext context) {
    if (searchModalBottomSheetEnabled) {
      Navigator.of(context).pop();
    }
  }

  void _showNoNetworkModalBottomSheet(BuildContext context, Widget content) {
    noNetworkModalBottomSheetEnabled = true;
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false; // Returning false prevents back button from closing the sheet
          },
          child: content,
        );
      },
      enableDrag: false,
      isDismissible: false,
    );
  }

  void _hideNoNetworkModalBottomSheet(BuildContext context) {
    if (noNetworkModalBottomSheetEnabled) {
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<ProgressBloc>().add(
          InitProgressBlocEvent(),
        );
    context.read<NotificationBloc>().add(
          InitNotificationBlocEvent(),
        );
    context.read<CoursesBloc>().add(
          CourseBlocInit(),
        );
    context.read<AccountBloc>().add(
          InitAccountBlocEvent(),
        );
    context.read<NavigationBloc>().add(
          NavigateTab(
            tabIndex: 0,
            route: _pages[0],
          ),
        );
  }

  @override
  initState() {
    super.initState();

    customConnectivityService = CustomConnectivityService(
      onChangeConnectionState: updateConnectivityStatus,
    );
    customConnectivityService.init();
  }

  void updateConnectivityStatus(bool newConnectivityState) {
    setState(() {
      isNetworkAvailable = newConnectivityState;
      if (isNetworkAvailable) {
        _hideNoNetworkModalBottomSheet(context);
      } else {
        context.read<ProgressBloc>().add(
              const ChangePlaybackStatusEvent(
                newPlaybackStatus: PlaybackStatus.pause,
              ),
            );
        _showNoNetworkModalBottomSheet(
          context,
          NoNetworkPage(
            onTapTryAgain: () {
              customConnectivityService.checkNow();
            },
          ),
        );
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    customConnectivityService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationBloc, NavigationState>(
      listener: (_, state) {
        if (state.status == NavigationStateStatus.tab) {
          _onSelectTab(state.route);
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocListener<CoursesBloc, CoursesState>(
              listenWhen: (p, c) {
                return p.filterStatus != c.filterStatus;
              },
              listener: (context, state) {
                if (state.filterStatus == FilterBottomSheetStatus.enable) {
                  _showSearchModalBottomSheet(
                    context,
                    const SearchFilterSheet(),
                  );
                }
                if (state.filterStatus == FilterBottomSheetStatus.disable) {
                  _hideSearchModalBottomSheet(
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
                    return p.userProgress != c.userProgress;
                  },
                  listener: (context, state) {
                    context.read<CoursesBloc>().add(
                          FilterUserCourses(
                            userProgress: state.userProgress,
                          ),
                        );
                  },
                  child: Navigator(
                    key: _navigatorKey,
                    initialRoute: HomePage.routeName,
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
                onTap: _onTapSearch,
                child: SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppIcons.searchDark
                      : AppIcons.searchLight,
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              currentTab: state.currentIndex,
              onSelect: (int index) {
                if (index == 2) {
                  _onTapSearch();
                  return;
                }
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
