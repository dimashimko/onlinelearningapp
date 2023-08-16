import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:online_learning_app/pages/account_page/account_page.dart';
import 'package:online_learning_app/pages/course_page/course_page.dart';
import 'package:online_learning_app/pages/home_page/home_page.dart';
import 'package:online_learning_app/pages/message_page/message_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/routes/app_router.dart';
import 'package:online_learning_app/widgets/navigation/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    MessagePage.routeName,
    MessagePage.routeName,
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (_) => NavigationBloc(),
        ),
        BlocProvider<CoursesBloc>(
          create: (_) => CoursesBloc()/*..add(CourseBlocInit())*/,
        ),
      ],
      child: BlocConsumer<NavigationBloc, NavigationState>(
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
              body: Navigator(
                key: _navigatorKey,
                initialRoute: HomePage.routeName,
                onGenerateRoute: AppRouter.generateRoute,
              ),
              drawerEnableOpenDragGesture: false,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterDocked,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? AppIcons.search_dark
                      : AppIcons.search_light,
                ),
              ),
              bottomNavigationBar: CustomBottomNavigationBar(
                currentTab: state.currentIndex,
                onSelect: (int index) {
                  if (state.currentIndex != index) {
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
      ),
    );
  }
}
