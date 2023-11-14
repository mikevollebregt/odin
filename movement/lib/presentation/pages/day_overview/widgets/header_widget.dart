import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';
import 'package:movement/presentation/pages/day_comment_mixin.dart';
import 'package:movement/presentation/pages/day_overview/widgets/onboarding_dialog.dart';

import '../../../../color_pallet.dart';
import '../../../../main.dart';
import '../../../../providers.dart';
import '../../../animations/animation_stopped_mixin.dart';
import '../../../locale/dutch_date_locale.dart';
import '../../day_comment_dialog.dart';

class HeaderWidget extends ConsumerWidget with DayCommentMixin, AnimationStoppedMixin {
  const HeaderWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
    final isTapped = dayOverviewNotifier.isDeleteMode;
    final allowedToPress = dayOverviewNotifier.isLaterDate(dayOverviewNotifier.day);

    return Container(
      height: 70 * y,
      width: MediaQuery.of(context).size.width,
      color: ColorPallet.primaryColor,
      child: Stack(
        children: [
          Positioned(
            left: 20 * x,
            top: 20 * y,
            child: IconButton(
              padding: EdgeInsets.all(0),
              alignment: Alignment.topLeft,
              onPressed: () {
                showOnboardingDialog(context, ref);
              },
              icon: Icon(
                Icons.info,
                color: Colors.white,
                size: 30 * f,
              ),
            ),
          ),
          Center(
            child: Text(
              formatDate(
                dayOverviewNotifier.day,
                [dd, ' ', MM],
                locale: const DutchDateLocale(),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 22 * f,
              ),
            ),
          ),
          Positioned(
              right: 20 * x,
              top: 20 * y,
              child: isTapped
                  ? GestureDetector(
                      onTap: () {
                        dayOverviewNotifier.removeClassifiedPeriods();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30 * f,
                      ),
                    )
                  : allowedToPress
                      ? GestureDetector(
                          onTap: () async {
                            container.read(syncNotifierProvider).sync(iterations: 5);
                            dayCommentDialog(context, this, ref, this);
                          },
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30 * f,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                              msg: 'U kunt de dag morgen pas afronden.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          },
                          child: Icon(
                            Icons.check,
                            color: Colors.white.withOpacity(0.6),
                            size: 30 * f,
                          ),
                        )),
        ],
      ),
    );
  }

  @override
  void onDayComment(BuildContext context, String text, int choice, WidgetRef ref) {
    final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
    dayOverviewNotifier.confirmDayAsync(text, choice, dayOverviewNotifier.day);
  }

  @override
  void onAnimationEnded(BuildContext context, WidgetRef ref) {
    final menuNotifier = ref.watch(menuNotifierProvider);
    final calendarNotifier = ref.watch(calendarPageNotifierProvider.notifier);
    Navigator.of(context).pop();
    calendarNotifier.loadCalendarPageDayDataList();
    menuNotifier.setPage(0);
  }
}
