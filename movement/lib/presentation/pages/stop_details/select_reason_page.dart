import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../infrastructure/repositories/database/database.dart';
import '../../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../../infrastructure/repositories/log_repository.dart';
import '../../../infrastructure/services/localization_service.dart';
import '../../../providers.dart';
import '../../theme/icon_mapper.dart';

class SelectReasonPage extends ConsumerWidget {
  final StopDto _stopDto;

  const SelectReasonPage(this._stopDto);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('SelectReasonPage::build', '', LogType.Flow);
    final stopNotifier = ref.watch(stopNotifierProvider(_stopDto));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppLocalizations.of(context).translate('locationreasonpage_selectreason')),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20 * y),
        child: FutureBuilder<List<Reason>?>(
          future: stopNotifier.getStopReasons(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) return const SizedBox();
            final reasons = snapshot.data!;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final reason = reasons[index];
                return InkWell(
                  onTap: () {
                    stopNotifier.updateStop(reason: reason);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.025),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          margin: EdgeInsets.only(left: 25 * x),
                          child: FaIconMapper.getFaIcon(reason.icon),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          margin: EdgeInsets.only(left: 15 * x),
                          child: Text(reason.name!),
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
