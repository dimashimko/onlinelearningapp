import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/account_bloc/account_bloc.dart';
import 'package:online_learning_app/blocs/ads_block/ads_bloc.dart';
import 'package:online_learning_app/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/database/local_database.dart';
import 'package:online_learning_app/firebase_options.dart';
import 'package:online_learning_app/pages/uncategorized_pages/splash_screen_page/splash_screen_page.dart';
import 'package:online_learning_app/resources/app_locale.dart';
import 'package:online_learning_app/resources/themes/theme_provider.dart';
import 'package:online_learning_app/routes/app_router.dart';
import 'package:online_learning_app/services/notifi_service.dart';
import 'package:provider/provider.dart';

void _errorHandler(Object error, StackTrace stack) {
  log(
    '\nError description: $error'
    '\nStackTrace:\n$stack',
    name: 'Error handler',
  );
}

Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      NotificationService().initNotification();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await EasyLocalization.ensureInitialized();
      await LocalDB.instance.ensureInitialized();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      runApp(
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: EasyLocalization(
            path: AppLocale.path,
            supportedLocales: AppLocale.supportedLocales,
            fallbackLocale: AppLocale.fallbackLocale,
            child: const _App(),
          ),
        ),
      );
      EasyLocalization.logger.enableBuildModes = [];
    },
    _errorHandler,
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        BlocProvider<CoursesBloc>(
          create: (_) => CoursesBloc()
            ..add(
              CourseBlocInit(),
            ),
        ),
        BlocProvider<ProgressBloc>(
          create: (_) => ProgressBloc()
            ..add(
              InitProgressBlocEvent(),
            ),
        ),
        BlocProvider<NavigationBloc>(
          create: (_) => NavigationBloc(),
        ),
        BlocProvider<AnalyticsBloc>(
          create: (_) => AnalyticsBloc(),
        ),
        BlocProvider<AccountBloc>(
          create: (_) => AccountBloc()
            ..add(
              InitAccountBlocEvent(),
            ),
        ),
        BlocProvider<AdsBloc>(
          create: (_) => AdsBloc()
            ..add(
              GetAdsCoursesUids(),
            ),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => NotificationBloc()
            ..add(
              InitNotificationBlocEvent(),
            ),
        ),
      ],
      child: MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        builder: BotToastInit(),
        navigatorObservers: [
          BotToastNavigatorObserver(),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Online Learning App',
        theme: Provider.of<ThemeProvider>(context).currentTheme,
        initialRoute: SplashScreenPage.routeName,
        onGenerateRoute: AppRouter.generateRoute,
        routes: {
          SplashScreenPage.routeName: (_) => const SplashScreenPage(),
        },
      ),
    );
  }
}
