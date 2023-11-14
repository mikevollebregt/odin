import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/notifiers/generic_notifier.dart';
import '../../infrastructure/repositories/dtos/enums/app_theme.dart';
import '../../infrastructure/services/localization_service.dart';
import '../../providers.dart';
import 'themes.dart';

class ThemeWidget extends ConsumerWidget {
  final Widget child;

  const ThemeWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    if (themeNotifier is Initial) {
      return const CircularProgressIndicator();
    } else if (themeNotifier is Loading) {
      return const CircularProgressIndicator();
    } else if (themeNotifier is Loaded<AppTheme>) {
      return _buildWithTheme(context, themeNotifier.loadedObject);
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget _buildWithTheme(BuildContext context, AppTheme theme) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: appThemeData[theme]!.primaryColor,
    ));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: child,
        supportedLocales: const [
          Locale('en', ''),
          Locale('nl', ''),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: const Locale('nl'),
        theme: appThemeData[theme]);
  }
}
