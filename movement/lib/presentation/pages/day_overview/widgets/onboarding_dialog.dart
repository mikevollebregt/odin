import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movement/color_pallet.dart';
import 'package:movement/providers.dart';
import 'package:movement/text_style.dart';

class OnboardingWidget extends StatelessWidget {
  // Wrapper Widget
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer(builder: (context, ref, child) {
          showOnboardingDialog(context, ref);

          return Container();
        })
      ],
    );
  }
}

Future<void> showOnboardingDialog(BuildContext context, WidgetRef ref) async {
  List<OnboardingPage> onboardingText = [];
  final versionNotifier = ref.watch(versionNotifierProvider);
  if (versionNotifier.isInteractionAllowed()) {
    onboardingText = OnboardingTextLoader.getOnboardingVersionOne();
  } else {
    onboardingText = OnboardingTextLoader.getOnboardingVersionTwo();
  }

  int index = 0;
  int onboardingLength = onboardingText.length;
  SchedulerBinding.instance.addPostFrameCallback((_) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                            Navigator.of(context).pop();
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
                                  Navigator.of(context).pop();
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
          },
        );
      },
    );
  });
}

class OnboardingPage {
  List<Widget> _pageLayout = [];

  OnboardingPage(Text pageTitle, List<Widget> pageText) {
    _pageLayout.add(pageTitle);
    for (var item in pageText) {
      _pageLayout.add(item);
    }
  }

  List<Widget> getPageLayout() {
    return _pageLayout;
  }
}

