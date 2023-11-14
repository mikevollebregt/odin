import 'package:calendar_page/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../../color_pallet.dart';
import '../../../../providers.dart';

class ProgressBar extends ConsumerWidget {
  const ProgressBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);

    return StreamBuilder(
        stream: dayOverviewNotifier.streamCalendarPageDayData(dayOverviewNotifier.day),
        builder: (context, AsyncSnapshot<CalendarPageDayData> snapshot) {
          if (snapshot.hasData == false) return const SizedBox();
          final percentageValidated = snapshot.data!.validated! / 86400.0;
          final percentageUnvalidated = snapshot.data!.unvalidated! / 86400.0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0 * x),
            child: Column(
              children: [
                SizedBox(height: 10 * y),
                Container(
                  height: MediaQuery.of(context).size.height * 0.02,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(color: ColorPallet.veryDarkGray, borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                      Container(
                        width:
                            (MediaQuery.of(context).size.width * 0.9 * percentageValidated) + (MediaQuery.of(context).size.width * 0.9 * percentageUnvalidated),
                        decoration: const BoxDecoration(color: ColorPallet.orange, borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9 * percentageValidated,
                        decoration: const BoxDecoration(color: ColorPallet.lightGreen, borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10 * y),
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: 12 * x,
                        height: 12 * y,
                        margin: EdgeInsets.only(right: 8 * x),
                        decoration: const BoxDecoration(color: ColorPallet.lightGreen, borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                      Text('Ingevoerd', style: Theme.of(context).primaryTextTheme.bodyText1),
                      Container(
                        width: 12 * x,
                        height: 12 * y,
                        margin: EdgeInsets.only(right: 8 * x, left: 15 * x),
                        decoration: const BoxDecoration(color: ColorPallet.orange, borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                      Text('Ontbrekend', style: Theme.of(context).primaryTextTheme.bodyText1)
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        });
  }
}
