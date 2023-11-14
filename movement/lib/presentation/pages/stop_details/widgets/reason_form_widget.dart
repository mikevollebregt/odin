import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../../app_fonts.dart';
import '../../../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../../../infrastructure/services/localization_service.dart';
import '../../../routing/routes.dart';
import '../../../theme/icon_mapper.dart';

class ReasonForm extends ConsumerWidget {
  final StopDto stopDto;
  const ReasonForm(this.stopDto);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => Routes.RouteToPage('stopReasonPage', context, ref: ref, stopDto: stopDto),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(51, 66, 91, 0.15), width: 2 * x), borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            if (stopDto.reason?.icon == null)
              Container(margin: EdgeInsets.only(left: 5 * x))
            else
              Container(margin: EdgeInsets.only(left: 15 * x), child: FaIconMapper.getFaIcon(stopDto.reason?.icon)),
            Container(
              margin: EdgeInsets.only(left: 15 * x),
              width: MediaQuery.of(context).size.width * 0.58,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0 * y),
                child: Text(
                  stopDto.reason?.name ?? AppLocalizations.of(context).translate('locationdetailspage_noreason'),
                  style: stopDto.reason?.name == null ? AppFonts.grayedOutNormalText : TextStyle(fontSize: 14 * f),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 15 * f,
            )
          ],
        ),
      ),
    );
  }
}
