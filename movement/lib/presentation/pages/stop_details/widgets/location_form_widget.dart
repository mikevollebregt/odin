import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../../app_fonts.dart';
import '../../../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../../../infrastructure/services/localization_service.dart';
import '../../../routing/routes.dart';

class LocationForm extends ConsumerWidget {
  final StopDto stopDto;
  const LocationForm(this.stopDto);

  // TODO: refactor this (duplicated and should probably be done differently)
  String? removeHouseNumber(String? address) {
    if (address == null) return address;
    if (address.contains(' ')) {
      return address.substring(0, address.lastIndexOf(' ') + 1);
    }
    return address;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        InkWell(
          onTap: () => Routes.RouteToPage('locationSearchPage', context, ref: ref, stopDto: stopDto),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(51, 66, 91, 0.15), width: 2 * x),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15 * x),
                  child: FaIcon(
                    FontAwesomeIcons.locationDot,
                    color: Color(0xFF00A1CD),
                    size: 24 * f,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10 * x),
                  child: Text(
                    removeHouseNumber(stopDto.googleMapsData?.address) ?? AppLocalizations.of(context).translate('locationdetailspage_nolocation'),
                    style: stopDto.googleMapsData?.address == null ? AppFonts.grayedOutNormalText : const TextStyle(),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
