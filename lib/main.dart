import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mp3_convert/base_presentation/theme/theme.dart';
import 'package:mp3_convert/firebase/firebase_options.dart';
import 'package:mp3_convert/internet_connect/socket/socket.dart';
import 'package:mp3_convert/util/app_life_cycle_mixin.dart';
import 'package:mp3_convert/util/navigator/app_navigator.dart';
import 'package:mp3_convert/util/navigator/app_page.dart';

import 'main_setting/app_setting.dart';

final ConvertChannel socketChannel = ConvertChannel("https://syt.cdndl.xyz");

class AppLocale {
  final List<Locale> supportedLocales = [
    const Locale('en', 'US'),
    const Locale('vi', 'VN'),
  ];

  Locale get defaultLocale => supportedLocales.first;

  String get path => 'assets/translations';
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await AppSetting().initApp();

  final AppLocale appLocale = AppLocale();

  runApp(
    EasyLocalization(
      supportedLocales: appLocale.supportedLocales,
      startLocale: appLocale.defaultLocale,
      fallbackLocale: appLocale.defaultLocale,
      path: appLocale.path,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme.initFromRootContext(context);
    return ListenableBuilder(
      listenable: AppTheme.instance,
      builder: (context, _) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: AppTheme.instance.mode,
          theme: ThemeData.dark(),
          // theme: ThemeData(
          //   useMaterial3: true,
          // ),
          // darkTheme: ThemeData(
          //   useMaterial3: true,
          // ),
          home: GetHomePage().getPage(null),
          navigatorKey: AppNavigator.navigatorKey,
          navigatorObservers: [
            AppLifeCycleMixin.routeObserver,
          ],
        );
      },
    );
  }
}
