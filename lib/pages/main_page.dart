import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_learning_app/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/pages/home_page/home_page.dart';
import 'package:online_learning_app/pages/profile_pages/profile_page/profile_page.dart';
import 'package:online_learning_app/pages/tickets_pages/tickets_page/ticket_page.dart';
import 'package:online_learning_app/routes/app_router.dart';
import 'package:online_learning_app/utils/singletons.dart';
import 'package:online_learning_app/widgets/navigation/custom_bottom_navigation_bar.dart';
import 'package:online_learning_app/widgets/navigation/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  static const routeName = '/root';

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('*** User is currently signed out!');
        // _goToSignInPage(false);
        if (AppNavigator.navigatorKey.currentState != null) {
          AppNavigator.navigatorKey.currentState!.pushNamed(
            SignInPage.routeName,
            arguments: SignInPageArguments(
              isFirst: false,
            ),
          );
        } else {
          log('*** AppNavigator.navigatorKey.currentState == null');
        }
/*        Navigator.pushNamed(
          context,
          SignInPage.routeName,
          arguments: SignInPageArguments(
            isFirst: false,
          ),
        );*/
      } else {
        print('*** User is signed in!');
        if (AppNavigator.navigatorKey.currentState != null) {
          AppNavigator.navigatorKey.currentState!.pushNamed(
            MainPage.routeName,
          );
        } else {
          log('*** AppNavigator.navigatorKey.currentState == null');
        }
/*        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          MainPage.routeName,
          (_) => false,
        );*/
      }
    });
  }

  @override
  Widget build(BuildContext context) {
/*    return FirebaseAuth.instance.currentUser == null
        ? SignInPage(isFirst: false)
        : const MainPage();*/
    return Scaffold(
      body: Navigator(
        key: AppNavigator.navigatorKey,
        initialRoute: MainPage.routeName,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<String> _pages = [
    HomePage.routeName,
    // TicketsPage.routeName,
    ProfilePage.routeName,
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
    // log('*** route name: ${ModalRoute.of(context)?.settings.name}');

    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (_) => NavigationBloc(),
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
                // key: AppNavigator.navigatorKey,
                initialRoute: HomePage.routeName,
                onGenerateRoute: AppRouter.generateRoute,
              ),
              drawerEnableOpenDragGesture: false,
              drawer: const CustomDrawer(),
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
