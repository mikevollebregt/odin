import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:questionnaire/questionnaire.dart';

import '../../../color_pallet.dart';
import '../../infrastructure/repositories/network/base_api.dart';

mixin CreateQuestionnaireMixin {
  List<QuestionBase>? questionList;
  Map<String, Color>? colorList;
  Map<String, String>? textList;

  void _createQuestionList() {
    final vervoerChoices = [
      'Lopen',
      'Fietsen (niet electrisch)',
      'Fietsen (electrisch)',
      'In de bus (alleen ov)',
      'In de tram',
      'In de metro',
      'In de trein',
      'Autorijden (als bestuurder)',
      'Autorijden (als passagier)',
      'Brom/snor-fiets rijden',
      'Motor rijden',
      'Overig',
    ];

    final vervoerIcons = [
      FontAwesomeIcons.personWalking,
      FontAwesomeIcons.bicycle,
      FontAwesomeIcons.batteryHalf,
      FontAwesomeIcons.bus,
      FontAwesomeIcons.trainSubway,
      FontAwesomeIcons.train,
      FontAwesomeIcons.train,
      FontAwesomeIcons.car,
      FontAwesomeIcons.car,
      FontAwesomeIcons.motorcycle,
      FontAwesomeIcons.motorcycle,
      FontAwesomeIcons.road
    ];

    final locationChoices = [
      'Thuis',
      'Werk',
      'School',
      'Fitness',
      'Bar/Restaurant',
    ];

    final locationIcons = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.building,
      FontAwesomeIcons.school,
      FontAwesomeIcons.personRunning,
      FontAwesomeIcons.utensils,
    ];

    final genderChoices = [
      'Man',
      'Vrouw',
      'Overig',
    ];

    final userDescriptionsChoices = [
      'Huisvrouw/huisman',
      'Gepensioneerd of met de VUT',
      'Scholier of student',
      'Arbeidsongeschikt',
      'Werkloos',
      'Werkende met betaald werk, minder dan 12 uur per week',
      'Werkende met betaald werk, 12 tot 30 uur per week',
      'Werkende met betaald werk, 30 uur of meer per week',
      'Onbetaald werk, mantelzorg',
    ];

    final educationChoices = [
      'Basisonderwijs, Lager onderwijs',
      'LBO, VMBO, VBO, lwoo, vso, vglo, mavo, ulo, mulo',
      'MBO, havo atheneum, gymnasium, mms, hbs',
      'HBO, WO',
      'Een andere opleiding',
      'Geen opleiding voltooid',
    ];

    final yesNoChoices = [
      'Ja',
      'Nee',
    ];

    final yesNoExtendedChoices = [
      'Ja',
      'Nee',
      'Weet ik niet',
    ];

    questionList = List<QuestionBase>.empty(growable: true);

    // Question 1: Geslacht - Multichoice
    final genderList = List<ChoiceDefinition>.empty(growable: true);
    for (var choicenumber = 0; choicenumber < genderChoices.length; choicenumber++) {
      genderList.add(ChoiceDefinition(
        choiceNumber: choicenumber + 1,
        choiceText: genderChoices[choicenumber],
      ));
    }

    final genderQuestion = SingleChoiceQuestionDefinition(
      questionNumber: 1,
      questionText: 'Wat is uw geslacht?',
      choiceList: genderList,
    );

    // Question 2: Geboortedatum - Invoerveld
    final ageQuestion = NormalQuestionDefinition(
      subType: QuestionType.birthday,
      questionNumber: 2,
      questionText: 'Wat is uw geboortedatum?',
      keyboardType: TextInputType.numberWithOptions(signed: true),
      hintTextfieldText: 'DD-MM-JJJJ',
      textFieldHeader: 'Geboortedatum',
      textFieldIcon: const Icon(Icons.calendar_month, color: Color(0xFF33425B)),
    );

    // Question 3: Woonadres - Invoerveld + Check
    final addressQuestion = NormalQuestionDefinition(
      subType: QuestionType.address,
      questionNumber: 3,
      questionText: 'Wat is uw woonadres?',
      keyboardType: TextInputType.text,
      hintTitleText: '(straat, huisnummer, woonplaats)',
      hintTextfieldText: 'Vul uw adres in',
      textFieldHeader: 'Adres',
      uriLink: Uri.parse('$serverSocketAddress/api/googlesearch/textsearch/'),
      tokenHeader: bearerToken,
      // textFieldIcon: const Icon(Icons.calendar_month, color: )
    );

    // Question 4: Zijn er electrische fietsen? - Yes/No
    final electricBikeList = List<ChoiceDefinition>.empty(growable: true);
    for (var choicenumber = 0; choicenumber < yesNoChoices.length; choicenumber++) {
      electricBikeList.add(ChoiceDefinition(
        choiceNumber: choicenumber + 1,
        choiceText: yesNoChoices[choicenumber],
      ));
    }

    final electricBikesQuestion = SingleChoiceQuestionDefinition(
      questionNumber: 4,
      questionText: 'Zijn er 1 of meer elektrische fietsen in uw huishouden aanwezig?',
      hintText: 'Speed pedelecs tellen ook mee.',
      choiceList: electricBikeList,
    );

    // Question 5: Hoeveel personenauto's - Invulveld + Geen antwoord
    final personalCarsQuestion = NormalQuestionDefinition(
      questionNumber: 5,
      questionText: 'Hoeveel personenauto\'s zijn er in uw huishouden aanwezig?',
      keyboardType: TextInputType.number,
      hintTextfieldText: 'Aantal personenauto\'s',
      hintTitleText: '(Private) Leaseauto\'s of auto\'s op naam van een bedrijf ook meetellen. Geen bestelauto\'s meetellen.',
      choice: ChoiceDefinition(
        choiceNumber: 1,
        choiceText: 'Geen antwoord',
      ),
      conditions: {'0': 10, '1': 8, '2': 6, 'Other': 6, 'Geen antwoord': 10},
    );

    // Question 6: Hoeveel van deze X personenautos zijn lease - Invoerveld + Weet ik niet
    final personalCarsLeaseQuestion = NormalQuestionDefinition(
      questionNumber: 6,
      questionText: 'Hoeveel van deze personenauto\'s zijn geleased of staan op naam van een bedrijf?',
      keyboardType: TextInputType.number,
      hintTextfieldText: 'Aantal personenauto\'s',
      choice: ChoiceDefinition(
        choiceNumber: 1,
        choiceText: 'Weet ik niet',
      ),
      conditions: {'1': 9, '2': 7, '0': 10, 'Other': 7, 'Weet ik niet': 10},
    );

    // Question 7: Neem de leaseauto of auto op naam van een bedrijf - Invoerveld + Weet ik niet
    final leaseNumberPlateQuestion = NormalQuestionDefinition(
      subType: QuestionType.numberplate,
      questionNumber: 7,
      questionText:
          'Neem de leaseauto of auto op naam van een bedrijf in gedachten waarmee doorgaans de meeste kilometers gereden worden. Wat is het kenteken van deze auto?',
      keyboardType: TextInputType.text,
      hintTextfieldText: 'Kenteken',
      choice: ChoiceDefinition(
        choiceNumber: 1,
        choiceText: 'Weet ik niet',
      ),
      conditions: {
        'Route': 10,
      },
    );

    // Question 8: Is deze auto geleased of staat deze op naam van een bedrijf? - Yes/No/IDK
    final isLeasedList = List<ChoiceDefinition>.empty(growable: true);
    for (var choicenumber = 0; choicenumber < yesNoExtendedChoices.length; choicenumber++) {
      isLeasedList.add(ChoiceDefinition(
        choiceNumber: choicenumber + 1,
        choiceText: yesNoExtendedChoices[choicenumber],
      ));
    }

    final isLeasedQuestion = SingleChoiceQuestionDefinition(
      questionNumber: 8,
      questionText: 'Is deze auto geleased of staat deze op naam van een bedrijf?',
      choiceList: isLeasedList,
    );

    // Question 9: Wat is het kenteken deze auto?
    final numberPlateQuestion = NormalQuestionDefinition(
      subType: QuestionType.numberplate,
      questionNumber: 9,
      questionText: 'Wat is het kenteken van de auto?',
      keyboardType: TextInputType.text,
      hintTextfieldText: 'Kenteken',
      choice: ChoiceDefinition(
        choiceNumber: 1,
        choiceText: 'Weet ik niet',
      ),
    );

    // Question 10: Hoogst voltooide opleiding
    final educationList = List<ChoiceDefinition>.empty(growable: true);
    for (var choicenumber = 0; choicenumber < educationChoices.length; choicenumber++) {
      educationList.add(ChoiceDefinition(
        choiceNumber: choicenumber + 1,
        choiceText: educationChoices[choicenumber],
      ));
    }

    final educationQuestion = SingleChoiceQuestionDefinition(
      questionNumber: 10,
      questionText: 'Wat is uw hoogst voltooide opleiding?',
      choiceList: educationList,
    );

    // Question 11: Beroep vaak verplaatsen?
    final yesNoList = List<ChoiceDefinition>.empty(growable: true);
    for (var choicenumber = 0; choicenumber < yesNoChoices.length; choicenumber++) {
      yesNoList.add(ChoiceDefinition(
        choiceNumber: choicenumber + 1,
        choiceText: yesNoChoices[choicenumber],
      ));
    }

    final workMovealotQuestion = SingleChoiceQuestionDefinition(
      questionNumber: 11,
      questionText: 'Heeft u een beroep waarvoor u regelmatig verplaatsingen moet maken',
      hintText: 'Denk bijvoorbeeld aan beroepen zoals: bezorger, loodgieter en thuiszorgmedewerker',
      choiceList: yesNoList,
    );

    // Question 12: Gebruikersomschrijving
    final userDescriptionList = List<ChoiceDefinition>.empty(growable: true);
    for (var choicenumber = 0; choicenumber < userDescriptionsChoices.length; choicenumber++) {
      userDescriptionList.add(ChoiceDefinition(
        choiceNumber: choicenumber + 1,
        choiceText: userDescriptionsChoices[choicenumber],
      ));
    }

    final userDescriptionQuestion = MultipleChoiceQuestionDefinition(
      questionNumber: 12,
      questionText: 'Welke van de volgende omschrijvingen vindt u het best bij u passen?',
      hintText: 'Meerdere antwoorden mogelijk',
      choiceList: userDescriptionList,
    );

    questionList!.add(genderQuestion); //Q1
    questionList!.add(ageQuestion); //Q2
    questionList!.add(addressQuestion); //Q3
    questionList!.add(electricBikesQuestion); //Q4
    questionList!.add(personalCarsQuestion); //Q5
    questionList!.add(personalCarsLeaseQuestion); //Q6
    questionList!.add(leaseNumberPlateQuestion); //Q7
    questionList!.add(isLeasedQuestion); //Q8
    questionList!.add(numberPlateQuestion); //Q9
    questionList!.add(educationQuestion); // Q10
    questionList!.add(workMovealotQuestion); //Q11
    questionList!.add(userDescriptionQuestion); //Q12
  }

  void _createColorList() {
    colorList = <String, Color>{};
    colorList![questionnaireCaptionColorText] = const Color.fromARGB(255, 20, 26, 36);
    colorList![questionnaireBlueButtonColorText] = ColorPallet.lightBlueWithOpacity;
    colorList![questionnairePrimaryTextColorText] = const Color.fromARGB(255, 20, 26, 36);
    colorList![questionnaireBackgroundColorText] = const Color(0xFF00A1CD);
    colorList![questionnaireGreyButtonColorText] = const Color(0xFFAAAAAA);
    colorList![questionnaireGreenButtonColorText] = ColorPallet.lightGreen;
  }

  void _createTextList() {
    textList = <String, String>{};
    textList![questionnaireCaptionText] = 'Startvragenlijst';
    textList![questionnaireQuestionText] = 'Vraag';
    textList![questionnaireIntroText] = 'Intro';
    textList![questionnaireSaveButtonText] = 'Verzenden';
    textList![questionnaireStartButtonText] = 'Start';
    textList![questionnaireNextButtonText] = 'Volgende';
    textList![questionnaireConfirmButtonText] = 'Bevestigen';
    textList![questionnaireLastPageEndText] = 'Einde';
    textList![questionnaireLastPageLine1Text] = 'Bedankt voor het invullen van de vragenlijst!';
    textList![questionnaireLastPageLine2Text] =
        'Stuur de vragenlijst naar het CBS door op \'verzenden\' te drukken. Daarna kunt u beginnen met het gebruik van de Onderweg in Nederland app.';
    textList![questionnaireLastPageLine3Text] = 'Hartelijk dank voor uw medewerking!';
    textList![questionnaireAnswersSentText] = 'Verzonden';
    textList![questionnaireIntroductionPageLine1Text] = 'Hartelijk bedankt dat u meedoet aan het onderzoek Onderweg in Nederland';
    textList![questionnaireIntroductionPageLine2Text] = 'Om goede statistieken te kunnen maken is het voor ons belangrijk dat u zelf de vragen invult.';
    textList![questionnaireIntroductionPageLine3Text] = "Druk op 'Start' om te beginnen.";
  }

  void createQuestionnaire() {
    _createQuestionList();
    _createColorList();
    _createTextList();
  }
}
