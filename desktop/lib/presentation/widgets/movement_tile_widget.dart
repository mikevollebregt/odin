import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../infastructure/notifiers/movement_notifier.dart';
import '../../infastructure/repositories/dtos/movement_dto.dart';
import '../calendar/color_pallet.dart';
import '../theme/icon_mapper.dart';

class MovementTile extends StatelessWidget {
  const MovementTile(this.movementDto, {super.key});

  final ClassifiedMovement movementDto;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(left: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 4,
            color: ColorPallet.lightGrayishBlue,
            margin: const EdgeInsets.only(right: 10, left: 2),
          ),
          FaIconMapper.getFaIcon(movementDto.transport.name),
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            margin: const EdgeInsets.only(
              left: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movementDto.transport.name, style: Theme.of(context).primaryTextTheme.displayLarge),
                Text('${DateFormat('Hm').format(movementDto.startDate)} - ${DateFormat('Hm').format(movementDto.endDate)}',
                    style: Theme.of(context).primaryTextTheme.bodyLarge)
              ],
            ),
          ),
          // const Expanded(child: SizedBox()),
          //const SizedBox(width: 15),
        ],
      ),
    );
  }
}