class OnboardingTextLoader {
  // TODO: verzin een leuk naampje voor de verschillende onboardings
  static List<OnboardingPage> getOnboardingVersionOne() {
    List<OnboardingPage> _onBoarding = [];
    Widget _whiteRow = Container(height: 16);
    //Veel interactie versie
    _onBoarding = [];
    //Page 1
    Text pageOneTitle = Text(
      'Welkom op uw tijdlijn!',
      style: textStyleAkko20DarkThick,
    );
    List<Widget> pageOneBody = [];
    pageOneBody.add(_whiteRow);
    pageOneBody.add(Text(
      'Hier kunt u straks al uw verplaatsingen en bezochte locaties zien. Deze worden automatisch gemeten. Soms meet de app uw locaties en verplaatsingen niet helemaal correct. Controleer deze daarom goed en pas waar nodig aan. \nKlopt alles? Sluit de dag af door rechtsboven op het vinkje te drukken.',
      style: textStyleAkko16Dark,
    ));
    pageOneBody.add(_whiteRow);
    pageOneBody.add(Text(
      'Tips:',
      style: textStyleAkko16DarkThick,
    ));
    pageOneBody.add(Text(
      '• Zorg dat u uw telefoon de gehele dag bij u hebt en laad de telefoon mogelijk een extra keer op.',
      style: textStyleAkko16Dark,
    ));
    pageOneBody.add(_whiteRow);
    pageOneBody.add(Text(
      '• Zorg dat u bij Android altijd een locatie-icoontje bovenaan uw scherm ziet en dat u bij iOS een blauwe balk bovenaan uw scherm ziet.',
      style: textStyleAkko16Dark,
    ));
    OnboardingPage pageOne = OnboardingPage(pageOneTitle, pageOneBody);
    _onBoarding.add(pageOne);

    //Page 2
    Text pageTwoTitle = Text(
      'Locaties invullen',
      style: textStyleAkko20DarkThick,
    );
    List<Widget> pageTwoBody = [];
    pageTwoBody.add(_whiteRow);
    pageTwoBody.add(Text(
      '1. Druk op de eerste locatie',
      style: textStyleAkko16Dark,
    ));
    pageTwoBody.add(_whiteRow);
    pageTwoBody.add(Text(
      '2. Kloppen de tijden niet? Pas deze aan door op de tijden te drukken.',
      style: textStyleAkko16Dark,
    ));
    pageTwoBody.add(_whiteRow);
    pageTwoBody.add(Text(
      '3. Controleer ook of het adres klopt en pas aan waar nodig',
      style: textStyleAkko16Dark,
    ));
    pageTwoBody.add(_whiteRow);
    pageTwoBody.add(Text(
      '4. Vul in wat u deed op deze locatie (bijvoorbeeld werken, winkelen of sport) door op het invulveld te drukken en de reden te selecteren.',
      style: textStyleAkko16Dark,
    ));
    pageTwoBody.add(_whiteRow);
    pageTwoBody.add(Text(
      '5. Druk op het vinkje rechtsboven om de aanpassingen op te slaan.',
      style: textStyleAkko16Dark,
    ));
    OnboardingPage pageTwo = OnboardingPage(pageTwoTitle, pageTwoBody);
    _onBoarding.add(pageTwo);

    //Page 3
    Text pageThreeTitle = Text(
      'Verplaatsingen invullen',
      style: textStyleAkko20DarkThick,
    );
    List<Widget> pageThreeBody = [];
    pageThreeBody.add(_whiteRow);
    pageThreeBody.add(Text(
      '1. Druk op de eerste verplaatsing',
      style: textStyleAkko16Dark,
    ));
    pageThreeBody.add(_whiteRow);
    pageThreeBody.add(Text(
      '2. Kloppen de tijden niet? Pas deze aan door op de tijden te drukken.',
      style: textStyleAkko16Dark,
    ));
    pageThreeBody.add(_whiteRow);
    pageThreeBody.add(Text(
      '3. Vul in welk vervoermiddel u gebruikte door op het invulveld te drukken en het vervoermiddel te selecteren.',
      style: textStyleAkko16Dark,
    ));
    pageThreeBody.add(_whiteRow);
    pageThreeBody.add(Text(
      '4. Druk op het vinkje rechtsboven om de aanpassingen op te slaan.',
      style: textStyleAkko16Dark,
    ));
    OnboardingPage pageThree = OnboardingPage(pageThreeTitle, pageThreeBody);
    _onBoarding.add(pageThree);

    //Page 4
    Text pageFourTitle = Text(
      'Locaties of verplaatsingen toevoegen of verwijderen',
      style: textStyleAkko20DarkThick,
    );
    List<Widget> pageFourBody = [];
    pageFourBody.add(_whiteRow);
    pageFourBody.add(Text(
      'Toevoegen',
      style: textStyleAkko16DarkThick,
    ));
    pageFourBody.add(Text(
      'Gebruik het plusje rechtsonder in dit scherm om niet geregistreerde locaties of verplaatsingen zelf toe te voegen.',
      style: textStyleAkko16Dark,
    ));
    pageFourBody.add(_whiteRow);
    pageFourBody.add(Text(
      'Verwijderen',
      style: textStyleAkko16DarkThick,
    ));
    pageFourBody.add(Text(
      'Ziet u een locatie of verplaatsing die niet klopt, hou deze dan lang ingedrukt en druk op het prullenbak-icoontje rechtsboven om deze te verwijderen. Wilt u er meerdere tegelijk verwijderen? Selecteer deze dan door erop te drukken en druk vervolgens op het prullenbak-icoontje.',
      style: textStyleAkko16Dark,
    ));
    pageFourBody.add(_whiteRow);
    pageFourBody.add(Text(
      'U kunt deze tips teruglezen door linksboven op het i-icoon te drukken. Veel plezier met het onderzoek!',
      style: textStyleAkko16Dark,
    ));
    OnboardingPage pageFour = OnboardingPage(pageFourTitle, pageFourBody);
    _onBoarding.add(pageFour);

    return _onBoarding;
  }

