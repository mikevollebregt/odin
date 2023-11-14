import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movement/providers.dart';

import '../../../../app_fonts.dart';
import '../../../../infrastructure/notifiers/responsive_ui.dart';
import '../../../../infrastructure/repositories/dtos/movement_dto.dart';
import '../../../../infrastructure/services/localization_service.dart';
import '../../../routing/routes.dart';

class VehicleForm extends ConsumerWidget {
  final MovementDto movementDto;
  const VehicleForm(this.movementDto);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionNotifier = ref.watch(versionNotifierProvider);

    return Column(
      children: [
        InkWell(
          onTap: () => Routes.RouteToPage('movementVehiclePage', context, ref: ref, movementDto: movementDto),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(51, 66, 91, 0.15), width: 2 * x),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15 * x),
                  child: FaIcon(
                    FontAwesomeIcons.route,
                    color: Color(0xFF00A1CD),
                    size: 24 * f,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10 * x),
                  child: Text(
                    versionNotifier.isInteractionAllowed()
                        ? (movementDto.vehicle?.name ?? AppLocalizations.of(context).translate('movementdetailspage_nomovement'))
                        : (movementDto.vehicle?.name ?? AppLocalizations.of(context).translate('movementdetailspage_nomovement_nointeraction')),
                    style: movementDto.vehicle?.name == null ? AppFonts.grayedOutNormalText : const TextStyle(),
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
