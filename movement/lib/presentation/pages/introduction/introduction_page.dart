import 'dart:io';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart' as BackAcc;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/presentation/pages/introduction/battery_manager_page.dart';
import 'package:questionnaire/questionnaire.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../color_pallet.dart';
import '../../../infrastructure/notifiers/responsive_ui.dart';
import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../infrastructure/services/ios_service.dart';
import '../../../infrastructure/services/localization_service.dart';
import '../../../providers.dart';
import '../../../text_style.dart';
import '../../questionnaire/questionnaire_mixin.dart';
import '../../routing/routes.dart';
import 'questions_introduction_page.dart';
import 'welcome_introduction_page.dart';

class DotIndicator {
  int? index;
  bool? value;
  Widget? widget;

  DotIndicator({this.index, this.value, this.widget});
}

class IntroductionPage extends ConsumerStatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends ConsumerState<IntroductionPage>
    with CreateQuestionnaireMixin, OnQuestionnaireMixin {
  final List<Widget> _pages = <Widget>[
    WelcomeIntroductionPage(),
    if (Platform.isAndroid) BatteryManagerPage(),
    QuestionsIntroductionPage(),
  ];

  final _pageController = PageController();

  double? currentPage = 0;
  int selectedIndex = 0;

  // ignore: unused_element
  Widget _dotIndicator(int index, bool isActive) {
    return Listener(
      onPointerDown: (event) {
        setState(() {
          _pageController.jumpToPage(index);
          selectedIndex = index;
        });
      },
      child: SizedBox(
        height: 15 * y,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.symmetric(horizontal: 4 * x),
          height: (isActive ? 15 : 10) * y,
          width: (isActive ? 15 : 10) * x,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ColorPallet.primaryColor),
            color: isActive ? ColorPallet.primaryColor : Colors.white,
          ),
        ),
      ),
    );
  }

  Future _requestNotificationPermission() async {
    final notifier = ref.watch(introNotificationNotifierProvider);
    await notifier.configureLocalNotifcations();
  }

  Future _requestLocationPermission() async {
    final notifier = ref.watch(introLocationNotifierProvider);
    await notifier.askLocationPermission();

    if (Platform.isIOS) {
      final data = <String, int>{'countInit': 1};

      await BackgroundLocator.registerLocationUpdate(
        CallbackHandler.iosCallback,
        initDataCallback: data,
        initCallback: CallbackHandler.init,
        iosSettings: const IOSSettings(showsBackgroundLocationIndicator: true),
      );

      await BackgroundLocator.isServiceRunning();
    } else if (Platform.isAndroid) {
      await ref.read(foregroundServiceProvider).startForegroundService();
    }

    await notifier.checkPermission();
  }

  Future _requestBatteryManagementPermission() async {
    final notifier = ref.watch(introBatteryNotifierProvider);
    await notifier.disableBatteryOptimization();
  }

  Future<void> _goToQuestionnaireScreen() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => StartQuestionnairePage(
          questionList: questionList,
          colorMap: colorList,
          textMap: textList,
          delegate: this,
          storedAnswers: const <int, QuestionResultBase>{},
        ),
      ),
    );
  }

  Future<void> _goToMenu() async {
    final prefs = await SharedPreferences.getInstance();
    final startQuestionnaire = prefs.getBool('questionnaire') ?? false;

    if (!startQuestionnaire) {
      log('Questionnaire::build', '', LogType.Flow);
      createQuestionnaire();
      await prefs.setBool('questionnaire', true);
      await _goToQuestionnaireScreen();
    } else {
      Routes.RouteToPage('menuWidget', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    log('IntroductionPage::build', 'selectedPageIndex: $selectedIndex', LogType.Flow);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 13 * x, top: 37 * y, right: 13 * x, bottom: 64 * y),
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              pageSnapping: false,
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (int page) {
                setState(() {
                  selectedIndex = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return _pages[index];
              },
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final locationNotifier = ref.watch(introLocationNotifierProvider);

              final batteryNotifier = ref.watch(introBatteryNotifierProvider);
              return Positioned(
                bottom: 10 * y,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25 * x, right: 25 * x),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (selectedIndex == 0)
                                TextButton(
                                  onPressed: () async {
                                    log('IntroductionPage::nextButton', 'selectedPageIndex: $selectedIndex',
                                        LogType.Flow);
                                    await _requestLocationPermission();
                                    await _requestBatteryManagementPermission();
                                    await _goToMenu();
                                  },
                                  child: Text(AppLocalizations.of(context).translate('introductionpage_skip'),
                                      style: textStyleAkko16Blue),
                                )
                              else if (selectedIndex == 1 && Platform.isAndroid)
                                TextButton(
                                  onPressed: () async {
                                    log('IntroductionPage::nextButton', 'selectedPageIndex: $selectedIndex',
                                        LogType.Flow);
                                    await _requestBatteryManagementPermission();
                                    await _goToMenu();
                                  },
                                  child: Text(AppLocalizations.of(context).translate('introductionpage_skip'),
                                      style: textStyleAkko16Blue),
                                )
                              else
                                TextButton(
                                  onPressed: () async {
                                    log('IntroductionPage::skipButton', '', LogType.Flow);
                                    await _goToMenu();
                                  },
                                  child: Text(AppLocalizations.of(context).translate('introductionpage_skip'),
                                      style: textStyleAkko16Blue),
                                )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                for (var idx = 0; idx < _pages.length; idx++)
                                  Listener(
                                    child: Consumer(builder: (context, ref, child) {
                                      if (!locationNotifier.isPressed && selectedIndex == 0) {
                                        return SizedBox(
                                          height: 15 * y,
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 150),
                                            margin: EdgeInsets.symmetric(horizontal: 4 * x),
                                            height: (idx == selectedIndex ? 15 : 10) * y,
                                            width: (idx == selectedIndex ? 15 : 10) * x,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: ColorPallet.midGray),
                                              color: idx == selectedIndex ? ColorPallet.midGray : Colors.white,
                                            ),
                                          ),
                                        );
                                        // } else if (!notificationNotifier.isPressed && selectedIndex == 1) {
                                        //   return SizedBox(
                                        //     height: 15,
                                        //     child: AnimatedContainer(
                                        //       duration: const Duration(milliseconds: 150),
                                        //       margin: const EdgeInsets.symmetric(horizontal: 4),
                                        //       height: idx == selectedIndex ? 15 : 10,
                                        //       width: idx == selectedIndex ? 15 : 10,
                                        //       decoration: BoxDecoration(
                                        //         shape: BoxShape.circle,
                                        //         border: Border.all(color: ColorPallet.midGray),
                                        //         color: idx == selectedIndex ? ColorPallet.midGray : Colors.white,
                                        //       ),
                                        //     ),
                                        //   );
                                      } else if (!batteryNotifier.isPressed &&
                                          selectedIndex == 1 &&
                                          Platform.isAndroid) {
                                        return SizedBox(
                                          height: 15 * y,
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 150),
                                            margin: EdgeInsets.symmetric(horizontal: 4 * x),
                                            height: (idx == selectedIndex ? 15 : 10) * y,
                                            width: (idx == selectedIndex ? 15 : 10) * x,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: ColorPallet.midGray),
                                              color: idx == selectedIndex ? ColorPallet.midGray : Colors.white,
                                            ),
                                          ),
                                        );
                                        // } else if (!notificationNotifier.isPressed && selectedIndex == 1) {
                                        //   return SizedBox(
                                        //     height: 15,
                                        //     child: AnimatedContainer(
                                        //       duration: const Duration(milliseconds: 150),
                                        //       margin: const EdgeInsets.symmetric(horizontal: 4),
                                        //       height: idx == selectedIndex ? 15 : 10,
                                        //       width: idx == selectedIndex ? 15 : 10,
                                        //       decoration: BoxDecoration(
                                        //         shape: BoxShape.circle,
                                        //         border: Border.all(color: ColorPallet.midGray),
                                        //         color: idx == selectedIndex ? ColorPallet.midGray : Colors.white,
                                        //       ),
                                        //     ),
                                        //   );
                                      } else {
                                        return SizedBox(
                                          height: 15 * y,
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 150),
                                            margin: EdgeInsets.symmetric(horizontal: 4 * x),
                                            height: (idx == selectedIndex ? 15 : 10) * y,
                                            width: (idx == selectedIndex ? 15 : 10) * x,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: ColorPallet.primaryColor),
                                              color: idx == selectedIndex ? ColorPallet.primaryColor : Colors.white,
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                                  )
                              ])
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!locationNotifier.isPressed && selectedIndex == 0)
                                TextButton(
                                  onPressed: () async {},
                                  child: Text(AppLocalizations.of(context).translate('introductionpage_next'),
                                      style: textStyleAkko16Grey),
                                )
                              // else if (!notificationNotifier.isPressed && selectedIndex == 1)
                              //   TextButton(
                              //     onPressed: () async {},
                              //     child: Text(AppLocalizations.of(context).translate('introductionpage_next'), style: textStyleAkko16Grey),
                              //   )
                              else if (!batteryNotifier.isPressed && selectedIndex == 1 && Platform.isAndroid)
                                TextButton(
                                  onPressed: () async {},
                                  child: Text(AppLocalizations.of(context).translate('introductionpage_next'),
                                      style: textStyleAkko16Grey),
                                )
                              else
                                TextButton(
                                  onPressed: () async {
                                    log('IntroductionPage::nextButton', 'selectedPageIndex: $selectedIndex',
                                        LogType.Flow);
                                    selectedIndex != _pages.length - 1
                                        ? await _pageController.nextPage(
                                            duration: const Duration(milliseconds: 300), curve: Curves.easeIn)
                                        : await _goToMenu();
                                  },
                                  child: selectedIndex == _pages.length - 1
                                      ? Text(AppLocalizations.of(context).translate('introductionpage_start'),
                                          style: textStyleAkko24Blue)
                                      : Text(AppLocalizations.of(context).translate('introductionpage_next'),
                                          style: textStyleAkko16Blue),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void onQuestionComplete(QuestionResultBase answer) {
    log('Questionnaire::onQuestionComplete', 'val: $answer', LogType.Flow);
  }

  @override
  Future<void> onQuestionnaireComplete(Map<int, QuestionResultBase> answers) async {
    log('Questionnaire::onQuestionnaireComplete', 'val: $answers', LogType.Flow);
    _goToMenu();
    await ref.read(questionnaireRepository).submitQuestionnaire(answers.toString());
  }
}
