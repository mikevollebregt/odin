import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/notifiers/responsive_ui.dart';
import '../../../../infrastructure/repositories/dtos/classified_period_dto.dart';
import '../../../../infrastructure/repositories/dtos/movement_dto.dart';
import '../../../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../../../providers.dart';
import '../../../widgets/map_widget.dart';

class MovementsAndStopsMap extends ConsumerWidget {
  const MovementsAndStopsMap();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
    return StreamBuilder(
      stream: dayOverviewNotifier.streamClassifiedPeriodDtos(),
      builder: (_, AsyncSnapshot<List<ClassifiedPeriodDto>> snapshot) {
        if (snapshot.hasData == false) return SizedBox(height: 200 * y);
        final dtos = snapshot.data!;
        final stopDtos = <StopDto>[];
        final movementDtos = <MovementDto>[];
        for (final dto in dtos) {
          if (dto is MovementDto) movementDtos.add(dto);
          if (dto is StopDto) stopDtos.add(dto);
        }
        return MapWidget(stopDtos, movementDtos);
      },
    );
  }
}
