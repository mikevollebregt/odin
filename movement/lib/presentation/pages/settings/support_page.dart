import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:movement/extentions.dart';
import 'package:movement/infrastructure/repositories/dtos/sensor_stats_dto.dart';
import 'package:movement/main.dart';
import 'package:movement/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../color_pallet.dart';
import '../../../infrastructure/notifiers/responsive_ui.dart';
import '../../../text_style.dart';
import '../../widgets/elevated_button.dart';

class SupportPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportNotifier = ref.watch(supportNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Technische hulp'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0 * x),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30 * y),
              Text(
                'Wanneer de app niet goed functioneert kunt u ons bereiken per email of telefoon.\n\nOnze medewerkers kunnen vragen naar onderstaande informatie:',
                style: textStyleAkko16Black.copyWith(height: 1.4),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30 * y),
              UsernameWidget(),
              SizedBox(height: 10 * y),
              if (supportNotifier.sensorStats.isEmpty) Padding(padding: EdgeInsets.all(50 * f), child: Text('Laden...')),
              for (final sensorStatsDto in supportNotifier.sensorStats) SensorStatsWidget(sensorStatsDto),
              SizedBox(height: 5 * y),
              ResetForegroundServiceButton(),
              if (Platform.isAndroid) DisableBatteryOptimalizationButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class UsernameWidget extends StatelessWidget {
  Future<String> getUsername() async => (await SharedPreferences.getInstance()).getString('username') ?? '?';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Gebruikersnaam:', style: textStyleAkko16Black.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(width: 5 * x),
        FutureBuilder<String>(
          future: getUsername(),
          builder: (context, snapshot) {
            return snapshot.hasData == false ? SizedBox() : Text(snapshot.data!, style: textStyleAkko16Black.copyWith(color: ColorPallet.primaryColor));
          },
        ),
      ],
    );
  }
}

class SensorStatsWidget extends StatelessWidget {
  final SensorStatsDto sensorStatsDto;

  const SensorStatsWidget(this.sensorStatsDto);

  @override
  Widget build(BuildContext context) {
    var sensorName = sensorStatsDto.name.toCapitalize();
    sensorName = sensorName == '' ? 'Default' : sensorName;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8 * y),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sensorName.toCapitalize(), style: textStyleAkko16Black.copyWith(fontWeight: FontWeight.bold)),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Laatste meting:'), Text(DateFormat('d MMM - HH:mm').format(sensorStatsDto.lastSeen))]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Aantal metingen:'), Text(sensorStatsDto.count.toString())]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Nauwkeurigheid:'),
            Text(
                '${sensorStatsDto.accuracy25Percentile.toStringAsFixed(0)},   ${sensorStatsDto.accuracy50Percentile.toStringAsFixed(0)},  ${sensorStatsDto.accuracy75Percentile.toStringAsFixed(0)}'),
          ]),
        ],
      ),
    );
  }
}

class ResetForegroundServiceButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportNotifier = ref.watch(supportNotifierProvider);
    if (supportNotifier.sensorsAreRunning) return SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10 * y),
      child: ElevatedIconButtonWidget(
        buttonText: 'Metingen herstarten',
        iconData: Icons.location_on,
        screenWidth: MediaQuery.of(context).size.width,
        buttonColor: ColorPallet.primaryColor,
        onPressed: () {
          supportNotifier.pressedRestart();
          supportNotifier.restartLocationService();
          Fluttertoast.showToast(
            msg: 'Locatie metingen herstart',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        },
      ),
    );
  }
}

class DisableBatteryOptimalizationButton extends ConsumerStatefulWidget {
  @override
  _DisableBatteryOptimalizationButtonState createState() => _DisableBatteryOptimalizationButtonState();
}

class _DisableBatteryOptimalizationButtonState extends ConsumerState<DisableBatteryOptimalizationButton> {
  @override
  void initState() {
    super.initState();
    ref.read(introBatteryNotifierProvider).reset();
  }

  @override
  Widget build(BuildContext context) {
    final introBatteryNotifier = ref.watch(introBatteryNotifierProvider);
    if (introBatteryNotifier.isGranted || introBatteryNotifier.isPressed) return SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10 * y),
      child: ElevatedIconButtonWidget(
        buttonText: 'Batterij beperkingen uitzetten',
        iconData: Icons.battery_6_bar,
        screenWidth: MediaQuery.of(context).size.width,
        buttonColor: ColorPallet.primaryColor,
        onPressed: () async {
          await container.read(introBatteryNotifierProvider).disableBatteryOptimization();
          Fluttertoast.showToast(
            msg: 'Batterij beperkingen uitgeschakeld',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        },
      ),
    );
  }
}
