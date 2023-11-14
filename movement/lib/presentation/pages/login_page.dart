import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../color_pallet.dart';
import '../../infrastructure/notifiers/auth_notifier.dart';
import '../../infrastructure/notifiers/generic_notifier.dart';
import '../../infrastructure/notifiers/responsive_ui.dart';
import '../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../infrastructure/repositories/log_repository.dart';
import '../../infrastructure/services/localization_service.dart';
import '../../providers.dart';
import '../../text_style.dart';
import '../routing/routes.dart';
import '../widgets/elevated_button.dart';
import '../widgets/text_field.dart';

Future<void> _loginErrorNoInternetDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(children: [
          FaIcon(FontAwesomeIcons.circleExclamation, size: 40 * f, color: ColorPallet.orangeDark),
          SizedBox(width: 20 * x),
          Text(AppLocalizations.of(context).translate('loginpage_errormessage'), style: textStyleSourceSans20),
        ]),
        content: Text(AppLocalizations.of(context).translate('loginpage_errorexplanationtext'), style: textStyleSourceSans16Black),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context).translate('loginpage_okay_warning'), style: textStyleSourceSans18),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with TextFieldMixin {
  final imagePath = 'assets/images/qr_code_scanning.png';

  String _email = '';
  String _password = '';

  bool get _fieldsFilled {
    return _email.isNotEmpty && _password.isNotEmpty;
  }

  Future<bool> _login(WidgetRef ref, BuildContext context) async {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final value = await authNotifier.authenticate(_email.trim(), _password.trim());
    print('authenticate called for username [$_email] and password [$_password], value [$value] !');
    return value;
  }

  Future<void> _launchURL() async {
    final url = 'tel:${AppLocalizations.of(context).translate('loginpage_telephonenumber')}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw Exception('Could not launch $url');
    }
  }

  void _goToIntroductionScreen() {
    Routes.RouteToPage(Routes.introPage, context);
  }

  Future<void> _gotoNextScreen() async {
    final prefs = await SharedPreferences.getInstance();

    final startIntroduction = prefs.getBool('introduction') ?? false;

    if (startIntroduction) {
      _goToIntroductionScreen();
      await prefs.setBool('introduction', false);
    }
  }

  @override
  void onTextChanged(String source, String text) {
    print('Text Changed by [$source] with value [$text]');

    if (source == AppLocalizations.of(context).translate('loginpage_usertext')) {
      setState(() {
        _email = text;
      });
    } else if (source == AppLocalizations.of(context).translate('loginpage_passwordtext')) {
      setState(() {
        _password = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    log('LoginPage::build', '', LogType.Flow);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: height - MediaQuery.of(context).padding.top,
            color: ColorPallet.primaryColor,
            child: Padding(
              padding: EdgeInsets.only(left: 25 * x, right: 25 * x, bottom: 30 * y, top: 20 * y),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.15),
                    child: ClipOval(
                      child: Container(
                        height: 70 * y,
                        width: 70 * y,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(8 * f),
                          child: Image.asset(
                            'assets/images/cbs_logo.png',
                            width: 60 * y,
                            height: 60 * y,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15 * y),
                  Text(
                    AppLocalizations.of(context).translate('loginpage_title'),
                    style: textStyleSoho36,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15 * y),
                  Text(
                    AppLocalizations.of(context).translate('loginpage_explanationtext'),
                    style: textStyleAkko20,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15 * y),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final state = ref.watch(authNotifierProvider);
                            final notifier = ref.watch(authNotifierProvider.notifier);
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorPallet.lightBlueWithOpacity,
                                    border: Border.all(
                                        color: (notifier.userNameCorrect || state is Initial || state is Loading)
                                            ? ColorPallet.lightBlueWithOpacity
                                            : const Color(0xFFDB7758),
                                        width: 2 * x),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12 * x, vertical: 2 * y),
                                    child: TextFieldWidget(
                                      isObscureText: false,
                                      textCapitalization: TextCapitalization.none,
                                      source: AppLocalizations.of(context).translate('loginpage_usertext'),
                                      keyboardType: TextInputType.text,
                                      hintText: AppLocalizations.of(context).translate('loginpage_usertext'),
                                      icon: FaIcon(FontAwesomeIcons.userLarge, color: Colors.white.withOpacity(0.7)),
                                      delegate: this,
                                    ),
                                  ),
                                ),
                                buildUsernameError(context, ref, state, notifier),
                              ],
                            );
                          },
                        ),
                        Consumer(builder: (context, ref, child) {
                          final state = ref.watch(authNotifierProvider);
                          final notifier = ref.watch(authNotifierProvider.notifier);
                          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorPallet.lightBlueWithOpacity,
                                border: Border.all(
                                    color: (!notifier.userNameCorrect || notifier.passwordCorrect || state is Initial || state is Loading)
                                        ? ColorPallet.lightBlueWithOpacity
                                        : const Color(0xFFDB7758),
                                    width: 2 * x),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12 * x, vertical: 2 * y),
                                child: TextFieldWidget(
                                  source: AppLocalizations.of(context).translate('loginpage_passwordtext'),
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.none,
                                  hintText: AppLocalizations.of(context).translate('loginpage_passwordtext'),
                                  isObscureText: true,
                                  icon: FaIcon(FontAwesomeIcons.key, color: Colors.white.withOpacity(0.7)),
                                  delegate: this,
                                ),
                              ),
                            ),
                            buildPasswordError(context, ref, state, notifier),
                          ]);
                        }),
                        SizedBox(height: 5 * y),
                        Consumer(builder: (context, ref, child) {
                          final state = ref.watch(authNotifierProvider);
                          if (state is Loaded<bool> || state is Initial) {
                            return ElevatedButtonWidget(
                                buttonText: AppLocalizations.of(context).translate('loginpage_loginbutton'),
                                screenWidth: width,
                                buttonColor: ColorPallet.lightGreen,
                                onPressed: _fieldsFilled
                                    ? () async {
                                        final res = await _login(ref, context);
                                        if (res) {
                                          if (!mounted) return;

                                          final calendarNotifier = ref.read(calendarPageNotifierProvider);
                                          await calendarNotifier.setupCalendarDays();
                                          await _gotoNextScreen();
                                        }
                                      }
                                    : null);
                          } else if (state is Loading) {
                            return Stack(children: [
                              Align(
                                heightFactor: 1.3,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10 * y),
                                  height: 20,
                                  width: 20,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Align(child: ElevatedButtonWidget(buttonText: '', screenWidth: width, buttonColor: ColorPallet.lightGreen, onPressed: null))
                            ]);
                          } else {
                            return ElevatedButtonWidget(
                                buttonText: AppLocalizations.of(context).translate('loginpage_loginbutton'),
                                screenWidth: width,
                                buttonColor: ColorPallet.lightGreen,
                                onPressed: _fieldsFilled
                                    ? () async {
                                        final res = await _login(ref, context);
                                        if (res) {
                                          if (!mounted) return;

                                          final calendarNotifier = ref.read(calendarPageNotifierProvider);
                                          await calendarNotifier.setupCalendarDays();
                                          await _gotoNextScreen();
                                        }
                                      }
                                    : null);
                          }
                        }),
                        SizedBox(height: 15 * y),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: AppLocalizations.of(context).translate('loginpage_forgotpasswordtext'),
                              style: textStyleAkko16,
                              recognizer: TapGestureRecognizer()..onTap = _launchURL,
                            ),
                          ]),
                        ),
                        SizedBox(height: 5 * y),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: AppLocalizations.of(context).translate('loginpage_getincontacttext'),
                            style: textStyleAkko16,
                            recognizer: TapGestureRecognizer()..onTap = _launchURL,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUsernameError(BuildContext context, WidgetRef ref, NotifierState state, AuthNotifier notifier) {
    if (notifier.passwordCorrect || state is Initial || state is Loading) {
      return Padding(padding: EdgeInsets.only(top: 15 * y));
    } else if (!notifier.userNameCorrect && state is! Initial) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15 * y),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFDB7758),
          ),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 15 * y, bottom: 15 * y, left: 15 * x),
            child: Text(
              'Gebruikersnaam ongeldig',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      );
    } else {
      return Padding(padding: EdgeInsets.only(top: 15 * y));
    }
  }

  Widget buildPasswordError(BuildContext context, WidgetRef ref, NotifierState state, AuthNotifier notifier) {
    final diff = notifier.lastAttempt.add(const Duration(seconds: 60)).difference(notifier.thisAttempt).inSeconds;
    final attempts = 3 - notifier.attempts;
    if ((notifier.isTimeLocked || attempts < 0) && diff > 0 && notifier.userNameCorrect && state is! Initial) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15 * y),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFDB7758),
          ),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 15 * y, bottom: 15 * y, left: 15 * x),
            child: Text(
              'U moet nog $diff seconden wachten',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      );
    } else if (notifier.passwordCorrect || state is Initial || state is Loading) {
      return Padding(padding: EdgeInsets.only(top: 15 * y));
    } else if (!notifier.isTimeLocked && state is! Initial && notifier.userNameCorrect && attempts >= 0) {
      return Padding(
        padding: EdgeInsets.only(bottom: 15 * y),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFDB7758),
          ),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 15 * y, bottom: 15 * y, left: 15 * x),
            child: Text(
              'Wachtwoord ongeldig. Nog ${attempts + 1} pogingen.',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      );
    } else if (notifier.passwordCorrect || state is Initial || state is Loading) {
      return Padding(padding: EdgeInsets.only(top: 15 * y));
    } else {
      return Padding(padding: EdgeInsets.only(top: 15 * y));
    }
  }
}
