import 'dart:io';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart' as BackAcc;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../color_pallet.dart';
import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../infrastructure/services/ios_service.dart';
import '../../../infrastructure/services/localization_service.dart';
import '../../../providers.dart';
import '../../../text_style.dart';
import '../../widgets/elevated_button.dart';

class WelcomeIntroductionPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('WelcomeIntroductionPage::build', '', LogType.Flow);
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
                  child: SvgPicture.asset('assets/images/2.svg'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  AppLocalizations.of(context).translate('welcomeintroductionpage_welcomemessage'),
                  style: textStyleSoho20Black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('welcomeintroductionpage_introtext1'),
                      style: textStyleAkko16Black,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('welcomeintroductionpage_introtext2'),
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
                        final notifier = ref.watch(introLocationNotifierProvider);

                        if (!notifier.isPressed) {
                          return ElevatedButtonWidget(
                            buttonText: AppLocalizations.of(context).translate('introductionpage_locationsharing'),
                            screenWidth: MediaQuery.of(context).size.width,
                            buttonColor: ColorPallet.primaryColor,
                            onPressed: () async {
                              log('WelcomeIntroductionPage::PermissionButton', '', LogType.Flow);
                              await notifier.askLocationPermission();

                              if (Platform.isIOS) {
                                final data = <String, int>{'countInit': 1};

                                await BackgroundLocator.registerLocationUpdate(
                                  CallbackHandler.iosCallback,
                                  initDataCallback: data,
                                  initCallback: CallbackHandler.init,
                                  iosSettings: const IOSSettings(showsBackgroundLocationIndicator: true),
                                );

                                await BackgroundLocator.isServiceRunning();
                              } else if (Platform.isAndroid) {
                                await ref.read(foregroundServiceProvider).startForegroundService();
                              }

                              await notifier.checkPermission();
                              await notifier.locationPermissionAlert(context, ref);
                            },
                          );
                        } else {
                          if (notifier.isGranted) {
                            return ElevatedButtonWidget(
                              buttonText:
                                  AppLocalizations.of(context).translate('introductionpage_locationsharingsucces'),
                              screenWidth: MediaQuery.of(context).size.width,
                              buttonColor: ColorPallet.lightGreen,
                              onPressed: () {},
                            );
                          } else {
                            return ElevatedButtonWidget(
                              buttonText:
                                  AppLocalizations.of(context).translate('introductionpage_locationsharingfailed'),
                              screenWidth: MediaQuery.of(context).size.width,
                              buttonColor: ColorPallet.midGray,
                              onPressed: () {},
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
