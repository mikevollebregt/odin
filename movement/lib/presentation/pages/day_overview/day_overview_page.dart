import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';
import 'package:movement/presentation/pages/day_overview/widgets/no_data_tile.dart';
import 'package:movement/presentation/pages/day_overview/widgets/onboarding_dialog_widget.dart';

import '../../../color_pallet.dart';
import '../../../infrastructure/repositories/dtos/classified_period_dto.dart';
import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/dtos/movement_dto.dart';
import '../../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../providers.dart';
import 'widgets/fancy_fab.dart';
import 'widgets/header_widget.dart';
import 'widgets/missing_tile.dart';
import 'widgets/movement_tile_widget.dart';
import 'widgets/movements_and_stops_map.dart';
import 'widgets/progress_bar_widget.dart';
import 'widgets/stop_tile_widget.dart';

class DayOverviewPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('DayOverviewPage::build', '', LogType.Flow);
    final notifier = ref.watch(dayOverviewNotifierProvider);
    final versionNotifier = ref.watch(versionNotifierProvider);
    return Scaffold(
        floatingActionButton: versionNotifier.isInteractionAllowed()
            ? notifier.hasDisplayedOnboarding
                ? const FancyFab()
                : Container()
            : null,
        body: Stack(children: [
          Column(
            children: [
              HeaderWidget(),
              MovementsAndStopsMap(),
              ProgressBar(),
              SizedBox(height: 10 * y),
              ClassifiedPeriodList(),
            ],
          ),
          notifier.hasDisplayedOnboarding ? Container() : OnboardingDialogWidget()
        ]));
  }
}

class ClassifiedPeriodList extends ConsumerWidget {
  const ClassifiedPeriodList();

  Widget _addMissingPeriod(Widget widget, ClassifiedPeriodDto current, ClassifiedPeriodDto? next) {
    if (next == null) return widget;
    final startDate = current.classifiedPeriod.endDate;
    final endDate = next.classifiedPeriod.startDate;
    if (endDate.difference(startDate).inMinutes <= 5) return widget;
    return Column(children: [widget, MissingTile(startDate, endDate)]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
    return StreamBuilder<List<ClassifiedPeriodDto>>(
      stream: dayOverviewNotifier.streamClassifiedPeriodDtos(),
      builder: (_, AsyncSnapshot<List<ClassifiedPeriodDto>> snapshot) {
        if (snapshot.hasData == false)
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Laden..', style: TextStyle(color: ColorPallet.grayTextColor),)
          );
        if (snapshot.data!.isEmpty) return NoDataTile();
        final dtos = snapshot.data!;
        return Expanded(
          child: ListView.builder(
            itemCount: dtos.length,
            itemBuilder: (context, index) {
              final dto = dtos[index];
              final next = dtos.length > index + 1 ? dtos[index + 1] : null;
              if (dto is StopDto) return _addMissingPeriod(StopTile(dto, index == dtos.length - 1), dto, next);
              if (dto is MovementDto) return _addMissingPeriod(MovementTile(dto, index == dtos.length - 1), dto, next);
              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
