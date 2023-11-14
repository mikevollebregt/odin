import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../color_pallet.dart';
import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../infrastructure/services/localization_service.dart';
import '../../../providers.dart';
import '../../../text_style.dart';
import '../../widgets/elevated_button.dart';

class BatteryManagerPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('BatteryManagerPage::build', '', LogType.Flow);
    return Padding(
      padding: EdgeInsets.only(left: 25 * x, top: 20 * y, right: 25 * x),
      child: Column(
        children: [
          Row(
            children: [
              Text(AppLocalizations.of(context).translate('welcomeintroductionpage_title'), style: textStyleSoho24Black)
            ],
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: SvgPicture.asset('assets/images/5.svg'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  AppLocalizations.of(context).translate('batterymanagementintroduction_title'),
                  style: textStyleSoho20Black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('batterymanagementintroduction_helptext1'),
                      style: textStyleAkko16Black,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('batterymanagementintroduction_helptext2'),
                      style: textStyleAkko16Black,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final notifier = ref.watch(introBatteryNotifierProvider);

                        if (!notifier.isPressed) {
                          return ElevatedButtonWidget(
                            buttonText:
                                AppLocalizations.of(context).translate('introductionpage_batterymanagementbutton'),
                            screenWidth: MediaQuery.of(context).size.width,
                            buttonColor: ColorPallet.primaryColor,
                            onPressed: () async {
                              log('BatteryManagerPage::PermissionButton', '', LogType.Flow);
                              await notifier.disableBatteryOptimization();
                            },
                          );
                        } else {
                          if (notifier.isGranted) {
                            return ElevatedButtonWidget(
                              buttonText: AppLocalizations.of(context)
                                  .translate('introductionpage_batterymanagementbuttonsuccess'),
                              screenWidth: MediaQuery.of(context).size.width,
                              buttonColor: ColorPallet.lightGreen,
                              onPressed: () async {
                                var response = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
                                print(response);
                              },
                            );
                          } else {
                            return ElevatedButtonWidget(
                              buttonText: AppLocalizations.of(context)
                                  .translate('introductionpage_batterymanagementbuttonfailed'),
                              screenWidth: MediaQuery.of(context).size.width,
                              buttonColor: ColorPallet.midGray,
                              onPressed: () async {
                                notifier.disableBatteryOptimization();
                              },
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
