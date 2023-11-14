import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';
import 'package:movement/providers.dart';

import '../../../../color_pallet.dart';
import '../../../routing/routes.dart';
import '../../../widgets/diagonal_striped_widget.dart';

class MissingTile extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;

  const MissingTile(this.startDate, this.endDate);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionNotifier = ref.watch(versionNotifierProvider);

    return Stack(
      children: [
        Positioned(
          top: 5 * y,
          child: Container(
            height: 80 * y,
            width: MediaQuery.of(context).size.width,
            child: DiagonalStipedWidget(Color(0xFFEBEEF0).withOpacity(0.3), Colors.white, 10 * x, 100),
          ),
        ),
        Container(
          height: 90 * y,
          padding: EdgeInsets.only(left: 10 * x),
          child: Row(
            children: [
              Container(
                width: 4 * x,
                color: ColorPallet.lightGrayishBlue,
                margin: EdgeInsets.only(right: 10 * x, left: 2 * x),
              ),
              SizedBox(width: 15 * x),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Missende data', style: Theme.of(context).primaryTextTheme.headline1),
                  Text('${DateFormat('Hm').format(startDate)} - ${DateFormat('Hm').format(endDate)}', style: Theme.of(context).primaryTextTheme.bodyText1),
                ],
              ),
              Expanded(child: SizedBox()),
              versionNotifier.isInteractionAllowed() ? AddPeriodPopMenu(startDate, endDate) : Container(),
              SizedBox(width: 20 * x),
            ],
          ),
        ),
      ],
    );
  }
}

class AddPeriodPopMenu extends ConsumerWidget {
  final DateTime startDate;
  final DateTime endDate;

  const AddPeriodPopMenu(this.startDate, this.endDate);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(8 * f),
      child: PopupMenuButton<String>(
        color: Colors.white,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'locatie',
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Routes.RouteToPage('stopDetailsPage', context, ref: ref, startDate: startDate, endDate: endDate);
              },
              child: Row(
                children: <Widget>[
                  SizedBox(width: 5 * x),
                  FaIcon(FontAwesomeIcons.locationDot, color: ColorPallet.darkTextColor),
                  SizedBox(width: 17 * x),
                  Text('Locatie toevoegen', style: TextStyle(color: ColorPallet.darkTextColor)),
                ],
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'verplaatsing',
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Routes.RouteToPage('movementDetailsPage', context, ref: ref, startDate: startDate, endDate: endDate);
              },
              child: Row(
                children: <Widget>[
                  SizedBox(width: 5 * x),
                  FaIcon(FontAwesomeIcons.route, color: ColorPallet.darkTextColor),
                  SizedBox(width: 17 * x),
                  Text('Verplaatsing toevoegen', style: TextStyle(color: ColorPallet.darkTextColor)),
                ],
              ),
            ),
          ),
        ],
        child: const Icon(Icons.more_vert, color: ColorPallet.darkTextColor),
      ),
    );
  }
}
