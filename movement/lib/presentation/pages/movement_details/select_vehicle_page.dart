import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../infrastructure/repositories/database/database.dart';
import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/dtos/movement_dto.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../infrastructure/services/localization_service.dart';
import '../../../providers.dart';
import '../../theme/icon_mapper.dart';

class SelectVehiclePage extends ConsumerWidget {
  final MovementDto _movementDto;

  const SelectVehiclePage(this._movementDto);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('SelectVehiclePage::build', '', LogType.Flow);
    final movementNotifier = ref.watch(movementNotifierProvider(_movementDto));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context)
            .translate('movementdetailspage_title')),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20 * y),
        child: FutureBuilder<List<Vehicle>?>(
          future: movementNotifier.getVehicles(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) return const SizedBox();
            final vehicles = snapshot.data!;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return InkWell(
                  onTap: () {
                    movementNotifier.updateMovement(vehicle: vehicle);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.025),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          margin: EdgeInsets.only(left: 25 * x),
                          child: FaIconMapper.getFaIcon(vehicle.icon),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          margin: EdgeInsets.only(left: 15 * x),
                          child: Text(vehicle.name!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
