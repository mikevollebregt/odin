import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../infrastructure/repositories/log_repository.dart';
import '../../providers.dart';
import '../pages/calendar_page_adapter.dart';

class WeekCompletedWidget extends ConsumerWidget {
  final Widget child;

  const WeekCompletedWidget({Key? key, required this.child}) : super(key: key);

  Future<void> showCompletedDialog(BuildContext context, WidgetRef ref) async {
    final calendarPageNotifier = ref.watch(calendarPageNotifierProvider);
    final isWeekCompleted = await calendarPageNotifier.isWeekCompleted();
    if (isWeekCompleted && calendarPageNotifier.hasDisplayedFinale == false) {
      await weekCompletedDialog(context, ref);
      calendarPageNotifier.hasDisplayedFinale = true;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('WeekCompletedWidget::build', '', LogType.Flow);

    return Stack(children: [child, _buildCompletedWeekWidget(context, ref)]);
  }

  Widget _buildCompletedWeekWidget(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      showCompletedDialog(context, ref);

      return Container();
    });
  }
}