  // TODO: verzin een leuk naampje voor de verschillende onboarding
  static List<OnboardingPage> getOnboardingVersionTwo() {
    List<OnboardingPage> _onBoarding = [];
    Widget _whiteRow = Container(height: 16);
    //Weinig interactie versie
    _onBoarding = [];
    //Page 1
    Text pageOneTitle = Text(
      'Welkom op uw tijdlijn!',
      style: textStyleAkko20DarkThick,
    );
    List<Widget> pageOneBody = [];
    pageOneBody.add(_whiteRow);
    pageOneBody.add(Text(
      'Hier kunt u straks al uw verplaatsingen en bezochte locaties zien. Deze worden automatisch gemeten. De app zal soms te veel of te weinig locaties en verplaatsingen meten. Maakt u zich daar geen zorgen over. \nSluit de dag af door rechtsboven op het vinkje te drukken.',
      style: textStyleAkko16Dark,
    ));
    pageOneBody.add(_whiteRow);
    pageOneBody.add(Text(
      'Tips:',
      style: textStyleAkko16DarkThick,
    ));
    pageOneBody.add(Text(
      '• Zorg dat u uw telefoon de gehele dag bij u hebt en laad de telefoon mogelijk een extra keer op.',
      style: textStyleAkko16Dark,
    ));
    pageOneBody.add(_whiteRow);
    pageOneBody.add(Text(
      '• Zorg dat u bij Android altijd een locatie-icoontje bovenaan uw scherm ziet en dat u bij iOS een blauwe balk bovenaan uw scherm ziet.',
      style: textStyleAkko16Dark,
    ));
    OnboardingPage pageOne = OnboardingPage(pageOneTitle, pageOneBody);
    _onBoarding.add(pageOne);

    //Page 2
    Text pageTwoTitle = Text(
      'Locaties invullen',
      style: textStyleAkko20DarkThick,
    );
    List<Widget> pageTwoBody = [];
    pageTwoBody.add(_whiteRow);
    pageTwoBody.add(Text(
      '1. Druk op de eerste locatie',
      style: textStyleAkko16Dark,
    ));
    pageTwoBody.add(_whiteRow);
    pageTwoBody.add(Text(
      '2. Vul in wat u deed op deze locatie (bijvoorbeeld werken, winkelen of sport) door op het invulveld te drukken en de reden te selecteren.',
      style: textStyleAkko16Dark,
    ));
    pageTwoBody.add(_whiteRow);
    pageTwoBody.add(Text(
      '3. Druk op het vinkje rechtsboven om de aanpassingen op te slaan.',
      style: textStyleAkko16Dark,
    ));
    OnboardingPage pageTwo = OnboardingPage(pageTwoTitle, pageTwoBody);
    _onBoarding.add(pageTwo);

    //Page 3
    Text pageThreeTitle = Text(
      'Verplaatsingen invullen',
      style: textStyleAkko20DarkThick,
    );
    List<Widget> pageThreeBody = [];
    pageThreeBody.add(_whiteRow);
    pageThreeBody.add(Text(
      '1. Druk op de eerste verplaatsing',
      style: textStyleAkko16Dark,
    ));
    pageThreeBody.add(_whiteRow);
    pageThreeBody.add(Text(
      '2. Vul in welk vervoermiddel u gebruikte door op het invulveld te drukken en het vervoermiddel te selecteren.',
      style: textStyleAkko16Dark,
    ));
    pageThreeBody.add(_whiteRow);
    pageThreeBody.add(Text(
      '3. Bij een verplaatsing die bestaat uit meerdere vervoermiddelen hoeft u enkel de belangrijkste (meeste kilometers) in te vullen.',
      style: textStyleAkko16Dark,
    ));
    pageThreeBody.add(_whiteRow);
    pageThreeBody.add(Text(
      '4. Druk op het vinkje rechtsboven om de aanpassingen op te slaan.',
      style: textStyleAkko16Dark,
    ));
    OnboardingPage pageThree = OnboardingPage(pageThreeTitle, pageThreeBody);
    _onBoarding.add(pageThree);

    //Page 4
    Text pageFourTitle = Text(
      'Locaties of verplaatsingen verwijderen',
      style: textStyleAkko20DarkThick,
    );
    List<Widget> pageFourBody = [];
    pageFourBody.add(_whiteRow);
    pageFourBody.add(Text(
      'Verwijderen',
      style: textStyleAkko16DarkThick,
    ));
    pageFourBody.add(Text(
      'Ziet u een locatie of verplaatsing die niet klopt, hou deze dan lang ingedrukt en druk op het prullenbak-icoontje rechtsboven om deze te verwijderen. Wilt u er meerdere tegelijk verwijderen? Selecteer deze dan door erop te drukken en druk vervolgens op het prullenbak-icoontje.',
      style: textStyleAkko16Dark,
    ));
    pageFourBody.add(_whiteRow);
    pageFourBody.add(Text(
      'U kunt deze tips teruglezen door linksboven op het i-icoon te drukken. Veel plezier met het onderzoek!',
      style: textStyleAkko16Dark,
    ));
    OnboardingPage pageFour = OnboardingPage(pageFourTitle, pageFourBody);
    _onBoarding.add(pageFour);

    return _onBoarding;
  }
}
