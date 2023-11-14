import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../app_fonts.dart';
import '../../../infrastructure/notifiers/movement_notifier.dart';
import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/dtos/movement_dto.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../infrastructure/services/localization_service.dart';
import '../../../providers.dart';
import '../../widgets/map_widget.dart';
import '../../widgets/time_display_widget.dart';
import 'widgets/confirm_button_widget.dart';
import 'widgets/delete_button_widget.dart';
import 'widgets/vehicle_form.dart';

class MovementDetailsPage extends ConsumerWidget {
  final MovementDto _movementDto;

  const MovementDetailsPage(this._movementDto);

  void closeAndCancel(BuildContext context, MovementNotifier movementNotifier) {
    // TODO: Add warning dialog here
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('MovementDetailsPage::build', '', LogType.Flow);
    final movementNotifier = ref.watch(movementNotifierProvider(_movementDto));
    final movementDto = movementNotifier.movementDto;

    return WillPopScope(
      onWillPop: () async {
        closeAndCancel(context, movementNotifier);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(AppLocalizations.of(context).translate('movementdetailspage_title')),
          centerTitle: true,
          actions: [ConfirmButtonWidget(movementDto)],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                MapWidget(const [], [movementDto]),
                SizedBox(height: 10 * y),
                TimeDisplayWidget(movementNotifier),
                SizedBox(height: 30 * y),
                Text(AppLocalizations.of(context).translate('movementdetailspage_whichmovement'), style: AppFonts.xxlBoldSohoPro, textAlign: TextAlign.center),
                VehicleForm(movementDto),
              ],
            ),
            Positioned(bottom: 30 * y, right: 30 * x, child: DeleteButton(movementDto)),
          ],
        ),
      ),
    );
  }
}
