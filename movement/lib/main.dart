import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/presentation/weekCompleted/week_completed_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'https_certificate_workaround.dart';
import 'infrastructure/notifiers/generic_notifier.dart';
import 'infrastructure/notifiers/loading_notifier.dart';
import 'infrastructure/notifiers/responsive_ui.dart';
import 'infrastructure/services/device_service.dart';
import 'infrastructure/services/ios_service.dart';
import 'infrastructure/services/localization_service.dart';
import 'presentation/menu/menu_widget.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/theme/theme_widget.dart';
import 'presentation/widgets/app_retain_widget.dart';
import 'providers.dart';

final container = ProviderContainer();

@pragma('vm:entry-point')
Future<void> main() async {
  await initConfig();
  if (Platform.isIOS) {
    final port = ReceivePort();
    if (IsolateNameServer.lookupPortByName(CallbackHandler.isolateName) != null) {
      IsolateNameServer.removePortNameMapping(CallbackHandler.isolateName);
    }

    IsolateNameServer.registerPortWithName(port.sendPort, CallbackHandler.isolateName);

    final prefs = await SharedPreferences.getInstance();
    final shouldActivateBackgroundLocator = prefs.getBool('weekCompleted') ?? true;
    if (shouldActivateBackgroundLocator) {
      await BackgroundLocator.initialize();
    }
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(),
    ),
  );
}

Future<void> initConfig() async {
  WidgetsFlutterBinding.ensureInitialized();
  enableUnverifiedHttpsCertificate();

  final prefs = await SharedPreferences.getInstance();

  final startIntroduction = prefs.getBool('introduction');
  if (startIntroduction == null) {
    await prefs.setBool('introduction', true);
  }

  // final startQuestionnaire = prefs.getBool('questionnaire');
  // if (startQuestionnaire == null) {
  //   await prefs.setBool('questionnaire', true);
  // }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final notifier = StateNotifierProvider((ref) => LoadingNotifier(ref.watch(database)));

  void fixLocationService() async {
    final isProblemWithLocationService = await container.read(supportNotifierProvider).isProblemWithLocationService();
    if (isProblemWithLocationService) {
      if (mounted) {
        if (container.read(calendarPageNotifierProvider.notifier).isWeekCompleted() == false) {
          await container.read(supportNotifierProvider).restartLocationService();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // fixLocationService();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // fixLocationService();
      container.read(syncNotifierProvider).sync();
      DeviceService().addSensorLocation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', ''),
        Locale('nl', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      locale: const Locale('nl'),
      home: Builder(builder: (context) {
        initialiseResponsiveUI(context);

        return WeekCompletedWidget(child: ThemeWidget(
          child: AppRetainWidget(
            child: Consumer(builder: (context, ref, child) {
              final state = ref.watch(notifier);
              final calendarNotifier = ref.watch(calendarPageNotifierProvider.notifier);
              if (state is Loaded<bool>) {
                if (state.loadedObject) {
                  if (Platform.isIOS) {
                    if (!calendarNotifier.isWeekCompleted()) {
                      CallbackHandler.startIOSService();
                    } else {
                      CallbackHandler.stopIOSService();
                    }
                  } else if (Platform.isAndroid) {
                    if (calendarNotifier.isWeekCompleted()) {
                      final calendarPageNotifier = ref.watch(calendarPageNotifierProvider);
                      calendarPageNotifier.disableForegroundService();
                    }
                  }

                  return MenuWidget();
                } else {
                  return LoginPage();
                }
              } else {
                return Container(
                  color: Colors.white,
                );
              }
            }),
          ),
        ));
      }),
    );
  }
}
