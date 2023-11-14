import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../color_pallet.dart';
import '../../../../providers.dart';
import '../../../../text_style.dart';
import 'onboarding_dialog.dart';

class OnboardingDialogWidget extends ConsumerStatefulWidget {
  @override
  _OnboardingDialogWidgetState createState() => _OnboardingDialogWidgetState();
}

class _OnboardingDialogWidgetState extends ConsumerState<OnboardingDialogWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    List<OnboardingPage> onboardingText = [];
    final versionNotifier = super.ref.watch(versionNotifierProvider);
    if (versionNotifier.isInteractionAllowed()) {
      onboardingText = OnboardingTextLoader.getOnboardingVersionOne();
    } else {
      onboardingText = OnboardingTextLoader.getOnboardingVersionTwo();
    }

    int onboardingLength = onboardingText.length;

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  (index + 1).toString() + '/' + onboardingLength.toString(),
                  style: textStyleAkko12Dark,
                ),
                new Spacer(),
                IconButton(
                  alignment: Alignment.bottomRight,
                  icon: const FaIcon(
                    FontAwesomeIcons.xmark,
                    color: Color(0xFF979797),
                  ),
                  onPressed: () {
                    final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
                    dayOverviewNotifier.hasDisplayedOnboarding = true;
                    dayOverviewNotifier.setOnboarding(true);
                  },
                ),
              ],
            ),
            Container(
              height: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: onboardingText[index].getPageLayout(),
            ),
            new Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                index > 0
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            index--;
                          });
                        },
                        child: Text(
                          "Vorige",
                          style: TextStyle(color: ColorPallet.lightBlueWithOpacity, fontSize: 16),
                        ),
                      )
                    : Container(),
                index != (onboardingLength - 1)
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            index++;
                          });
                        },
                        child: Text(
                          "Volgende",
                          style: TextStyle(color: ColorPallet.lightBlueWithOpacity, fontSize: 16),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
                          dayOverviewNotifier.hasDisplayedOnboarding = true;
                          dayOverviewNotifier.setOnboarding(true);
                        },
                        child: Text(
                          "Begrepen",
                          style: TextStyle(color: ColorPallet.lightBlueWithOpacity, fontSize: 16),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
