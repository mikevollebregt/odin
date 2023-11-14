import 'dart:async';
import 'dart:io';

import 'package:calendar_page/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../infrastructure/repositories/log_repository.dart';
import '../../infrastructure/services/ios_service.dart';
import '../../infrastructure/services/localization_service.dart';
import '../../providers.dart';
import '../../text_style.dart';
import '../animations/confetti_animation.dart';

class CalendarPageAdapter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuNotifier = ref.watch(menuNotifierProvider);
    final calendarPageNotifier = ref.watch(calendarPageNotifierProvider);
    final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
    if (calendarPageNotifier.calendarPageDayDataList.isEmpty) return const SizedBox();

    return CalendarPage(
        calendarData: calendarPageNotifier.calendarPageDayDataList,
        onDatePressed: (DateTime dateTime) async {
          if (await calendarPageNotifier.isInTrackedDays(dateTime)) {
            unawaited(log('MenuWidget::onDatePressed', dateTime.toString(), LogType.Flow));
            dayOverviewNotifier.day = dateTime;
            unawaited(menuNotifier.setPage(1));
          } else {
            unawaited(Fluttertoast.showToast(
              msg: AppLocalizations.of(context).translate('calendarpage_toastwarning'),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            ));
          }
        });
  }
}

// TODO: check if deletable
Future<void> weekCompletedDialog(BuildContext context, WidgetRef ref) async {
  await log('weekCompletedDialog::build', '', LogType.Flow);

  final prefs = await SharedPreferences.getInstance();
  final hasFinished = prefs.getBool('weekCompleted') ?? false;
  if (!hasFinished) {
    prefs.setBool('weekCompleted', true);
  } else {
    return;
  }

  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return Stack(
          children: [
            Dialog(
              insetPadding: EdgeInsets.only(left: 20 * x, right: 20 * x, bottom: 20 * y),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20 * x),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20 * y),
                        child: Center(
                            child: SvgPicture.asset(
                          'assets/images/congratz.svg',
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15 * y),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 30 * y),
                                      child: Text(
                                        AppLocalizations.of(context).translate('completeweek_dialogue_title'),
                                        style: textStyleSoho24Black,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(width: 10 * x),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15 * y),
                        child: Text(
                          AppLocalizations.of(context).translate('completeweek_dialogue_text'),
                          style: textStyleAkko16Grey,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        child: Text(AppLocalizations.of(context).translate('completeweek_dialogue_cancel'), style: textStyleAkko16Blue),
                        onPressed: () {
                          if (Platform.isIOS) {
                            CallbackHandler.stopIOSService();
                          } else if (Platform.isAndroid) {
                            final calendarPageNotifier = ref.watch(calendarPageNotifierProvider);
                            calendarPageNotifier.disableForegroundService();
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const ConfettiAnimation(),
          ],
        );
      });
    },
  );
}
