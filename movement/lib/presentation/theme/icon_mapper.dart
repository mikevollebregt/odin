import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../infrastructure/notifiers/responsive_ui.dart';

class FaIconMapper {
  static FaIcon getFaIcon(String? icon) {
    if (icon == null) {
      return const FaIcon(
        FontAwesomeIcons.locationDot,
        color: Color(0xFF00A1CD),
      );
    }

    switch (icon.toLowerCase()) {
      case 'werk':
        return FaIcon(
          FontAwesomeIcons.building,
          color: Color(0xFFF39200),
        );
      case 'thuis':
        return FaIcon(
          FontAwesomeIcons.house,
          color: Color(0xFFAFCB05),
          size: 24 * f,
        );
      case 'supermarkt':
        return FaIcon(
          FontAwesomeIcons.basketShopping,
          color: Color(0xFFDE84C4),
          size: 24 * f,
        );
      case 'school':
        return FaIcon(
          FontAwesomeIcons.graduationCap,
          color: Color(0xFF72C0D6),
          size: 24 * f,
        );
      case 'lopen':
        return FaIcon(
          FontAwesomeIcons.personWalking,
          color: Color(0xFF33425B),
          size: 24 * f,
        );
      case 'f_niet_elektrisch':
        return FaIcon(
          FontAwesomeIcons.bicycle,
          color: Color(0xFF33425B),
          size: 24 * f,
        );
      case 'f_elektrisch':
        return FaIcon(
          FontAwesomeIcons.bicycle,
          color: Color(0xFF33425B),
          size: 24 * f,
        );
      case 'bus':
        return FaIcon(
          FontAwesomeIcons.bus,
          color: Color(0xFF33425B),
          size: 24 * f,
        );
      case 'tram':
        return FaIcon(
          FontAwesomeIcons.trainTram,
          color: Color(0xFF33425B),
        );
      case 'metro':
        return FaIcon(
          FontAwesomeIcons.train,
          color: Color(0xFF33425B),
        );
      case 'trein':
        return FaIcon(
          FontAwesomeIcons.train,
          color: Color(0xFF33425B),
        );
      case 'autorijden_bestuurder':
        return FaIcon(
          FontAwesomeIcons.car,
          color: Color(0xFF33425B),
        );
      case 'autorijden_passagier':
        return FaIcon(
          FontAwesomeIcons.car,
          color: Color(0xFF33425B),
          size: 24 * f,
        );
      case 'brom_fiets':
        return FaIcon(
          FontAwesomeIcons.motorcycle,
          color: Color(0xFF33425B),
        );
      case 'motor':
        return FaIcon(
          FontAwesomeIcons.motorcycle,
          color: Color(0xFF33425B),
          size: 24 * f,
        );
      case 'truck':
        return FaIcon(
          FontAwesomeIcons.truck,
          color: Color(0xFF33425B),
        );
      case 'arrow-trend-up':
        return FaIcon(
          FontAwesomeIcons.arrowTrendUp,
          color: Color(0xFF33425B),
        );
      case 'onderweg':
        return FaIcon(
          FontAwesomeIcons.road,
          color: Color(0xFF33425B),
        );
      case 'home':
        return FaIcon(
          FontAwesomeIcons.houseChimney,
          color: Color(0xFFC4D55E),
          size: 24 * f,
        );
      case 'exchange-alt':
        return FaIcon(
          FontAwesomeIcons.rightLeft,
          color: Color(0xFF8BC166),
          size: 24 * f,
        );
      case 'suitcase-onpayed':
        return FaIcon(
          FontAwesomeIcons.suitcase,
          color: Color(0xFF81DBDB),
          size: 24 * f,
        );
      case 'suitcase':
        return FaIcon(
          FontAwesomeIcons.suitcase,
          color: Color(0xFF72C0D6),
          size: 24 * f,
        );
      case 'graduation-cap':
        return FaIcon(
          FontAwesomeIcons.graduationCap,
          color: Color(0xFF5590D1),
          size: 24 * f,
        );
      case 'shopping-bag':
        return FaIcon(
          FontAwesomeIcons.bagShopping,
          color: Color(0xFFBA6AD7),
          size: 24 * f,
        );
      case 'coffee':
        return FaIcon(
          FontAwesomeIcons.mugSaucer,
          color: Color(0xFFDE84C4),
          size: 24 * f,
        );
      case 'football-ball':
        return FaIcon(
          FontAwesomeIcons.football,
          color: Color(0xFFDB7758),
          size: 24 * f,
        );
      case 'theater-masks':
        return FaIcon(
          FontAwesomeIcons.masksTheater,
          color: Color(0xFFF3AE46),
          size: 24 * f,
        );
      case 'dice-three':
        return FaIcon(
          FontAwesomeIcons.dice,
          color: Color(0xFFF3AE46),
          size: 24 * f,
        );
      case 'square':
        return FaIcon(
          FontAwesomeIcons.solidSquare,
          color: Color(0xFF33425B),
          size: 24 * f,
        );
      case 'person':
        return FaIcon(
          FontAwesomeIcons.person,
          color: Color(0xFFF3AE46),
          size: 24 * f,
        );
      case 'dolly':
        return FaIcon(
          FontAwesomeIcons.dolly,
          color: Color(0xFFF4CD31),
          size: 24 * f,
        );
      default:
        return FaIcon(
          FontAwesomeIcons.locationDot,
          color: Colors.black87,
          size: 24 * f,
        );
    }
  }
}
