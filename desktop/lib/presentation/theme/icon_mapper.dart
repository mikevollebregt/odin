import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FaIconMapper {
  static FaIcon getFaIcon(String? icon) {
    if (icon == null) {
      return const FaIcon(
        FontAwesomeIcons.locationDot,
        color: Colors.green,
      );
    }

    switch (icon.toLowerCase()) {
      case 'werk':
        return const FaIcon(
          FontAwesomeIcons.building,
          color: Color(0xFFF39200),
        );
      case 'thuis':
        return const FaIcon(
          FontAwesomeIcons.house,
          color: Color(0xFFAFCB05),
        );
      case 'supermarkt':
        return const FaIcon(
          FontAwesomeIcons.basketShopping,
          color: Color(0xFFDE84C4),
        );
      case 'school':
        return const FaIcon(
          FontAwesomeIcons.graduationCap,
          color: Color(0xFF72C0D6),
        );
      case 'lopen':
        return const FaIcon(
          FontAwesomeIcons.personWalking,
          color: Color(0xFF33425B),
        );
      case 'walking':
        return const FaIcon(
          FontAwesomeIcons.personWalking,
          color: Color(0xFF33425B),
        );
      case 'f_niet_electrisch':
        return const FaIcon(
          FontAwesomeIcons.bicycle,
          color: Color(0xFF33425B),
        );
      case 'f_electrisch':
        return const FaIcon(
          FontAwesomeIcons.batteryFull,
          color: Color(0xFF33425B),
        );
      case 'bus':
        return const FaIcon(
          FontAwesomeIcons.bus,
          color: Color(0xFF33425B),
        );
      case 'tram':
        return const FaIcon(
          FontAwesomeIcons.trainTram,
          color: Color.fromARGB(255, 2, 2, 2),
        );
      case 'metro':
        return const FaIcon(
          FontAwesomeIcons.train,
          color: Color(0xFF33425B),
        );
      case 'trein':
        return const FaIcon(
          FontAwesomeIcons.train,
          color: Color(0xFF33425B),
        );
      case 'train':
        return const FaIcon(
          FontAwesomeIcons.train,
          color: Color(0xFF33425B),
        );
      case 'autorijden_bestuurder':
        return const FaIcon(
          FontAwesomeIcons.car,
          color: Color(0xFF33425B),
        );
      case 'autorijden_passagier':
        return const FaIcon(
          FontAwesomeIcons.car,
          color: Color(0xFF33425B),
        );
      case 'brom_fiets':
        return const FaIcon(
          FontAwesomeIcons.motorcycle,
          color: Color(0xFF33425B),
        );
      case 'motor':
        return const FaIcon(
          FontAwesomeIcons.motorcycle,
          color: Color(0xFF33425B),
        );
      case 'onderweg':
        return const FaIcon(
          FontAwesomeIcons.road,
          color: Color(0xFF33425B),
        );
      case 'home':
        return const FaIcon(
          FontAwesomeIcons.house,
          color: Color(0xFFC4D55E),
        );
      case 'exchange-alt':
        return const FaIcon(
          FontAwesomeIcons.rightLeft,
          color: Color(0xFF8BC166),
        );
      case 'suitcase-onpayed':
        return const FaIcon(
          FontAwesomeIcons.suitcase,
          color: Color(0xFF81DBDB),
        );
      case 'suitcase':
        return const FaIcon(
          FontAwesomeIcons.suitcase,
          color: Color(0xFF72C0D6),
        );
      case 'graduation-cap':
        return const FaIcon(
          FontAwesomeIcons.graduationCap,
          color: Color(0xFF5590D1),
        );
      case 'shopping-bag':
        return const FaIcon(
          FontAwesomeIcons.bagShopping,
          color: Color(0xFFBA6AD7),
        );
      case 'coffee':
        return const FaIcon(
          FontAwesomeIcons.mugSaucer,
          color: Color(0xFFDE84C4),
        );
      case 'football-ball':
        return const FaIcon(
          FontAwesomeIcons.football,
          color: Color(0xFFDB7758),
        );
      case 'theater-masks':
        return const FaIcon(
          FontAwesomeIcons.masksTheater,
          color: Color(0xFFF3AE46),
        );
      case 'dice-three':
        return const FaIcon(
          FontAwesomeIcons.dice,
          color: Color(0xFFF3AE46),
        );
      case 'square':
        return const FaIcon(
          FontAwesomeIcons.square,
          color: Colors.grey,
        );
      default:
        return const FaIcon(
          FontAwesomeIcons.locationDot,
          color: Colors.black87,
        );
    }
  }
}
