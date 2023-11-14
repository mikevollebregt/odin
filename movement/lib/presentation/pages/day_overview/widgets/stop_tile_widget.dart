import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../color_pallet.dart';
import '../../../../infrastructure/notifiers/responsive_ui.dart';
import '../../../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../../../infrastructure/services/localization_service.dart';
import '../../../../providers.dart';
import '../../../routing/routes.dart';
import '../../../theme/icon_mapper.dart';
import '../get_date_string.dart';

class StopTile extends ConsumerWidget {
  final StopDto stopDto;
  final bool isLastIndex;
  const StopTile(this.stopDto, this.isLastIndex);

  // TODO: refactor this (duplicated and should probably be done differently)
  String removeHouseNumber(String address) {
    if (address.contains(' ')) {
      return address.substring(0, address.lastIndexOf(' ') + 1);
    }
    return address;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
    final classifiedPeriod = stopDto.classifiedPeriod;
    final isTapped = dayOverviewNotifier.selectedIds.contains(classifiedPeriod.uuid);
    final isDeleteMode = dayOverviewNotifier.isDeleteMode;

    return Container(
      height: 90 * y,
      padding: EdgeInsets.only(left: 10 * x),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 4 * x,
                color: ColorPallet.lightGrayishBlue,
                margin: EdgeInsets.only(right: 10 * x, left: 2 * x),
              ),
              Positioned(
                left: 1 * x,
                top: 40 * y,
                child: Container(
                  height: 6 * y,
                  width: 6 * x,
                  decoration: BoxDecoration(
                    color: stopDto.classifiedPeriod.confirmed ? ColorPallet.lightGreen : ColorPallet.orange,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: isTapped && isDeleteMode ? Colors.black12 : Colors.transparent,
                child: InkWell(
                  child: Row(
                    children: [
                      Stack(children: <Widget>[
                        Container(
                          height: 80 * y,
                          width: 80 * x,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10 * y, right: 10 * x, left: 5 * x),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorPallet.veryDarkGray, width: 2 * x),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: FaIconMapper.getFaIcon(stopDto.reason?.icon),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            child: Icon(
                              Icons.check_circle,
                              size: 30 * f,
                              color: stopDto.classifiedPeriod.confirmed ? ColorPallet.lightGreen : ColorPallet.veryDarkGray,
                            ),
                          ),
                        ),
                      ]),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: EdgeInsets.only(left: 5 * x, bottom: 15 * y),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                                stopDto.googleMapsData?.name == null
                                    ? AppLocalizations.of(context).translate('movementpage_nolocation')
                                    : removeHouseNumber(stopDto.googleMapsData!.name!.split(',')[0]),
                                style: Theme.of(context).primaryTextTheme.headline1),
                            Text(getDateString(classifiedPeriod, isLastIndex), style: Theme.of(context).primaryTextTheme.bodyText1)
                          ])),
                      if (stopDto.classifiedPeriod.confirmed)
                        Container()
                      else
                        Padding(
                          padding: EdgeInsets.only(left: 20 * x),
                          child: Container(
                            height: 10 * y,
                            width: 10 * x,
                            decoration: BoxDecoration(
                              color: stopDto.classifiedPeriod.confirmed ? ColorPallet.lightGreen : ColorPallet.orange,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: 32 * x),
                    ],
                  ),
                  onTap: () {
                    if (dayOverviewNotifier.isDeleteMode) {
                      dayOverviewNotifier.addToSelected(stopDto.classifiedPeriod.uuid);
                    } else {
                      Routes.RouteToPage('stopDetailsPage', context, ref: ref, stopDto: stopDto);
                    }
                  },
                  onLongPress: () {
                    dayOverviewNotifier.setDeleteMode(stopDto.classifiedPeriod.uuid);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
