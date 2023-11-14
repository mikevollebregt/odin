import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../color_pallet.dart';
import '../../infrastructure/notifiers/responsive_ui.dart';
import '../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../infrastructure/repositories/log_repository.dart';
import '../../infrastructure/services/localization_service.dart';
import '../../providers.dart';
import '../../text_style.dart';
import '../animations/animation_stopped_mixin.dart';
import '../animations/flare_animation.dart';
import 'day_comment_mixin.dart';

class ChoiceDefinition {
  // contains the choice number
  final int _choiceNumber;

  // contains the choice text
  final String _choiceText;

  ChoiceDefinition(int choiceNumber, String choiceText)
      : _choiceNumber = choiceNumber,
        _choiceText = choiceText;
}

Future<void> dayCommentDialog(BuildContext context, DayCommentMixin delegate, WidgetRef ref, AnimationStoppedMixin animationDelegate) async {
  final _textEditingController = TextEditingController();
  var showAnimation = false;
  var choiceClicked = -1;
  final notifier = ref.watch(dayOverviewNotifierProvider);
  final trackedDay = await notifier.getTrackedDay(notifier.day);

  if (trackedDay!.confirmed) {
    choiceClicked = trackedDay.choiceId!;
    _textEditingController.text = trackedDay.choiceText!;
  }

  await log('DayCommentDialog::build', 'trackedDayDate:' + trackedDay.date.toString(), LogType.Flow);

  final dayOverviewNotifier = ref.watch(dayOverviewNotifierProvider);
  await dayOverviewNotifier.trackedDayHasMovements();

  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      final _choices = [
        ChoiceDefinition(1, AppLocalizations.of(context).translate('daycommentdialog_daychoice1')),
        ChoiceDefinition(2, AppLocalizations.of(context).translate('daycommentdialog_daychoice2')),
        ChoiceDefinition(3, AppLocalizations.of(context).translate('daycommentdialog_daychoice3')),
        ChoiceDefinition(4, AppLocalizations.of(context).translate('daycommentdialog_daychoice4')),
        ChoiceDefinition(5, AppLocalizations.of(context).translate('daycommentdialog_daychoice5')),
        ChoiceDefinition(6, AppLocalizations.of(context).translate('daycommentdialog_daychoice6')),
        ChoiceDefinition(7, AppLocalizations.of(context).translate('daycommentdialog_daychoice7')),
        ChoiceDefinition(8, AppLocalizations.of(context).translate('daycommentdialog_daychoice8')),
        ChoiceDefinition(9, AppLocalizations.of(context).translate('daycommentdialog_daychoice9')),
        ChoiceDefinition(10, AppLocalizations.of(context).translate('daycommentdialog_daychoice10')),
        ChoiceDefinition(11, AppLocalizations.of(context).translate('daycommentdialog_daychoice11')),
      ];

      return StatefulBuilder(builder: (context, setState) {
        return showAnimation
            ? FlareAnimationWidget(delegate: animationDelegate)
            : Dialog(
                insetPadding: EdgeInsets.all(20 * f),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20 * x),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5 * y, bottom: 15 * y),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 30 * y),
                                        child: Text(AppLocalizations.of(context).translate('daycommentdialog_daycommentstitle'), style: textStyleSoho24Black),
                                      ),
                                    ],
                                  )),
                              SizedBox(width: 10 * x),
                              Expanded(
                                  child: Column(
                                children: [
                                  IconButton(
                                    icon: const FaIcon(
                                      FontAwesomeIcons.xmark,
                                      color: Color(0xFF979797),
                                    ),
                                    alignment: Alignment.topCenter,
                                    iconSize: 14 * f,
                                    color: const Color(0xFF979797),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                        TextField(
                          controller: _textEditingController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintText: AppLocalizations.of(context).translate('daycommentdialog_fillincomments'), hintStyle: textStyleAkko16Hint),
                        ),
                        dayOverviewNotifier.hasMovements
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.only(top: 25 * y, bottom: 15 * y),
                                child: Text(AppLocalizations.of(context).translate('daycommentdialog_differenceintravel'), style: textStyleSoho20Black),
                              ),
                        for (var item in _choices)
                          dayOverviewNotifier.hasMovements
                              ? Container()
                              : RadioListTile(
                                  title: Text(
                                    item._choiceText,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: textStyleAkko16Black,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  value: item._choiceNumber,
                                  groupValue: choiceClicked,
                                  activeColor: ColorPallet.primaryColor,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      choiceClicked = item._choiceNumber;
                                    });
                                  },
                                ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20 * y, top: 20 * y),
                          child: Center(
                            child: (choiceClicked != -1 || dayOverviewNotifier.hasMovements)
                                ? ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        showAnimation = true;
                                      });
                                      delegate.onDayComment(context, _textEditingController.text, choiceClicked, ref);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
                                      primary: ColorPallet.primaryColor,
                                      shadowColor: const Color.fromRGBO(0, 0, 0, 0.5),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context).translate('daycommentdialog_completeday'),
                                      style: textStyleAkko18,
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.07),
                                      primary: ColorPallet.lightGrayishBlue,
                                      shadowColor: const Color.fromRGBO(0, 0, 0, 0.5),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      AppLocalizations.of(context).translate('daycommentdialog_completeday'),
                                      style: textStyleAkko18,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
      });
    },
  );
}
