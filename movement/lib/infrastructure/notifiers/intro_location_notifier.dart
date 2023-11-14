import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../providers.dart';
import '../../text_style.dart';
import '../repositories/dtos/enums/log_type.dart';
import '../repositories/log_repository.dart';

class IntroLocationNotifier extends ChangeNotifier {
  bool isGranted = false;
  bool isPressed = false;

  Future<void> checkPermission() async {
    final access = await Geolocator.checkPermission();
    await log('IntroductionPage::askLocationPermission', 'access: $access', LogType.Flow);
    switch (access) {
      case LocationPermission.deniedForever:
        isGranted = false;
        break;
      case LocationPermission.denied:
        isGranted = false;
        break;
      case LocationPermission.always:
        isGranted = true;
        break;
      case LocationPermission.whileInUse:
        isGranted = true;
        break;
      default:
        isGranted = false;
        break;
    }

    isPressed = true;
    notifyListeners();
  }

  Future<void> askLocationPermission() async {
    await Geolocator.requestPermission();
  }

  Future<void> locationPermissionAlert(BuildContext context, WidgetRef ref) async {
    final notifier = ref.watch(introLocationNotifierProvider);
    if (!notifier.isGranted) {
      await showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('De Onderweg in Nederland app heeft locatiegegevens in de achtergrond nodig', style: textStyleSourceSans20),
          content: Text('Selecteer in instellingen de optie \'altijd toestaan \'', style: textStyleSourceSans16Black),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                await notifier.checkPermission();
              },
              child: Text('Sluiten', style: textStyleSourceSans18),
            ),
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
              },
              child: Text('Instellingen', style: textStyleSourceSans18),
            ),
          ],
        ),
      );
    }
  }
}
