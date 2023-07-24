import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/database/local_database.dart';
import 'package:online_learning_app/pages/uncategorized_pages/splash_screen_page/splash_screen_page.dart';
import 'package:online_learning_app/repositories/auth_repository.dart';
import 'package:online_learning_app/resources/app_locale.dart';
import 'package:online_learning_app/resources/app_themes.dart';
import 'package:online_learning_app/routes/app_router.dart';
import 'package:online_learning_app/widgets/uncategorized/system_overlay.dart';

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
      await EasyLocalization.ensureInitialized();
      await LocalDB.instance.ensureInitialized();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      runApp(
        EasyLocalization(
          path: AppLocale.path,
          supportedLocales: AppLocale.supportedLocales,
          fallbackLocale: AppLocale.fallbackLocale,
          child: const _App(),
        ),
      );
      EasyLocalization.logger.enableBuildModes = [];

    },
    _errorHandler,
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  static final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => _authRepository,
        ),
      ],
      child: SystemOverlay(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
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
          // title: context.read<AuthRepository>().toString(),
          theme: AppThemes.light(),
          // theme: AppThemes.dark(),
          initialRoute: SplashScreenPage.routeName,
          onGenerateRoute: AppRouter.generateRoute,
          routes: {
            SplashScreenPage.routeName: (_) => const SplashScreenPage(),
          },
        ),
      ),
    );
  }
}
