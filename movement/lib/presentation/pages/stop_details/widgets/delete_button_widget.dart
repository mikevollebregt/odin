import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../../color_pallet.dart';
import '../../../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../../../providers.dart';

class DeleteButton extends ConsumerWidget {
  final StopDto stopDto;
  const DeleteButton(this.stopDto);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopNotifier = ref.watch(stopNotifierProvider(stopDto));
    return InkWell(
      onTap: () {
        stopNotifier.delete();
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.all(8 * f),
        child: Icon(
          Icons.delete,
          size: 30 * f,
          color: ColorPallet.orangeDark,
        ),
      ),
    );
  }
}
