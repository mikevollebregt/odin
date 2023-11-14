import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../../color_pallet.dart';
import '../../../../infrastructure/repositories/dtos/movement_dto.dart';
import '../../../../infrastructure/services/localization_service.dart';
import '../../../../providers.dart';
import '../../../routing/routes.dart';
import '../get_date_string.dart';

class MovementTile extends ConsumerWidget {
  final MovementDto movementDto;
  final bool isLastIndex;
  const MovementTile(this.movementDto, this.isLastIndex);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
    final classifiedPeriod = movementDto.classifiedPeriod;
    final isTapped = dayOverviewNotifier.selectedIds.contains(classifiedPeriod.uuid);
    final isDeleteMode = dayOverviewNotifier.isDeleteMode;

    return InkWell(
      child: Container(
        height: 90 * y,
        padding: EdgeInsets.only(left: 10 * x),
        color: isTapped && isDeleteMode ? Colors.black12 : Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 4 * x,
              color: ColorPallet.lightGrayishBlue,
              margin: EdgeInsets.only(right: 10 * x, left: 2 * x),
            ),
            Container(
              margin: EdgeInsets.only(right: 10 * x),
              color: Colors.white,
              child: Icon(
                Icons.check_circle,
                size: 25 * f,
                color: movementDto.classifiedPeriod.confirmed ? ColorPallet.lightGreen : ColorPallet.veryDarkGray,
              ),
            ),
            FaIcon(
              FontAwesomeIcons.route,
              color: Color(0xFF00A1CD),
            ),
            Container(
              margin: EdgeInsets.only(left: 10 * x),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movementDto.vehicle?.name == null ? AppLocalizations.of(context).translate('movementpage_unknown') : movementDto.vehicle!.name!,
                      style: Theme.of(context).primaryTextTheme.headline1),
                  Text(getDateString(classifiedPeriod, isLastIndex), style: Theme.of(context).primaryTextTheme.bodyText1)
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            if (movementDto.classifiedPeriod.confirmed)
              Container()
            else
              Container(
                height: 10 * y,
                width: 10 * x,
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: movementDto.classifiedPeriod.confirmed ? ColorPallet.lightGreen : ColorPallet.orange,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            SizedBox(width: 32 * x),
          ],
        ),
      ),
      onTap: () {
        if (dayOverviewNotifier.isDeleteMode) {
          dayOverviewNotifier.addToSelected(movementDto.classifiedPeriod.uuid);
        } else {
          Routes.RouteToPage('movementDetailsPage', context, ref: ref, movementDto: movementDto);
        }
      },
      onLongPress: () {
        dayOverviewNotifier.setDeleteMode(movementDto.classifiedPeriod.uuid);
      },
    );
  }
}
