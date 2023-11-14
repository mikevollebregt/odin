import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../../color_pallet.dart';

class NoDataTile extends ConsumerWidget {
  const NoDataTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 90 * y,
      padding: EdgeInsets.only(left: 10 * x),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 4 * x,
                color: ColorPallet.lightGrayishBlue,
                margin: EdgeInsets.only(right: 10 * x, left: 2 * x),
              ),
              Positioned(
                left: 1 * x,
                top: 40 * y,
                child: Container(
                  height: 6 * y,
                  width: 6 * x,
                  decoration: BoxDecoration(
                    color: ColorPallet.grayTextColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    height: 80 * y,
                    width: 80 * x,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 10 * y, right: 10 * x, left: 5 * x),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorPallet.veryDarkGray, width: 2 * x),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: FaIcon(FontAwesomeIcons.solidClock, size: 25 * f, color: ColorPallet.darkTextColor),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    margin: EdgeInsets.only(left: 5 * x, bottom: 15 * y),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kom later terug om hier verplaatsingen en locaties te zien'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
