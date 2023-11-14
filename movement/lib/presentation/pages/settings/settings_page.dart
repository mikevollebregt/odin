import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../color_pallet.dart';
import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../infrastructure/services/localization_service.dart';
import '../../../text_style.dart';
import '../../routing/routes.dart';
import '../../widgets/elevated_button.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Instellingen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0 * x),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30 * y),
              Text(AppLocalizations.of(context).translate('settingspage_contact'), style: textStyleSoho20Black),
              SizedBox(height: 20 * y),
              PhonenumberWidget(),
              SizedBox(height: 10 * y),
              EmailWidget(),
              SizedBox(height: 10 * y),
              FAQWidget(),
              Expanded(child: SizedBox()),
              SupportWidget(),
              SizedBox(height: 30 * y),
            ],
          ),
        ),
      ),
    );
  }
}

class PhonenumberWidget extends StatelessWidget {
  final telephoneNumber = '0455706400';

  Future<void> _launchPhoneURL() async {
    await log('SettingsPage::_launchPhoneURL', 'telephoneNumber: $telephoneNumber', LogType.Flow);
    final url = 'tel:$telephoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchPhoneURL,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15 * y),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context).translate('settingspage_phonenumber'), style: textStyleAkko18Black),
            Text(AppLocalizations.of(context).translate('settingspage_telephonenumber'), style: textStyleAkko18Blue),
          ],
        ),
      ),
    );
  }
}

class EmailWidget extends StatelessWidget {
  final emailText = 'apphelpdesk@cbs.nl';

  Future<void> _launchEmailURL() async {
    await log('SettingsPage::_launchEmailURL', 'url: $emailText', LogType.Flow);
    final emailLaunchUri = Uri(scheme: 'mailto', path: emailText);
    final email = emailLaunchUri.toString();
    if (await canLaunchUrl(Uri.parse(email))) await launchUrl(Uri.parse(email));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchEmailURL,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15 * y),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context).translate('settingspage_email'), style: textStyleAkko18Black),
            Text(AppLocalizations.of(context).translate('settingspage_urltext'), style: textStyleAkko18Blue),
          ],
        ),
      ),
    );
  }
}

class FAQWidget extends StatelessWidget {
  final _urlText = 'Link naar FAQ';
  final _url =
      'https://www.cbs.nl/nl-nl/deelnemers-enquetes/personen/overzicht/cbs-onderweg-in-nederland-app/veelgestelde-vragen-de-cbs-onderweg-in-nederland-app';

  Future<void> _launchFaqURL() async {
    await log('SettingsPage::_launchFaqURL', 'url: $_urlText', LogType.Flow);
    try {
      await launchUrlString(_url);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchFaqURL,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15 * y),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context).translate('settingspage_faq'), style: textStyleAkko18Black),
            Text(AppLocalizations.of(context).translate('settingspage_faqurl'), style: textStyleAkko18Blue),
          ],
        ),
      ),
    );
  }
}

class SupportWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0 * x, vertical: 10 * y),
      child: ElevatedIconButtonWidget(
        buttonText: 'Technische hulp',
        iconData: Icons.support_agent,
        screenWidth: MediaQuery.of(context).size.width,
        buttonColor: ColorPallet.primaryColor,
        onPressed: () => Routes.RouteToPage(Routes.supportPage, context),
      ),
    );
  }
}
