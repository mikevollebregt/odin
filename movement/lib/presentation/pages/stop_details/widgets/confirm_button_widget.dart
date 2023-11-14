import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';

import '../../../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../../../providers.dart';

class ConfirmButtonWidget extends ConsumerWidget {
  final StopDto _stopDto;

  const ConfirmButtonWidget(this._stopDto);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopNotifier = ref.watch(stopNotifierProvider(_stopDto));
    return InkWell(
      onTap: () {
        if (_stopDto.isComplete) {
          stopNotifier.save();
          Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(
            msg: 'Vul eerst alle velden in',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.all(16 * f),
        child: Icon(
          Icons.check,
          size: 26 * f,
          color: _stopDto.isComplete ? Colors.white : Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}
