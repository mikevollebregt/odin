import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../infrastructure/services/localization_service.dart';
import '../../../text_style.dart';

class QuestionsIntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log('QuestionIntroductionPage::build', '', LogType.Flow);
    return Padding(
        padding: EdgeInsets.only(left: 25 * x, top: 20 * y, right: 25 * x, bottom: 20 * y),
        child: Column(
          children: [
            Row(
              children: [Text(AppLocalizations.of(context).translate('questionsintroductionpage_title'), style: textStyleSoho24Black)],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 50 * y),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: SvgPicture.asset('assets/images/4.svg'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('questionsintroductionpage_questions'),
                      style: textStyleSoho20Black,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 28 * y),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context).translate('questionsintroductionpage_helptext1'),
                            style: textStyleAkko16Black,
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.all(3 * f),
                              child: Icon(Icons.settings, size: 20 * f),
                            ),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context).translate('questionsintroductionpage_helptext2'),
                            style: textStyleAkko16Black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
