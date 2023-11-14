import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';
import 'package:movement/text_style.dart';

import '../../../app_fonts.dart';
import '../../../infrastructure/notifiers/stop_notifier.dart';
import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../infrastructure/services/localization_service.dart';
import '../../../providers.dart';
import '../../widgets/map_widget.dart';
import '../../widgets/time_display_widget.dart';
import 'widgets/confirm_button_widget.dart';
import 'widgets/delete_button_widget.dart';
import 'widgets/location_form_widget.dart';
import 'widgets/reason_form_widget.dart';

class StopDetailsPage extends ConsumerWidget {
  final StopDto _stopDto;

  const StopDetailsPage(this._stopDto);

  void closeAndCancel(BuildContext context, StopNotifier stopNotifier) {
    // TODO: Add warning dialog here
    Navigator.of(context).pop();
  }

     // TODO: refactor this (duplicated and should probably be done differently)
    String? removeHouseNumber(String? address) {
      if(address == null) return address;
    if (address.contains(' ')) {
      return address.substring(0, address.lastIndexOf(' ') + 1);
    }
    return address;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('StopDetailsPage::build', '', LogType.Flow);
    final stopNotifier = ref.watch(stopNotifierProvider(_stopDto));
    final stopDto = stopNotifier.stopDto;
    final versionNotifier = ref.watch(versionNotifierProvider);

    return WillPopScope(
      onWillPop: () async {
        closeAndCancel(context, stopNotifier);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(AppLocalizations.of(context).translate('locationdetailspage_title')),
          centerTitle: true,
          actions: [ConfirmButtonWidget(stopDto)],
          leading: InkWell(
            onTap: () => closeAndCancel(context, stopNotifier),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                MapWidget([stopDto], const []),
                TimeDisplayWidget(stopNotifier),
                SizedBox(height: 30 * y),
                versionNotifier.isInteractionAllowed()
                    ? Text(AppLocalizations.of(context).translate('locationdetailspage_whatlocation'), style: AppFonts.xxlBoldSohoPro)
                    : Text(AppLocalizations.of(context).translate('locationdetailspage_whatlocation_nointeraction'), style: AppFonts.xxlBoldSohoPro),
                versionNotifier.isInteractionAllowed()
                    ? LocationForm(stopDto)
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          removeHouseNumber(stopDto.googleMapsData?.address) ?? AppLocalizations.of(context).translate('locationdetailspage_nolocation'),
                          style: textStyleAkko16Dark,
                        ),
                      ),
                SizedBox(height: 30 * y),
                Text(AppLocalizations.of(context).translate('locationdetailspage_whylocation'), style: AppFonts.xxlBoldSohoPro),
                ReasonForm(stopDto),
                const Expanded(child: SizedBox()),
              ],
            ),
            Positioned(bottom: 30 * y, right: 30 * x, child: DeleteButton(stopDto)),
          ],
        ),
      ),
    );
  }
}
