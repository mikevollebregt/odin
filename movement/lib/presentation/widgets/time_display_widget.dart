import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';
import 'package:movement/infrastructure/repositories/database/database.dart';
import 'package:movement/providers.dart';

import '../../color_pallet.dart';
import '../../infrastructure/notifiers/classified_period_notifier.dart';
import '../../infrastructure/services/localization_service.dart';
import 'date_picker_widget/date_picker_widget.dart';

class TimeDisplayWidget extends ConsumerWidget {
  final ClassifiedPeriodNotifier classifiedPeriodNotifier;

  const TimeDisplayWidget(this.classifiedPeriodNotifier);

  void pickTime(BuildContext context, ClassifiedPeriod classifiedPeriod, bool startWithEndDate) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return DatePickerWidget(
          initialStartDate: classifiedPeriod.startDate,
          initialEndDate: classifiedPeriod.endDate,
          onComplete: (DateTime start, DateTime end) {
            classifiedPeriodNotifier.updateClassifiedPeriod(startDate: start, endDate: end);
          },
          startWithEndDate: startWithEndDate,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classifiedPeriod = classifiedPeriodNotifier.classifiedPeriodDto.classifiedPeriod;
    final versionNotifier = ref.watch(versionNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).translate('locationdetailspage_fromtime'),
          style: const TextStyle(color: ColorPallet.darkTextColor),
        ),
        InkWell(
          onTap: () => versionNotifier.isInteractionAllowed() ? pickTime(context, classifiedPeriod, false) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8 * x, vertical: 16 * y),
            child: Text(
              DateFormat('Hm').format(classifiedPeriod.startDate),
              style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 16 * f),
            ),
          ),
        ),
        Text(
          ' ${AppLocalizations.of(context).translate('locationdetailspage_totime')} ',
          style: const TextStyle(color: ColorPallet.darkTextColor),
        ),
        InkWell(
          onTap: () => versionNotifier.isInteractionAllowed() ? pickTime(context, classifiedPeriod, true) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8 * x, vertical: 16 * y),
            child: Text(
              DateFormat('Hm').format(classifiedPeriod.endDate),
              style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 16 * f),
            ),
          ),
        ),
      ],
    );
  }
}
